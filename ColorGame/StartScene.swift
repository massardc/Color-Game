//
//  StartScene.swift
//  ColorGame
//
//  Created by ClementM on 14/01/2018.
//  Copyright © 2017 ClementM. All rights reserved.
//

import SpriteKit

class StartScene: SKScene {
    
    var playButton:SKSpriteNode?
    var gameScene:SKScene!
    var backgroundMusic: SKAudioNode!
    
    override func didMove(to view: SKView) {
        playButton = self.childNode(withName: "startButton") as? SKSpriteNode
        
        
        if let musicURL = Bundle.main.url(forResource: "Sounds/MenuHighscoreMusic", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playButton {
                let transition = SKTransition.fade(withDuration: 1)
                gameScene = SKScene(fileNamed: "GameScene")
                gameScene.scaleMode = .aspectFit
                self.view?.presentScene(gameScene, transition: transition)
            }
        }
    }
}