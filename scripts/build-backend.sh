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
BUILD_DIR="build"
WEBAPP_DIR="backend/src/main/webapp"
WAR_FILE="$BUILD_DIR/$PROJECT_NAME.war"
TOMCAT_WEBAPPS_DIR="/opt/homebrew/opt/tomcat@9/libexec/webapps"

# Delete previous build
echo "Deleting previous build..."
brew services stop tomcat@9
rm -rf $BUILD_DIR/*
rm -rf $TOMCAT_WEBAPPS_DIR/$PROJECT_NAME
rm $TOMCAT_WEBAPPS_DIR/$PROJECT_NAME.war

# Create build directory if not exists
mkdir -p $BUILD_DIR

echo "Copying existing WEB-INF directory..."
cp -r $WEBAPP_DIR/WEB-INF $BUILD_DIR/
mkdir -p $BUILD_DIR/WEB-INF/classes

# Compile Java code
echo "Compiling Java code..."
find backend/src/main -name "*.java" | xargs javac -cp "lib/*" -d $BUILD_DIR/WEB-INF/classes

# Create WAR file
echo "Packaging WAR file..."
jar -cvf $WAR_FILE -C $BUILD_DIR .

echo "Build complete."