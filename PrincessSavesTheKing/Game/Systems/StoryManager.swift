//
//  StoryManager.swift
//  PrincessSavesTheKing
//
//  Created by Assistant on 8/5/25.
//

import Foundation

// Story content for different game moments
struct StoryMoment {
    let id: String
    let text: String
    let duration: TimeInterval
    let position: StoryTextPosition
}

enum StoryTextPosition {
    case top
    case bottom
    case center
}

class StoryManager {
    
    static let shared = StoryManager()
    
    // MARK: - Story Content
    
    private let introStory = StoryMoment(
        id: "intro",
        text: "Princess heard the news - her father, the King, had gone missing! Without hesitation, she began her quest...",
        duration: 4.0,
        position: .top
    )
    
    private let runningStartStory = StoryMoment(
        id: "running_start",
        text: "Her royal training would finally be put to the test!",
        duration: 3.0,
        position: .bottom
    )
    
    private let milestoneStories: [StoryMoment] = [
        StoryMoment(id: "milestone_1", text: "The journey has just begun...", duration: 2.5, position: .bottom),
        StoryMoment(id: "milestone_2", text: "Princess's determination grows stronger!", duration: 2.5, position: .bottom),
        StoryMoment(id: "milestone_3", text: "Nothing can stop her now!", duration: 2.5, position: .bottom),
        StoryMoment(id: "milestone_4", text: "The castles must be getting closer...", duration: 2.5, position: .bottom),
        StoryMoment(id: "milestone_5", text: "Princess remembers her father's smile.", duration: 3.0, position: .bottom),
        StoryMoment(id: "milestone_6", text: "She can almost feel his presence!", duration: 2.5, position: .bottom),
        StoryMoment(id: "milestone_7", text: "The kingdom needs their King back!", duration: 2.5, position: .bottom),
        StoryMoment(id: "milestone_8", text: "Princess won't give up, no matter what!", duration: 2.5, position: .bottom),
        StoryMoment(id: "milestone_9", text: "Her heart beats with hope and courage!", duration: 2.5, position: .bottom)
    ]
    
    private let castleApproachStories: [StoryMoment] = [
        StoryMoment(id: "approach_1", text: "A castle appears on the horizon!", duration: 2.0, position: .top),
        StoryMoment(id: "approach_2", text: "Could the King be in this castle?", duration: 2.0, position: .top),
        StoryMoment(id: "approach_3", text: "Princess's heart races with anticipation!", duration: 2.0, position: .top),
        StoryMoment(id: "approach_4", text: "This castle looks promising!", duration: 2.0, position: .top),
        StoryMoment(id: "approach_5", text: "She can see the castle towers ahead!", duration: 2.0, position: .top),
        StoryMoment(id: "approach_6", text: "The castle guards might have seen the King!", duration: 2.0, position: .top),
        StoryMoment(id: "approach_7", text: "Princess feels she's getting closer!", duration: 2.0, position: .top),
        StoryMoment(id: "approach_8", text: "This castle seems different somehow...", duration: 2.0, position: .top),
        StoryMoment(id: "approach_9", text: "The final castle must be near!", duration: 2.0, position: .top),
        StoryMoment(id: "approach_10", text: "This is it! The final castle!", duration: 2.0, position: .top)
    ]
    
    private let obstacleReactions: [String] = [
        "Watch out!",
        "Jump, Princess!",
        "A rock ahead!",
        "Careful!",
        "Stay focused!"
    ]
    
    private let powerupStory = StoryMoment(
        id: "powerup",
        text: "A magical star! Princess feels invincible!",
        duration: 2.0,
        position: .center
    )
    
    // Enhanced frog dialogue introductions
    private let frogIntroductions: [String] = [
        "A friendly frog appears at the castle gate...",
        "The castle guardian greets the Princess...",
        "A wise frog awaits with information...",
        "The castle's amphibian keeper has news...",
        "A royal advisor in frog form speaks up...",
        "The castle's frog herald has a message...",
        "A mystical frog offers guidance...",
        "The frog gatekeeper shares what they know...",
        "An enchanted frog provides a clue...",
        "The King's loyal frog friend appears..."
    ]
    
    // MARK: - Story Progression Tracking
    
    private var shownStories = Set<String>()
    private var currentMilestone = 0
    private var lastObstacleReactionTime: TimeInterval = 0
    
    private init() {}
    
    // MARK: - Public Methods
    
    func getIntroStory() -> StoryMoment {
        return introStory
    }
    
    func getRunningStartStory() -> StoryMoment {
        return runningStartStory
    }
    
    func getMilestoneStory(for milestone: Int) -> StoryMoment? {
        // Only show story for first 9 milestones (10-90 seconds)
        guard milestone > 0 && milestone <= milestoneStories.count else { return nil }
        
        let story = milestoneStories[milestone - 1]
        
        // Check if we've already shown this story
        guard !shownStories.contains(story.id) else { return nil }
        
        shownStories.insert(story.id)
        currentMilestone = milestone
        
        return story
    }
    
    func getCastleApproachStory(for castleNumber: Int) -> StoryMoment {
        let index = (castleNumber - 1) % castleApproachStories.count
        return castleApproachStories[index]
    }
    
    func getRandomObstacleReaction(currentTime: TimeInterval) -> String? {
        // Only show obstacle reactions occasionally (not more than once every 5 seconds)
        guard currentTime - lastObstacleReactionTime > 5.0 else { return nil }
        
        // Random chance to show reaction (20% chance)
        guard Int.random(in: 0...4) == 0 else { return nil }
        
        lastObstacleReactionTime = currentTime
        return obstacleReactions.randomElement()
    }
    
    func getPowerupStory() -> StoryMoment {
        return powerupStory
    }
    
    func getFrogIntroduction(for castleNumber: Int) -> String {
        let index = (castleNumber - 1) % frogIntroductions.count
        return frogIntroductions[index]
    }
    
    func getEndingNarrative() -> [StoryMoment] {
        return [
            StoryMoment(
                id: "ending_1",
                text: "The Kingdom rejoiced at the return of their King!",
                duration: 3.0,
                position: .center
            ),
            StoryMoment(
                id: "ending_2",
                text: "Princess had proven herself a true hero.",
                duration: 3.0,
                position: .center
            ),
            StoryMoment(
                id: "ending_3",
                text: "And they all lived happily ever after!",
                duration: 4.0,
                position: .center
            )
        ]
    }
    
    // MARK: - Reset
    
    func reset() {
        shownStories.removeAll()
        currentMilestone = 0
        lastObstacleReactionTime = 0
    }
}