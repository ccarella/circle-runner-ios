# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **Circle Runner**, a minimal iOS runner game built with SpriteKit. The player controls a circle that auto-runs to the right, tapping to jump over obstacles. The game features a clean, high-contrast aesthetic with white shapes on a black background.

## Build and Development Commands

### Building the Project
```bash
# Build for iOS Simulator
xcodebuild -project aug42025.xcodeproj -scheme aug42025 -destination 'platform=iOS Simulator,name=iPhone 15' build

# Build for device
xcodebuild -project aug42025.xcodeproj -scheme aug42025 -destination 'generic/platform=iOS' build
```

### Running the Game
```bash
# Run on simulator
xcodebuild -project aug42025.xcodeproj -scheme aug42025 -destination 'platform=iOS Simulator,name=iPhone 15' run

# Open in Xcode
open aug42025.xcodeproj
```

### Running Tests
```bash
# Run unit tests
xcodebuild test -project aug42025.xcodeproj -scheme aug42025 -destination 'platform=iOS Simulator,name=iPhone 15'

# Run UI tests
xcodebuild test -project aug42025.xcodeproj -scheme aug42025UITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture

The project follows a SpriteKit game architecture:

### Core Structure
```
aug42025/
├── App/
│   ├── CircleRunnerApp.swift    # UIKit app delegate
│   └── GameViewController.swift  # Main view controller hosting SpriteKit
├── Game/
│   ├── MenuScene.swift          # Main menu with play button and settings
│   ├── GameScene.swift          # Core gameplay logic
│   ├── GameOverScene.swift      # Game over screen with retry
│   └── Physics.swift            # Physics constants and categories
├── Services/
│   └── Haptics.swift           # Haptic feedback manager
└── Assets.xcassets/            # Game assets
```

### Key Game Systems

1. **Physics System**
   - Gravity: -9.8 × 3.5
   - Jump impulse: 270
   - Categories: player (1), obstacle (2), ground (4)

2. **Jump Mechanics**
   - Coyote time: 80ms grace period after leaving ground
   - Input buffer: 100ms to queue jumps before landing

3. **Difficulty Progression**
   - Speed: 250 pt/s → 600 pt/s (increases 1.5 pt/s per second)
   - Spawn rate: 1.2s → 0.55s over 60 seconds
   - Obstacle size: height 32-120pt, width 24-64pt

4. **Debug Features** (DEBUG builds only)
   - 2-finger tap: Slow motion (0.3×)
   - 3-finger tap: Toggle physics visualization
   - 4-finger tap: Reset best score

### Performance Targets
- 60 FPS on A14+ devices
- < 50 draw calls typical
- < 120 nodes on screen
- Zero allocations in update loop

### Testing Framework

The project uses Apple's Swift Testing framework (not XCTest) as evidenced by the `import Testing` statement in test files. Tests use the `@Test` attribute and `#expect(...)` for assertions.