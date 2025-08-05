#!/bin/bash

# Script to help fix Xcode file references after restructuring

echo "Fixing Xcode project file references..."

# Navigate to project directory
cd /Users/ccarella/Projects/aug42025

# Clean build artifacts
echo "Cleaning build artifacts..."
rm -rf ~/Library/Developer/Xcode/DerivedData/PrincessSavesTheKing-*

# The project uses PBXFileSystemSynchronizedRootGroup which should auto-sync
# But we need to ensure Xcode picks up the changes

echo "File structure has been reorganized as follows:"
echo "- Game/Scenes/ now contains: MenuScene.swift, GameScene.swift, GameOverScene.swift"
echo "- Game/Systems/ now contains: Physics.swift"
echo ""
echo "To fix the build errors in Xcode:"
echo "1. Close Xcode completely"
echo "2. Run this command to clean DerivedData: rm -rf ~/Library/Developer/Xcode/DerivedData/PrincessSavesTheKing-*"
echo "3. Reopen Xcode"
echo "4. Clean Build Folder (Cmd+Shift+K)"
echo "5. Build again (Cmd+B)"
echo ""
echo "If issues persist:"
echo "- In Xcode, select the PrincessSavesTheKing folder in the navigator"
echo "- Right-click and choose 'Add Files to PrincessSavesTheKing'"
echo "- Navigate to the Game folder and ensure all subfolders are included"