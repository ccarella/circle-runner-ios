//
//  PrincessSavesTheKingUITests.swift
//  PrincessSavesTheKingUITests
//
//  Created by Chris Carella on 8/4/25.
//

import XCTest

final class PrincessSavesTheKingUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UITesting"]
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    // MARK: - Menu Tests
    
    @MainActor
    func testMenuSceneElements() throws {
        app.launch()
        
        // Wait for menu to load
        let menuView = app.otherElements["MenuScene"]
        XCTAssertTrue(menuView.waitForExistence(timeout: 2))
        
        // Check for title
        XCTAssertTrue(app.staticTexts["Princess Saves"].exists)
        XCTAssertTrue(app.staticTexts["The King"].exists)
        
        // Check for play button
        let playButton = app.buttons["PlayButton"]
        XCTAssertTrue(playButton.exists)
        
        // Check for best score label
        let bestScoreLabel = app.staticTexts["BestScoreLabel"]
        XCTAssertTrue(bestScoreLabel.exists)
    }
    
    @MainActor
    func testStartGameFromMenu() throws {
        app.launch()
        
        // Tap play button
        let playButton = app.buttons["PlayButton"]
        XCTAssertTrue(playButton.waitForExistence(timeout: 2))
        playButton.tap()
        
        // Verify game scene loads
        let gameScene = app.otherElements["GameScene"]
        XCTAssertTrue(gameScene.waitForExistence(timeout: 2))
        
        // Verify score label exists
        let scoreLabel = app.staticTexts["ScoreLabel"]
        XCTAssertTrue(scoreLabel.exists)
    }
    
    // MARK: - Gameplay Tests
    
    @MainActor
    func testJumpMechanic() throws {
        app.launch()
        
        // Start game
        let playButton = app.buttons["PlayButton"]
        playButton.tap()
        
        // Wait for game to start
        let gameScene = app.otherElements["GameScene"]
        XCTAssertTrue(gameScene.waitForExistence(timeout: 2))
        
        // Perform jump by tapping
        gameScene.tap()
        
        // Verify princess jumped (would need to check position or animation state)
        // This would require accessibility identifiers on the princess sprite
        let princess = app.otherElements["Princess"]
        XCTAssertTrue(princess.exists)
    }
    
    @MainActor
    func testGameOver() throws {
        app.launch()
        
        // Start game
        app.buttons["PlayButton"].tap()
        
        // Wait for game to start
        let gameScene = app.otherElements["GameScene"]
        XCTAssertTrue(gameScene.waitForExistence(timeout: 2))
        
        // Wait for game over (in a real test, you'd simulate collision)
        // For now, we'll just wait for the game over scene to eventually appear
        let gameOverScene = app.otherElements["GameOverScene"]
        
        // Note: This test would need a way to trigger game over reliably
        // Could add a debug command or test mode
    }
    
    @MainActor
    func testRetryAfterGameOver() throws {
        app.launch()
        app.launchArguments.append("TestGameOver") // Special flag to trigger immediate game over
        
        // Start game
        app.buttons["PlayButton"].tap()
        
        // Wait for game over
        let gameOverScene = app.otherElements["GameOverScene"]
        XCTAssertTrue(gameOverScene.waitForExistence(timeout: 5))
        
        // Check game over elements
        XCTAssertTrue(app.staticTexts["Game Over"].exists)
        XCTAssertTrue(app.staticTexts["FinalScoreLabel"].exists)
        
        // Tap retry button
        let retryButton = app.buttons["RetryButton"]
        XCTAssertTrue(retryButton.exists)
        retryButton.tap()
        
        // Verify back in game
        let gameScene = app.otherElements["GameScene"]
        XCTAssertTrue(gameScene.waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testBackToMenuFromGameOver() throws {
        app.launch()
        app.launchArguments.append("TestGameOver")
        
        // Start game
        app.buttons["PlayButton"].tap()
        
        // Wait for game over
        let gameOverScene = app.otherElements["GameOverScene"]
        XCTAssertTrue(gameOverScene.waitForExistence(timeout: 5))
        
        // Tap menu button
        let menuButton = app.buttons["MenuButton"]
        XCTAssertTrue(menuButton.exists)
        menuButton.tap()
        
        // Verify back at menu
        let menuScene = app.otherElements["MenuScene"]
        XCTAssertTrue(menuScene.waitForExistence(timeout: 2))
    }
    
    // MARK: - Castle Milestone Tests
    
    @MainActor
    func testCastleMilestoneAppears() throws {
        app.launch()
        app.launchArguments.append("TestCastleMilestone") // Special flag to trigger castle at specific score
        
        // Start game
        app.buttons["PlayButton"].tap()
        
        // Wait for castle scene
        let castleScene = app.otherElements["CastleScene"]
        XCTAssertTrue(castleScene.waitForExistence(timeout: 10))
        
        // Verify castle elements
        XCTAssertTrue(app.staticTexts["Castle Milestone!"].exists)
        XCTAssertTrue(app.buttons["ContinueButton"].exists)
    }
    
    // MARK: - Performance Tests
    
    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    @MainActor
    func testGameplayPerformance() throws {
        app.launch()
        
        measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
            app.buttons["PlayButton"].tap()
            
            // Simulate some gameplay
            let gameScene = app.otherElements["GameScene"]
            if gameScene.waitForExistence(timeout: 2) {
                for _ in 0..<10 {
                    gameScene.tap()
                    Thread.sleep(forTimeInterval: 0.5)
                }
            }
        }
    }
}
