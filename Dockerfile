FROM tomcat:9.0-jdk17-temurin

WORKDIR /usr/local/tomcat

# Copy app sources and web assets.
COPY src /tmp/src
COPY web /usr/local/tomcat/webapps/examportal

# Compile Java sources into WEB-INF/classes.
RUN mkdir -p /usr/local/tomcat/webapps/examportal/WEB-INF/classes \
    && find /tmp/src -name "*.java" > /tmp/sources.txt \
    && javac -encoding UTF-8 \
       -cp "lib/servlet-api.jar:webapps/examportal/WEB-INF/lib/mysql-connector-j-8.4.0.jar" \
       -d webapps/examportal/WEB-INF/classes \
       @/tmp/sources.txt \
    && rm -rf /tmp/src /tmp/sources.txt

# Render provides the port dynamically via PORT.
CMD sh -c 'sed -i "s/port=\"8080\"/port=\"${PORT:-8080}\"/" conf/server.xml && catalina.sh run'
