//
//  Model.swift
//  SpriteKitTest
//
//  Created by Константин on 17.08.16.
//  Copyright © 2016 Константин. All rights reserved.
//

import Foundation

enum DifficultyChoosing: Int {
    case easy, medium, hard
}

enum BgChoosing: Int {
    case bg1, bg2
}

class Model {
    
    static let sharedInstance = Model() //Singleton
    
    //Variables
    var sound = true
    var score = 0
    var highscore = 0
    var totalscore = 0
    
    var level2UnlockValue = 2
}
