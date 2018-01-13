//
//  GameScene.swift
//  ColorGame
//
//  Created by ClementM on 13/01/2018.
//  Copyright © 2018 ClementM. All rights reserved.
//

import SpriteKit
import GameplayKit

enum Enemy: Int {
    case small
    case medium
    case large
}

class GameScene: SKScene {
    
    // MARK: - Variables
    var tracksArray: [SKSpriteNode]? = [SKSpriteNode]()
    var playerSprite: SKSpriteNode?
    var currentTrack = 0
    var movingToTrack = false
    var moveSound = SKAction.playSoundFileNamed("Sounds/move.wav", waitForCompletion: false)
    let trackVelocities = [180, 200, 250]
    var velocityArray = [Int]()
    var enemiesGoingUpArray = [Bool]()
    
    // MARK: - Class functions
    override func didMove(to view: SKView) {
        setupTracks()
        createPlayer()
        
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
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    // MARK: - Custom functions
    func setupTracks() {
        for i in 0...8 {
            if let track = self.childNode(withName: "\(i)") as? SKSpriteNode {
                tracksArray?.append(track)
            }
        }
    }
    
    func createPlayer() {
        playerSprite = SKSpriteNode(imageNamed: "player")
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
        enemySprite.physicsBody?.velocity = up ? CGVector(dx: 0, dy: velocityArray[track]) : CGVector(dx: 0, dy: -velocityArray[track])
        
        return enemySprite
    }
    
    func spawnEnemies() {
        for i in 1...7 {
            let randomEnemyType = Enemy(rawValue: GKRandomSource.sharedRandom().nextInt(upperBound: 3))!
            if let newEnemy = createEnemy(type: randomEnemyType, forTrack: i) {
                self.addChild(newEnemy)
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
        
        guard let nextTrack = tracksArray?[currentTrack + 1].position else { return }
        
        if let player = self.playerSprite {
            let moveAction = SKAction.move(to: CGPoint(x: nextTrack.x, y: player.position.y), duration: 0.2)
            player.run(moveAction, completion: {
                self.movingToTrack = false
            })
            currentTrack += 1
            
            self.run(moveSound)
        }
    }
}
