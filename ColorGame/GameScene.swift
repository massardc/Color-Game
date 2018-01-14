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
    
    // MARK: - Game Variables
    // MARK: Arrays
    var tracksArray: [SKSpriteNode]? = [SKSpriteNode]()
    let trackVelocities = [180, 200, 250]
    var velocityArray = [Int]()
    var enemiesGoingUpArray = [Bool]()
    
    // MARK: Nodes
    var playerSprite: SKSpriteNode?
    var targetSprite: SKSpriteNode?
    
    // MARK: HUD
    var timeLabel: SKLabelNode?
    var scoreLabel: SKLabelNode?
    var currentScore = 0 {
        didSet {
            self.scoreLabel?.text = "SCORE: \(self.currentScore)"
        }
    }
    var remainingTime: TimeInterval = 60 {
        didSet {
            self.timeLabel?.text = "TIME: \(Int(self.remainingTime))"
        }
    }
    
    // MARK: Collision Categories
    let playerSpriteCategory: UInt32 = 0x1 << 0
    let enemySpriteCategory: UInt32 = 0x1 << 1
    let targetSpriteCategory: UInt32 = 0x1 << 2
    let powerUpSpriteCategory: UInt32 = 0x1 << 3
    
    // MARK: Sound
    let moveSound = SKAction.playSoundFileNamed("Sounds/move.wav", waitForCompletion: false)
    var backgroundNoise: SKAudioNode!

    // MARK: Other Variables
    var currentTrack = 0
    var movingToTrack = false

    
    
    // MARK: - Class functions
    // MARK: Entry Point
    override func didMove(to view: SKView) {
        setupTracks()
        createHUD()
        launchGameTimer()
        createPlayer()
        createTarget()
        
        self.physicsWorld.contactDelegate = self
        
        if let musicURL = Bundle.main.url(forResource: "Sounds/background", withExtension: "wav") {
            backgroundNoise = SKAudioNode(url: musicURL)
            addChild(backgroundNoise)
        }
        
        if let numberOfTracks = tracksArray?.count {
            for _ in 0...numberOfTracks {
                let randomIndex  = GKRandomSource.sharedRandom().nextInt(upperBound: 3)
                velocityArray.append(trackVelocities[randomIndex])
                enemiesGoingUpArray.append(GKRandomSource.sharedRandom().nextBool())
            }
        }

        self.run(SKAction.repeatForever(SKAction.sequence([SKAction.run {
            self.spawnEnemies()
            }, SKAction.wait(forDuration: 2)])))
    }
    
    
    // MARK: Touch Control
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.previousLocation(in: self)
            let node = self.nodes(at: touchLocation).first
            
            if node?.name == "right" {
                moveHorizontally()
            } else if node?.name == "up" {
                moveVertically(upPressed: true)
            } else if node?.name == "down" {
                moveVertically(upPressed: false)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !movingToTrack {
            playerSprite?.removeAllActions()
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        playerSprite?.removeAllActions()
    }
    
    // MARK: Update
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if let player = self.playerSprite {
            if player.position.y > self.size.height || player.position.y < 0 {
                movePlayerToStart()
            }
        }
        
        if remainingTime <= 5 {
            timeLabel?.fontColor = UIColor.red
        }
    }
    
}

// MARK: - Contact Delegate
extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var playerBody: SKPhysicsBody
        var otherBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            playerBody = contact.bodyA
            otherBody = contact.bodyB
        } else {
            playerBody = contact.bodyB
            otherBody = contact.bodyA
        }
        
        if playerBody.categoryBitMask == playerSpriteCategory && otherBody.categoryBitMask == enemySpriteCategory {
            self.run(SKAction.playSoundFileNamed("Sounds/fail.wav", waitForCompletion: true))
            movePlayerToStart()
        } else if playerBody.categoryBitMask == playerSpriteCategory && otherBody.categoryBitMask == targetSpriteCategory {
            nextLevel(playerPhysicsBody: playerBody)
        } else if playerBody.categoryBitMask == playerSpriteCategory && otherBody.categoryBitMask == powerUpSpriteCategory {
            self.run(SKAction.playSoundFileNamed("Sounds/powerUp.wav", waitForCompletion: true))
            otherBody.node?.removeFromParent()
            remainingTime += 5
        }
    }
}
