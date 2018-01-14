//
//  GameHandler.swift
//  ColorGame
//
//  Created by ClementM on 14/01/2018.
//  Copyright © 2018 ClementM. All rights reserved.
//

import Foundation

class GameHandler {
    var score: Int
    var highScore: Int
    
    class var sharedInstance: GameHandler {
        struct Singleton {
            static let instance = GameHandler()
        }
        return Singleton.instance
    }
    
    init() {
        score = 0
        
        let userDefaults = UserDefaults.standard
        highScore = userDefaults.integer(forKey: "highScore")
    }
    
    func saveGameStats() {
        highScore = max(score, highScore)
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(highScore, forKey: "highscore")
        userDefaults.synchronize()
    }
}
