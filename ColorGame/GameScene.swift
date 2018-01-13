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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.previousLocation(in: self)
            let node = self.nodes(at: touchLocation).first
            
            if node?.name == "right" {
                print("Move right")
            } else if node?.name == "up" {
                moveVertically(upPressed: true)
            } else if node?.name == "down" {
                moveVertically(upPressed: false)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerSprite?.removeAllActions()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerSprite?.removeAllActions()
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
    
    func moveVertically (upPressed: Bool) {
        if upPressed {
            let moveAction = SKAction.moveBy(x: 0, y: 3, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            playerSprite?.run(repeatAction)
        } else {
            let moveAction = SKAction.moveBy(x: 0, y: -3, duration: 0.01)
            let repeatAction = SKAction.repeatForever(moveAction)
            playerSprite?.run(repeatAction)
        }
    }
}
