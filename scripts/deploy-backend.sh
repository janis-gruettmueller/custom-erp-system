######################################################
# File: deploy-backend.sh
# Version: 1.0
# Author: Janis Grüttmüller on 13.02.2025
# Description: script to build the erp-system (backend)
#
# change history:
# 13.02.2025 - initial version
######################################################

#!/bin/bash

# Variables
PROJECT_NAME="erp-system"
WEBAPP_DIR="backend/src/main/webapp"
WAR_FILE="$BUILD_DIR/$PROJECT_NAME.war"
TOMCAT_WEBAPPS_DIR="/opt/homebrew/opt/tomcat@9/libexec/webapps"

# Copy WAR file to Tomcat
echo "Deploying WAR file to Tomcat..."
cp $WAR_FILE $TOMCAT_WEBAPPS_DIR

# Restart Tomcat
echo "Restarting Tomcat..."
# /opt/homebrew/opt/tomcat@9/libexec/bin/shutdown.sh
# /opt/homebrew/opt/tomcat@9/libexec/bin/startup.sh
brew services start tomcat@9

echo "Deployment complete."