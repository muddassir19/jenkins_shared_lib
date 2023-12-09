#using tomcat 8 as base image
FROM tomcat:8
#copy the war file to webapps folder in tomcat
COPY /var/lib/jenkins/workspace/ci-cd/*.war  /usr/local/tomcat/webapps/*.war