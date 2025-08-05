#!/bin/bash

# Swift compilation check for PrincessSavesTheKing
# Works with just Command Line Tools

echo "🔍 Swift Compilation Check"
echo "========================="

# Check Swift version
echo "Swift version:"
swift --version

echo -e "\n📄 Checking Swift file compilation..."

# Create a temporary module map
TEMP_DIR=$(mktemp -d)
MODULE_NAME="PrincessSavesTheKing"

# Find all Swift files
SWIFT_FILES=$(find PrincessSavesTheKing -name "*.swift" -type f | grep -v Tests)

# Try to compile each file individually to find errors
ERROR_COUNT=0
WARNING_COUNT=0

for file in $SWIFT_FILES; do
    echo -n "Checking $file... "
    
    # Try to parse the Swift file
    if xcrun swiftc -parse -sdk $(xcrun --show-sdk-path) "$file" 2>&1 | grep -E "(error|warning):" > /dev/null; then
        echo "❌ Issues found"
        echo "Errors/Warnings in $file:"
        xcrun swiftc -parse -sdk $(xcrun --show-sdk-path) "$file" 2>&1 | grep -E "(error|warning):" | head -10
        ((ERROR_COUNT++))
    else
        echo "✅ OK"
    fi
done

# Summary
echo -e "\n📊 Summary:"
echo "Total files checked: $(echo "$SWIFT_FILES" | wc -l | tr -d ' ')"
echo "Files with issues: $ERROR_COUNT"

# Try to analyze imports and dependencies
echo -e "\n📦 Import Analysis:"
grep -h "^import" $SWIFT_FILES | sort | uniq | while read import; do
    echo "  $import"
done

# Clean up
rm -rf "$TEMP_DIR"

echo -e "\n✨ Check complete!"