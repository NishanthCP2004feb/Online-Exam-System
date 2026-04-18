$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$srcDir = Join-Path $projectRoot "src"
$outputDir = Join-Path $projectRoot "web\WEB-INF\classes"
$buildLibDir = Join-Path $projectRoot ".build-cache\lib"
$preferredTomcatServletJar = "C:\xampp\tomcat\lib\servlet-api.jar"
$fallbackServletApiJar = Join-Path $env:USERPROFILE ".m2\repository\javax\servlet\javax.servlet-api\4.0.1\javax.servlet-api-4.0.1.jar"
$mysqlJar = Join-Path $projectRoot "web\WEB-INF\lib\mysql-connector-j-8.4.0.jar"

$servletApiJar = if (Test-Path $preferredTomcatServletJar) { $preferredTomcatServletJar } else { $fallbackServletApiJar }

if (-not (Test-Path $servletApiJar)) {
    throw "Servlet API jar not found at $servletApiJar"
}

if (-not (Test-Path $mysqlJar)) {
    throw "MySQL connector jar not found at $mysqlJar"
}

if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir | Out-Null
}

if (-not (Test-Path $buildLibDir)) {
    New-Item -ItemType Directory -Path $buildLibDir -Force | Out-Null
}

$localServletApiJar = Join-Path $buildLibDir "javax.servlet-api-4.0.1.jar"
$localMysqlJar = Join-Path $buildLibDir "mysql-connector-j-8.4.0.jar"

Copy-Item -LiteralPath $servletApiJar -Destination $localServletApiJar -Force
Copy-Item -LiteralPath $mysqlJar -Destination $localMysqlJar -Force

$sourceFiles = Get-ChildItem -Path $srcDir -Recurse -Filter *.java | ForEach-Object { $_.FullName }
if (-not $sourceFiles) {
    throw "No Java source files found under $srcDir"
}

$classpath = "$localServletApiJar;$localMysqlJar"

javac -encoding UTF-8 -cp $classpath -d $outputDir $sourceFiles
if ($LASTEXITCODE -ne 0) {
    throw "Compilation failed."
}

Write-Host "Compilation completed. Classes written to $outputDir"
