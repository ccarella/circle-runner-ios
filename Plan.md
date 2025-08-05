# Princess Saves the King - Implementation Plan

## Project Overview
Transform the existing Circle Runner codebase into "Princess Saves the King" - a narrative endless runner with watercolor-inspired visuals, castle milestones, and GameKit integration.

**Key Features:**
- Auto-running Princess character with tap-to-jump mechanics
- 10 castle milestones (every 5 minutes)
- 9 unique frog encounters before finding the King
- Watercolor-inspired art style with orange-dominant palette
- Full GameKit integration for leaderboards and social features
- Original soundtrack that evolves with progression

---

## Phase 1: Core Game Refactoring

### 1.1 Project Setup
- [ ] Rename project from `aug42025` to `PrincessSavesTheKing`
- [ ] Update app display name in Info.plist
- [ ] Update bundle identifier to com.yourcompany.princesssavestheking
- [ ] Update project scheme name
- [ ] Clean up old Circle Runner references

### 1.2 Folder Restructure
- [ ] Create new folder structure:
  ```
  PrincessSavesTheKing/
  ├── App/
  ├── Game/
  │   ├── Scenes/
  │   ├── Entities/
  │   ├── Systems/
  │   └── Components/
  ├── Art/
  │   ├── Characters/
  │   ├── Environment/
  │   └── UI/
  ├── Audio/
  │   ├── Music/
  │   └── SFX/
  └── Services/
  ```
- [ ] Move existing files to appropriate folders
- [ ] Update file imports and references

### 1.3 Character System
- [ ] Create Princess entity class
- [ ] Implement sprite-based rendering (replace shape nodes)
- [ ] Create animation state machine
- [ ] Add animation states:
  - [ ] Idle
  - [x] Running (Done: rolling animation implemented)
  - [ ] Jumping
  - [ ] Landing
  - [ ] Celebration (for castle arrivals)
- [ ] Implement sprite sheet loading system
- [x] Add particle trail effect for Princess (Done: rolling ball trail effect added)

### 1.4 Visual Overhaul
- [x] Create new color palette with orange dominance (Done: pastel palette implemented)
- [x] Replace current ColorPalette.swift with watercolor theme (Done: pastel colors added)
- [ ] Implement gradient sky system
- [ ] Add time-of-day progression
- [ ] Create soft shadow rendering
- [ ] Add bloom/glow effects for magical elements

---

## Phase 2: Narrative & Progression

### 2.1 Castle Milestone System
- [ ] Create CastleManager class
- [ ] Implement 5-minute timer system
- [ ] Create castle arrival detection
- [ ] Add castle approach visual indicators
- [ ] Implement game pause during castle scenes
- [ ] Create save system for castle progress
- [ ] Add castle counter to HUD

### 2.2 Frog System
- [ ] Create Frog entity class
- [ ] Design data structure for frog variations
- [ ] Implement 9 unique frog characters:
  - [ ] Frog 1: "The King went for a walk... somewhere"
  - [ ] Frog 2: "He mentioned something about another castle"
  - [ ] Frog 3: "I think he's playing hide and seek"
  - [ ] Frog 4: "He left his crown here, so he'll be back"
  - [ ] Frog 5: "Try the next castle, I'm pretty sure"
  - [ ] Frog 6: "He was here yesterday... or was it last week?"
  - [ ] Frog 7: "Almost there! I think..."
  - [ ] Frog 8: "Next castle for sure! Maybe..."
  - [ ] Frog 9: "OK, he's definitely in the next one"
- [ ] Create dialogue presentation system
- [ ] Add frog encounter animations

### 2.3 King Finale
- [ ] Create King character entity
- [ ] Design rescue sequence
- [ ] Implement celebration animation
- [ ] Create ending cutscene system
- [ ] Add credits sequence
- [ ] Implement "Play Again" with New Game+

