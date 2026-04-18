param(
    [string]$AppName = "examportal",
    [string]$XamppRoot = "C:\xampp",
    [string]$DbName = "online_exam_portal",
    [string]$DbUser = "root",
    [string]$DbPassword = "",
    [switch]$InitDb
)

$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$webSource = Join-Path $projectRoot "web"
$schemaFile = Join-Path $projectRoot "sql\schema.sql"
$tomcatRoot = Join-Path $XamppRoot "tomcat"
$mysqlBin = Join-Path $XamppRoot "mysql\bin"
$deployTarget = Join-Path $tomcatRoot "webapps\$AppName"
$mysqlExe = Join-Path $mysqlBin "mysql.exe"
$mysqldExe = Join-Path $mysqlBin "mysqld.exe"
$mysqlConfig = Join-Path $mysqlBin "my.ini"
$tomcatStartup = Join-Path $tomcatRoot "bin\startup.bat"
$tomcatShutdown = Join-Path $tomcatRoot "bin\shutdown.bat"
$appUrl = "http://localhost:8080/$AppName/"

function Get-JavaHome {
    if ($env:JAVA_HOME -and (Test-Path (Join-Path $env:JAVA_HOME "bin\java.exe"))) {
        return $env:JAVA_HOME
    }

    $javaCommand = Get-Command java -ErrorAction SilentlyContinue
    if (-not $javaCommand) {
        throw "Java executable not found in PATH. Install Java or set JAVA_HOME."
    }

    $javaExePath = $javaCommand.Source
    return Split-Path (Split-Path $javaExePath -Parent) -Parent
}

function Wait-ForPort {
    param(
        [int]$Port,
        [int]$TimeoutSeconds = 30
    )

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    while ($stopwatch.Elapsed.TotalSeconds -lt $TimeoutSeconds) {
        $listener = Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue
        if ($listener) {
            return $true
        }
        Start-Sleep -Seconds 1
    }
    return $false
}

function Wait-ForPortToClose {
    param(
        [int]$Port,
        [int]$TimeoutSeconds = 30
    )

    $stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
    while ($stopwatch.Elapsed.TotalSeconds -lt $TimeoutSeconds) {
        $listener = Get-NetTCPConnection -State Listen -LocalPort $Port -ErrorAction SilentlyContinue
        if (-not $listener) {
            return $true
        }
        Start-Sleep -Seconds 1
    }
    return $false
}

function Invoke-MySql {
    param(
        [string]$Sql,
        [switch]$Silent
    )

    $arguments = @("-u", $DbUser)
    if ($DbPassword) {
        $arguments += "-p$DbPassword"
    }
    $arguments += "-e"
    $arguments += $Sql

    if ($Silent) {
        & $mysqlExe @arguments | Out-Null
    } else {
        & $mysqlExe @arguments
    }

    if ($LASTEXITCODE -ne 0) {
        throw "MySQL command failed."
    }
}

function Ensure-MySqlRunning {
    if ((Wait-ForPort -Port 3306 -TimeoutSeconds 2)) {
        Write-Host "MySQL is already listening on port 3306."
        return
    }

    if (-not (Test-Path $mysqldExe)) {
        throw "mysqld.exe not found at $mysqldExe"
    }

    Write-Host "Starting MySQL..."
    Start-Process -FilePath $mysqldExe -ArgumentList "--defaults-file=$mysqlConfig", "--standalone" -WorkingDirectory $mysqlBin | Out-Null

    if (-not (Wait-ForPort -Port 3306 -TimeoutSeconds 30)) {
        throw "MySQL did not start on port 3306."
    }
}

function Ensure-TomcatRunning {
    if ((Wait-ForPort -Port 8080 -TimeoutSeconds 2)) {
        Write-Host "Tomcat is already listening on port 8080."
        return
    }

    if (-not (Test-Path $tomcatStartup)) {
        throw "Tomcat startup script not found at $tomcatStartup"
    }

    $env:JAVA_HOME = (Get-JavaHome)
    Write-Host "Using JAVA_HOME: $env:JAVA_HOME"
    Write-Host "Starting Tomcat..."
    Start-Process -FilePath $tomcatStartup -WorkingDirectory (Split-Path $tomcatStartup -Parent) | Out-Null

    if (-not (Wait-ForPort -Port 8080 -TimeoutSeconds 45)) {
        throw "Tomcat did not start on port 8080."
    }
}

function Restart-Tomcat {
    $env:JAVA_HOME = (Get-JavaHome)

    if ((Wait-ForPort -Port 8080 -TimeoutSeconds 2)) {
        if (-not (Test-Path $tomcatShutdown)) {
            throw "Tomcat shutdown script not found at $tomcatShutdown"
        }

        Write-Host "Restarting Tomcat..."
        Start-Process -FilePath $tomcatShutdown -WorkingDirectory (Split-Path $tomcatShutdown -Parent) -Wait | Out-Null
        if (-not (Wait-ForPortToClose -Port 8080 -TimeoutSeconds 45)) {
            throw "Tomcat did not stop cleanly."
        }
    }

    Start-Process -FilePath $tomcatStartup -WorkingDirectory (Split-Path $tomcatStartup -Parent) | Out-Null
    if (-not (Wait-ForPort -Port 8080 -TimeoutSeconds 45)) {
        throw "Tomcat did not restart on port 8080."
    }
}

function Get-AppResponse {
    try {
        return Invoke-WebRequest -Uri $appUrl -UseBasicParsing
    } catch {
        return $null
    }
}

if (-not (Test-Path $webSource)) {
    throw "Web source directory not found at $webSource"
}

if (-not (Test-Path $mysqlExe)) {
    throw "mysql.exe not found at $mysqlExe"
}

& (Join-Path $projectRoot "build.ps1")

Ensure-MySqlRunning

Invoke-MySql -Sql "CREATE DATABASE IF NOT EXISTS $DbName;" -Silent
if ($InitDb) {
    if (-not (Test-Path $schemaFile)) {
        throw "Schema file not found at $schemaFile"
    }
    Write-Host "Initializing database schema..."
    $arguments = @("-u", $DbUser)
    if ($DbPassword) {
        $arguments += "-p$DbPassword"
    }
    $arguments += $DbName
    Get-Content -Raw $schemaFile | & $mysqlExe @arguments
    if ($LASTEXITCODE -ne 0) {
        throw "Schema initialization failed."
    }
}

if (-not (Test-Path $deployTarget)) {
    New-Item -ItemType Directory -Path $deployTarget -Force | Out-Null
}

Write-Host "Deploying application to $deployTarget ..."
Copy-Item -Path (Join-Path $webSource "*") -Destination $deployTarget -Recurse -Force

Ensure-TomcatRunning

Start-Sleep -Seconds 3
$response = Get-AppResponse
if (-not $response -or $response.StatusCode -ne 200) {
    Restart-Tomcat
    Start-Sleep -Seconds 5
    $response = Get-AppResponse
}

if (-not $response) {
    throw "Application health check failed at $appUrl"
}

Write-Host "Application is ready at $appUrl (HTTP $($response.StatusCode))"
