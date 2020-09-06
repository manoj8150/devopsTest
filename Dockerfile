FROM tomcat:alpine

LABEL maintainer="Manoj Kumar"

RUN wget -O /usr/local/tomcat/webapps/launchstation04.war -U jenkinsuser:manoj@33 http://192.168.43.1:8082/artifactory/myRepo/com/nagarro/devops-tools/devops/demosampleapplication/1.0.0-SNAPSHOT/demosampleapplication-1.0.0-SNAPSHOT.war

EXPOSE 6005

CMD ["catalina.sh", "run"]