### 2.4 Level Generation Enhancement
- [ ] Create themed zone system (forest → meadow → mountain)
- [ ] Implement progressive difficulty curve
- [ ] Add new obstacle types:
  - [ ] Rocks (various sizes)
  - [ ] Pits/gaps
  - [ ] Logs
  - [ ] Bushes
  - [ ] Small animals (non-harmful, visual variety)
- [ ] Create obstacle pattern templates
- [ ] Implement fairness checker
- [ ] Add environmental props:
  - [ ] Background trees
  - [ ] Flowers
  - [ ] Mushrooms
  - [ ] Fireflies
  - [ ] Birds

---

## Phase 3: GameKit Integration

### 3.1 Authentication
- [ ] Create GameKitManager service
- [ ] Implement player authentication flow
- [ ] Add authentication UI prompts
- [ ] Handle offline mode gracefully
- [ ] Create player profile storage
- [ ] Add "Sign in with Apple" option

### 3.2 Leaderboards
- [ ] Configure leaderboard in App Store Connect
- [ ] Implement score submission system
- [ ] Create leaderboard IDs:
  - [ ] Global high score
  - [ ] Weekly high score
  - [ ] Most castles reached
- [ ] Add leaderboard view controller
- [ ] Implement friend leaderboard filtering
- [ ] Add score animation on submission

### 3.3 Achievements
- [ ] Design achievement system
- [ ] Create achievements:
  - [ ] First Castle
  - [ ] Frog Collector (meet all frogs)
  - [ ] Save the King
  - [ ] Speed Runner (reach castle in record time)
  - [ ] Marathon Runner (play for 30 minutes)
  - [ ] Perfect Run (no hits for 5 minutes)
- [ ] Implement achievement notifications
- [ ] Add achievement gallery

### 3.4 Social Features
- [ ] Add share button for scores
- [ ] Implement replay recording system
- [ ] Create shareable score cards
- [ ] Add challenge friend functionality

---

## Phase 4: Art & Audio

### 4.1 Character Art
- [ ] Princess sprite sheet (128x128 per frame)
  - [ ] Run cycle (8 frames)
  - [ ] Jump animation (6 frames)
  - [ ] Land animation (4 frames)
  - [ ] Idle breathing (4 frames)
  - [ ] Celebration (8 frames)
- [ ] 9 unique frog designs
  - [ ] Base frog template
  - [ ] Unique accessories/colors for each
- [ ] King character design
  - [ ] Idle animation
  - [ ] Wave animation
  - [ ] Reunion animation
- [ ] Create character shadows

### 4.2 Environment Art
- [ ] Forest tileset
  - [ ] Ground tiles (grass, dirt, stone)
  - [ ] Platform variations
  - [ ] Background layers (3 parallax levels)
- [ ] Castle designs (10 variations)
- [ ] Obstacle sprites
  - [ ] Rock variations (3 sizes)
  - [ ] Log obstacles
  - [ ] Bush variants
- [ ] Environmental decorations
  - [ ] Flowers (5 types)
  - [ ] Mushrooms (3 types)
  - [ ] Trees (background)
  - [ ] Clouds
- [ ] Particle effects
  - [ ] Dust clouds
  - [ ] Sparkles
  - [ ] Leaves falling
  - [ ] Fireflies

### 4.3 UI Art
- [ ] Main menu background
- [ ] Button designs (watercolor style)
- [ ] Dialog boxes for frog messages
- [ ] Castle approach banner
- [ ] Score display styling
- [ ] Pause menu design
- [ ] Game over screen
- [ ] Leaderboard UI styling

### 4.4 Audio Implementation
- [ ] Integrate AVAudioEngine
- [ ] Create audio mixing system
- [ ] Implement dynamic music system
- [ ] Add crossfade between tracks

### 4.5 Music Tracks
- [ ] Main menu theme
- [ ] Forest zone (Castles 1-3)
- [ ] Meadow zone (Castles 4-6)
- [ ] Mountain zone (Castles 7-9)
- [ ] Final approach (Castle 10)
- [ ] King's theme
- [ ] Game over melody
- [ ] Castle arrival fanfare
- [ ] Frog encounter jingle
- [ ] Victory celebration

