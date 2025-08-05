#!/bin/bash

# Build script for PrincessSavesTheKing
# This script allows building from command line and seeing detailed errors

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

PROJECT_NAME="PrincessSavesTheKing"
PROJECT_PATH="$(pwd)/${PROJECT_NAME}.xcodeproj"
SCHEME="${PROJECT_NAME}"

echo "🏗️  Building ${PROJECT_NAME}..."
echo "📁 Project: ${PROJECT_PATH}"

# Check if xcodebuild is available
if ! command -v xcodebuild &> /dev/null; then
    echo -e "${RED}❌ Error: xcodebuild not found. Please install Xcode or Xcode Command Line Tools.${NC}"
    echo "Run: xcode-select --install"
    exit 1
fi

# Clean build folder
echo "🧹 Cleaning build folder..."
if [ -d "build" ]; then
    rm -rf build
fi

# Create build directory
mkdir -p build/logs

# Build for iOS Simulator
echo "🔨 Building for iOS Simulator..."
BUILD_LOG="build/logs/build_$(date +%Y%m%d_%H%M%S).log"

# Run build and capture output
if xcodebuild \
    -project "${PROJECT_PATH}" \
    -scheme "${SCHEME}" \
    -destination 'platform=iOS Simulator,name=iPhone 16,OS=18.6' \
    -derivedDataPath build/DerivedData \
    clean build \
    CODE_SIGN_IDENTITY="" \
    CODE_SIGNING_REQUIRED=NO \
    CODE_SIGNING_ALLOWED=NO \
    2>&1 | tee "${BUILD_LOG}"; then
    
    echo -e "${GREEN}✅ Build succeeded!${NC}"
    echo "📄 Build log saved to: ${BUILD_LOG}"
    
    # Show app location
    APP_PATH=$(find build/DerivedData -name "${PROJECT_NAME}.app" -type d | head -1)
    if [ -n "$APP_PATH" ]; then
        echo "📱 App built at: ${APP_PATH}"
    fi
else
    echo -e "${RED}❌ Build failed!${NC}"
    echo "📄 Full log saved to: ${BUILD_LOG}"
    
    # Extract and display errors
    echo -e "\n${YELLOW}📋 Build Errors:${NC}"
    grep -E "(error:|warning:|failed|FAILED)" "${BUILD_LOG}" | grep -v "grep" || true
    
    # Show last 20 lines of log for context
    echo -e "\n${YELLOW}📋 Last 20 lines of build log:${NC}"
    tail -20 "${BUILD_LOG}"
    
    exit 1
fi