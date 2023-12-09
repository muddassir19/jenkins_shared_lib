#using tomcat 8 as base image
FROM tomcat:8
#copy the war file to webapps folder in tomcat
COPY /home/ec2-user/webapp.war /usr/local/tomcat/webapps/