### 4.6 Sound Effects
- [ ] Footsteps (grass, stone, dirt)
- [ ] Jump sound
- [ ] Landing sound (soft, hard)
- [ ] Obstacle collision
- [ ] Castle door opening
- [ ] Frog greeting sounds (9 variations)
- [ ] King's voice clips
- [ ] UI sounds (button press, menu navigation)
- [ ] Ambient forest sounds
- [ ] Collectible/powerup sounds (future)

---

## Phase 5: Polish & Optimization

### 5.1 UI/UX Improvements
- [ ] Redesign main menu with story theme
- [ ] Add intro story sequence
- [ ] Create settings menu:
  - [ ] Music volume
  - [ ] SFX volume
  - [ ] Haptics toggle
  - [ ] Colorblind mode
- [ ] Implement pause functionality
- [ ] Add tutorial for first-time players
- [ ] Create smooth scene transitions
- [ ] Add loading screens with tips

### 5.2 Visual Polish
- [ ] Implement screen shake on collision
- [ ] Add slow-motion effect for near-misses
- [ ] Create weather effects (optional)
- [ ] Add foreground blur elements
- [ ] Implement dynamic lighting
- [ ] Add speed lines during fast sections

### 5.3 Performance Optimization
- [ ] Profile and optimize sprite rendering
- [ ] Implement object pooling for obstacles
- [ ] Optimize particle systems
- [ ] Add quality settings:
  - [ ] High (all effects)
  - [ ] Medium (reduced particles)
  - [ ] Low (performance mode)
- [ ] Memory management for long sessions
- [ ] Battery usage optimization
- [ ] Reduce draw calls
- [ ] Texture atlas optimization

### 5.4 Accessibility
- [ ] Add subtitles for dialogue
- [ ] Implement high contrast mode
- [ ] Add reduced motion option
- [ ] Create larger touch targets option
- [ ] Add audio cues for visual elements
- [ ] Implement one-handed mode

### 5.5 Testing
- [ ] Unit tests for game systems
- [ ] UI tests for menu navigation
- [ ] Performance testing on older devices
- [ ] GameKit integration testing
- [ ] Difficulty curve playtesting
- [ ] Long play session testing
- [ ] Memory leak detection
- [ ] Battery drain testing

### 5.6 Analytics Integration
- [ ] Add analytics framework
- [ ] Track key metrics:
  - [ ] Session duration
  - [ ] Castle progression
  - [ ] Common failure points
  - [ ] Feature usage
- [ ] Create analytics dashboard
- [ ] A/B testing framework

---

## Technical Requirements

### Minimum Requirements
- iOS 16.0+
- iPhone 8 or newer
- 150MB storage space

### Frameworks
- [ ] SpriteKit (game engine)
- [ ] GameKit (leaderboards)
- [ ] AVFoundation (audio)
- [ ] CoreHaptics (haptic feedback)
- [ ] StoreKit (future IAP)

### Third-Party Dependencies
- [ ] None initially (evaluate needs)

---

## Future Considerations

### Version 1.1
- [ ] Seasonal events (winter theme, etc.)
- [ ] Daily challenges
- [ ] Power-ups system
- [ ] Character customization
- [ ] New endless mode after completing story

### Version 1.2
- [ ] iPad support
- [ ] Apple TV support
- [ ] Cloud save sync
- [ ] Replay sharing
- [ ] Level editor

### Version 2.0
- [ ] Multiplayer racing
- [ ] New story chapters
- [ ] Boss battles
- [ ] RPG elements
- [ ] Apple Arcade version

---

## Timeline Estimate

**Total Development Time: 15-20 days**

- Phase 1: 2-3 days
- Phase 2: 3-4 days
- Phase 3: 2 days
- Phase 4: 5-7 days (depends on asset creation)
- Phase 5: 3-4 days

---

## Notes

- Prioritize core gameplay before visual polish
- Test on real devices early and often
- Get feedback on difficulty curve
- Keep performance smooth on older devices
- Maintain the magical, storybook feeling throughout