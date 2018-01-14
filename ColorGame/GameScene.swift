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
    
    // MARK: Collision Categories
    let playerSpriteCategory: UInt32 = 0x1 << 0
    let enemySpriteCategory: UInt32 = 0x1 << 1
    let targetSpriteCategory: UInt32 = 0x1 << 2
    
    // MARK: Other Variables
    var currentTrack = 0
    var movingToTrack = false
    var moveSound = SKAction.playSoundFileNamed("Sounds/move.wav", waitForCompletion: false)

    
    
    // MARK: - Class functions
    // MARK: Entry Point
    override func didMove(to view: SKView) {
        setupTracks()
        createPlayer()
        createTarget()
        
        self.physicsWorld.contactDelegate = self
        
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
            
            if (node?.name?.contains("right"))! {
                moveHorizontally()
            } else if (node?.name?.contains("up"))! {
                moveVertically(upPressed: true)
            } else if (node?.name?.contains("down"))! {
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
            print("Enemy hit")
        } else if playerBody.categoryBitMask == playerSpriteCategory && otherBody.categoryBitMask == targetSpriteCategory {
            print("Target hit")
        }
    }
}
