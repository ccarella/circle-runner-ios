#!/bin/bash

# Diagnostic script for PrincessSavesTheKing project

echo "🔍 Checking PrincessSavesTheKing Project Status..."
echo "================================================"

# Check Xcode command line tools
echo -e "\n📱 Xcode Status:"
if command -v xcodebuild &> /dev/null; then
    echo "✅ xcodebuild found"
    xcodebuild -version
else
    echo "❌ xcodebuild not found"
fi

# Check if we can use xcrun
if command -v xcrun &> /dev/null; then
    echo "✅ xcrun found"
    echo "Developer dir: $(xcode-select -p)"
else
    echo "❌ xcrun not found"
fi

# List Swift files
echo -e "\n📄 Swift Files Structure:"
find PrincessSavesTheKing -name "*.swift" -type f | sort | while read file; do
    echo "  ✓ $file"
done

# Check for missing files referenced in project
echo -e "\n🔍 Checking project file references..."
if [ -f "PrincessSavesTheKing.xcodeproj/project.pbxproj" ]; then
    echo "✅ Project file exists"
    
    # List schemes
    echo -e "\n📋 Available schemes:"
    xcodebuild -project PrincessSavesTheKing.xcodeproj -list 2>/dev/null || echo "Could not list schemes"
else
    echo "❌ Project file not found"
fi

# Check for common issues
echo -e "\n⚠️  Checking for common issues:"

# Check if DerivedData exists
if [ -d ~/Library/Developer/Xcode/DerivedData/PrincessSavesTheKing-* ]; then
    echo "⚠️  Old DerivedData found - consider cleaning"
else
    echo "✅ No old DerivedData found"
fi

# Check if build folder exists
if [ -d "build" ]; then
    echo "⚠️  Build folder exists - will be cleaned during build"
else
    echo "✅ No build folder found"
fi

echo -e "\n✨ Diagnostic complete!"