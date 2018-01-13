//
//  GameScene.swift
//  ColorGame
//
//  Created by ClementM on 13/01/2018.
//  Copyright © 2018 ClementM. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Variables
    var tracksArray = [SKSpriteNode]()
    var playerSprite: SKSpriteNode?
    
    // MARK: - Class functions
    override func didMove(to view: SKView) {
        setupTracks()
        createPlayer()
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // MARK: - Custom functions
    func setupTracks() {
        for i in 0...8 {
            if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
                tracksArray.append(track)
            }
        }
    }
    
    func createPlayer() {
        playerSprite = SKSpriteNode(imageNamed: "player")
        guard let playerXPosition = tracksArray.first?.position.x else { return }
        playerSprite?.position = CGPoint(x: playerXPosition, y: self.size.height / 2)
        
        self.addChild(playerSprite!)
    }
}
