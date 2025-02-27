FROM tomcat:9.0-jdk17-openjdk

# Set the working directory
WORKDIR /usr/local/tomcat/webapps

# Copy the WAR file into the Tomcat webapps directory
COPY ~/java-workspace/erp-system-root/build/leanX-app.war /usr/local/tomcat/webapps/

# Expose the Tomcat server port (default is 8080)
EXPOSE 8080

# Start Tomcat server
CMD ["catalina.sh", "run"]