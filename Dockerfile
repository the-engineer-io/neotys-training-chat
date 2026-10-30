# Neotys Training Chat – JSP/Servlet chat served at /neotys-chat on Tomcat 9 + Java 8
FROM tomcat:9.0-jdk8-temurin

# Remove Tomcat's default apps; the site root redirects to the chat
RUN rm -rf /usr/local/tomcat/webapps/* \
 && mkdir -p /usr/local/tomcat/webapps/ROOT \
 && printf '<!doctype html><meta http-equiv="refresh" content="0;url=/neotys-chat/"><a href="/neotys-chat/">Neotys Training Chat</a>\n' \
      > /usr/local/tomcat/webapps/ROOT/index.html

# Behind a TLS-terminating proxy (Render etc.): trust X-Forwarded-Proto so redirects stay on https
RUN sed -i 's#</Host>#  <Valve className="org.apache.catalina.valves.RemoteIpValve" protocolHeader="x-forwarded-proto" />\n      </Host>#' \
      /usr/local/tomcat/conf/server.xml

# Deploy as an exploded webapp (the app reads WEB-INF/chat.properties from disk)
COPY webapp /usr/local/tomcat/webapps/neotys-chat
COPY src /tmp/src
RUN mkdir -p /usr/local/tomcat/webapps/neotys-chat/WEB-INF/classes \
 && javac -nowarn -encoding ISO-8859-1 \
      -cp /usr/local/tomcat/lib/servlet-api.jar \
      -d /usr/local/tomcat/webapps/neotys-chat/WEB-INF/classes \
      $(find /tmp/src -name '*.java') \
 && rm -rf /tmp/src

# Fit comfortably in a 512 MB free instance
ENV CATALINA_OPTS="-Xms64m -Xmx256m -XX:+UseSerialGC -Djava.security.egd=file:/dev/./urandom"

EXPOSE 8080
CMD ["sh", "-c", "sed -i \"s/port=\\\"8080\\\"/port=\\\"${PORT:-8080}\\\"/\" /usr/local/tomcat/conf/server.xml && exec catalina.sh run"]
