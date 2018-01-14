//
//  GameOverScene.swift
//  ColorGame
//
//  Created by ClementM on 14/01/2018.
//  Copyright © 2017 ClementM. All rights reserved.
//

import SpriteKit

class GameOverScene : SKScene {
    
    var lastScoreLabel:SKLabelNode?
    var bestScoreLabel:SKLabelNode?
    
    var playButton:SKSpriteNode?
    
    var backgroundMusic: SKAudioNode!
    
    override func didMove(to view: SKView) {
        lastScoreLabel = self.childNode(withName: "lastScoreLabel") as? SKLabelNode
        bestScoreLabel = self.childNode(withName: "bestScoreLabel") as? SKLabelNode
    
        
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
                
            }
        }
    }
    
}
