##########################################################
# File: build.sh                                         #
# Version: 1.0                                           #
# Author: Janis Grüttmüller on 19.02.2025                #
# Description: script to build and push the docker       #
# image of the ERP-system to a remote dockerhub repo     #
#                                                        #
# change history:                                        #
# 19.02.2025 - initial version                           #
##########################################################

#!/bin/bash
set -e  # Exit on any error

# Configuration Variables
DOCKER_REPO="janisgruettmueller"  # docker hub repository namespace
DOCKER_HUB_USERNAME="janisgruettmueller"
APP_NAME="custom-erp-system"
IMAGE_NAME="$DOCKER_REPO/$APP_NAME-backend"
TAG="latest"

APPLICATION_NAME="leanX-app"
BUILD_DIR="build"
WEBAPP_DIR="backend/src/main/webapp"
WAR_FILE="$BUILD_DIR/$APPLICATION_NAME.war"

# Delete previous build
echo "Deleting previous build..."
rm -rf $BUILD_DIR/*

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

# Authenticate using Access Token
echo "Logging in to Docker Hub..."
echo "$DOCKER_HUB_TOKEN" | docker login -u "$DOCKER_HUB_USERNAME" --password-stdin

# Build and Push the Image
echo "Building Docker image..."
docker build -t $IMAGE_NAME:$TAG ./backend

echo "Push Docker image to remote repository..."
docker push $IMAGE_NAME:$TAG

echo "Build completed successfully!"
