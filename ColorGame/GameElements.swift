//
//  GameElements.swift
//  ColorGame
//
//  Created by ClementM on 14/01/2018.
//  Copyright © 2018 ClementM. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Enemy: Int {
    case small
    case medium
    case large
}

extension GameScene {
    
    func createHUD() {
        pauseSprite = self.childNode(withName: "pause") as? SKSpriteNode
        timeLabel = self.childNode(withName: "time") as? SKLabelNode
        scoreLabel = self.childNode(withName: "score") as? SKLabelNode
        
        remainingTime = 60
        currentScore = 0
    }
    
    func setupTracks() {
        for i in 0...8 {
            if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
                tracksArray?.append(track)
            }
        }
    }
    
    func createPlayer() {
        playerSprite = SKSpriteNode(imageNamed: "player")
        playerSprite?.physicsBody = SKPhysicsBody(circleOfRadius: playerSprite!.size.width / 2)
        playerSprite?.physicsBody?.linearDamping = 0
        playerSprite?.physicsBody?.categoryBitMask = playerSpriteCategory
        playerSprite?.physicsBody?.collisionBitMask = 0
        playerSprite?.physicsBody?.contactTestBitMask = enemySpriteCategory | targetSpriteCategory | powerUpSpriteCategory
        
        guard let playerXPosition = tracksArray?.first?.position.x else { return }
        playerSprite?.position = CGPoint(x: playerXPosition, y: self.size.height / 2)
        
        self.addChild(playerSprite!)
        
        let pulseEmitter = SKEmitterNode(fileNamed: "pulse")!
        playerSprite?.addChild(pulseEmitter)
        pulseEmitter.position = CGPoint(x: 0, y: 0)
    }
    
    func createEnemy(type: Enemy, forTrack track: Int) -> SKShapeNode? {
        let enemySprite = SKShapeNode()
        enemySprite.name = "ENEMY"
        
        switch type {
        case .small:
            enemySprite.path = CGPath(roundedRect: CGRect(x: -10, y: 0, width: 20, height: 70), cornerWidth: 8, cornerHeight: 8, transform: nil)
            enemySprite.fillColor = UIColor(red: 0.4431, green: 0.5529, blue: 0.7451, alpha: 1)
        case .medium:
            enemySprite.path = CGPath(roundedRect: CGRect(x: -10, y: 0, width: 20, height: 100), cornerWidth: 8, cornerHeight: 8, transform: nil)
            enemySprite.fillColor = UIColor(red: 0.7804, green: 0.4039, blue: 0.4039, alpha: 1)
        case .large:
            enemySprite.path = CGPath(roundedRect: CGRect(x: -10, y: 0, width: 20, height: 130), cornerWidth: 8, cornerHeight: 8, transform: nil)
            enemySprite.fillColor = UIColor(red: 0.7804, green: 0.6392, blue: 0.4039, alpha: 1)
        }
        
        guard let enemyPosition = tracksArray?[track].position else { return nil }
        
        let up = enemiesGoingUpArray[track]
        
        enemySprite.position.x = enemyPosition.x
        enemySprite.position.y = up ? -130 : self.size.height + 130
        
        enemySprite.physicsBody = SKPhysicsBody(edgeLoopFrom: enemySprite.path!)
        enemySprite.physicsBody?.categoryBitMask = enemySpriteCategory
        enemySprite.physicsBody?.velocity = up ? CGVector(dx: 0, dy: velocityArray[track]) : CGVector(dx: 0, dy: -velocityArray[track])
        
        return enemySprite
    }
    
    func createTarget() {
        targetSprite = self.childNode(withName: "target") as? SKSpriteNode
        targetSprite?.physicsBody = SKPhysicsBody(circleOfRadius: targetSprite!.size.width / 2)
        targetSprite?.physicsBody?.categoryBitMask = targetSpriteCategory
        targetSprite?.physicsBody?.collisionBitMask = 0
    }
    
    func createPowerUp(forTrack track: Int) -> SKSpriteNode? {
        let powerUpSprite = SKSpriteNode(imageNamed: "powerUp")
        powerUpSprite.name = "ENEMY"
        
        powerUpSprite.physicsBody = SKPhysicsBody(circleOfRadius: powerUpSprite.size.width / 2)
        powerUpSprite.physicsBody?.linearDamping = 0
        powerUpSprite.physicsBody?.categoryBitMask = powerUpSpriteCategory
        powerUpSprite.physicsBody?.collisionBitMask = 0
        
        
        let up = enemiesGoingUpArray[track]
        guard let powerUpXPosition = tracksArray?[track].position.x else { return nil }
        
        powerUpSprite.position.x = powerUpXPosition
        powerUpSprite.position.y = up ? -130 : self.size.height + 130
        
        powerUpSprite.physicsBody?.velocity = up ? CGVector(dx: 0, dy: velocityArray[track]) : CGVector(dx: 0, dy: -velocityArray[track])
        
        return powerUpSprite
    }
}
