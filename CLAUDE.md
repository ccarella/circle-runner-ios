# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is **Princess Saves the King**, a narrative endless runner game built with SpriteKit. The player controls a Princess character on her quest to save the King, jumping over obstacles through various castle checkpoints. The game features a watercolor-inspired art style with pastel colors and engaging storyline.

## Build and Development Commands

### Building the Project
```bash
# Build for iOS Simulator
xcodebuild -project PrincessSavesTheKing.xcodeproj -scheme PrincessSavesTheKing -destination 'platform=iOS Simulator,name=iPhone 15' build

# Build for device
xcodebuild -project PrincessSavesTheKing.xcodeproj -scheme PrincessSavesTheKing -destination 'generic/platform=iOS' build
```

### Running the Game
```bash
# Run on simulator
xcodebuild -project PrincessSavesTheKing.xcodeproj -scheme PrincessSavesTheKing -destination 'platform=iOS Simulator,name=iPhone 15' run

# Open in Xcode
open PrincessSavesTheKing.xcodeproj
```

### Running Tests
```bash
# Run unit tests
xcodebuild test -project PrincessSavesTheKing.xcodeproj -scheme PrincessSavesTheKing -destination 'platform=iOS Simulator,name=iPhone 15'

# Run UI tests
xcodebuild test -project PrincessSavesTheKing.xcodeproj -scheme PrincessSavesTheKingUITests -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Architecture

The project follows a SpriteKit game architecture:

### Core Structure
```
PrincessSavesTheKing/
├── App/
│   ├── PrincessSavesTheKingApp.swift    # UIKit app delegate
│   ├── GameViewController.swift  # Main view controller hosting SpriteKit
│   └── ContentView.swift        # SwiftUI content view
├── Game/
│   ├── Scenes/
│   │   ├── MenuScene.swift      # Main menu with play button and settings
│   │   ├── GameScene.swift      # Core gameplay logic
│   │   └── GameOverScene.swift  # Game over screen with retry
│   ├── Systems/
│   │   └── Physics.swift        # Physics constants and categories
│   ├── Entities/                # Game entity classes (to be added)
│   └── Components/              # Reusable game components (to be added)
├── Art/
│   ├── Characters/              # Character sprites and animations
│   ├── Environment/             # Background and obstacle art
│   └── UI/                      # UI visual assets
├── Audio/
│   ├── Music/                   # Background music tracks
│   └── SFX/                     # Sound effects
├── Services/
│   └── Haptics.swift           # Haptic feedback manager
├── UI/
│   └── ColorPalette.swift      # Color theme definitions
└── Assets.xcassets/            # Xcode asset catalog
```

### Key Game Systems

1. **Physics System**
   - Gravity: -9.8 × 3.5
   - Jump impulse: 75 (recently adjusted for better gameplay)
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