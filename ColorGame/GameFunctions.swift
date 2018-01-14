//
//  GameFunctions.swift
//  ColorGame
//
//  Created by ClementM on 14/01/2018.
//  Copyright © 2018 ClementM. All rights reserved.
//

import SpriteKit
import GameplayKit

extension GameScene {
    
    func launchGameTimer() {
        let timeAction = SKAction.repeatForever(SKAction.sequence([SKAction.run({
            self.remainingTime -= 1
        }), SKAction.wait(forDuration: 1)]))
        
        timeLabel?.run(timeAction)
    }
    
    func spawnEnemies() {
        
        var randomTrackNumber = 0
        let createPowerUp = GKRandomSource.sharedRandom().nextBool()
        
        // Creates power up
        if createPowerUp {
            randomTrackNumber = GKRandomSource.sharedRandom().nextInt(upperBound: 6) + 1
            if let powerUpObject = self.createPowerUp(forTrack: randomTrackNumber) {
                self.addChild(powerUpObject)
            }
        }
        
        // Creates enmies
        for i in 1...7 {
            if randomTrackNumber != i {
                let randomEnemyType = Enemy(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 3))!
                if let newEnemy = createEnemy(type: randomEnemyType, forTrack: i) {
                    self.addChild(newEnemy)
                }
            }
        }
        
        self.enumerateChildNodes(withName: "ENEMY") { (node: SKNode, nil) in
            if node.position.y < -150 || node.position.y > self.size.height + 150 {
                node.removeFromParent()
            }
        }
    }
    
    func moveVertically(upPressed: Bool) {
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
    
    func moveHorizontally() {
        playerSprite?.removeAllActions()
        movingToTrack = true
        
        if currentTrack + 1 < tracksArray!.count {
            guard let nextTrack = tracksArray?[currentTrack + 1].position else { return }
            
            if let player = self.playerSprite {
                let moveAction = SKAction.move(to: CGPoint(x: nextTrack.x, y: player.position.y), duration: 0.2)
                
                let goingUpwards = enemiesGoingUpArray[currentTrack + 1]
                
                player.run(moveAction, completion: {
                    self.movingToTrack = false
                    
                    if self.currentTrack != 8 {
                        self.playerSprite?.physicsBody?.velocity = goingUpwards ? CGVector(dx: 0, dy: self.velocityArray[self.currentTrack]) : CGVector(dx: 0, dy: -self.velocityArray[self.currentTrack])
                    } else {
                        self.playerSprite?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
                    }
                })
                currentTrack += 1
                
                self.run(moveSound)
            }
        }
    }
    
    func movePlayerToStart() {
        if let player = self.playerSprite {
            player.removeFromParent()
            self.playerSprite = nil
            self.createPlayer()
            self.currentTrack = 0
        }
    }
    
    func nextLevel(playerPhysicsBody: SKPhysicsBody) {
        currentScore += 1
        self.run(SKAction.playSoundFileNamed("Sounds/levelUp.wav", waitForCompletion: true))
        
        let emitter = SKEmitterNode(fileNamed: "fireworks.sks")
        playerPhysicsBody.node?.addChild(emitter!)
        
        self.run(SKAction.wait(forDuration: 0.5)) {
            emitter?.removeFromParent()
            self.movePlayerToStart()
        }
    }
    
    func gameOver() {
        self.run(SKAction.playSoundFileNamed("Sounds/levelCompleted.wav", waitForCompletion: true))
        
        let transition = SKTransition.fade(withDuration: 1)
        if let gameOverScene = SKScene(fileNamed: "GameOverScene") {
            gameOverScene.scaleMode = .aspectFit
            self.view?.presentScene(gameOverScene, transition: transition)
        }
    }
}
