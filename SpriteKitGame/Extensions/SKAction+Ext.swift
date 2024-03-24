//
//  SKAction+Ext.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 23.03.2024.
//

import SpriteKit

extension SKAction {
    
    static func moveNodeBehindTheScene(sceneWidth: CGFloat, speed: CGFloat) -> SKAction {
        let duration = (sceneWidth * 2) / speed
        let moveAction = SKAction.moveBy(x: -(sceneWidth * 2), y: 0, duration: duration)
        let removeAction = SKAction.removeFromParent()
        let finalAction = SKAction.sequence([moveAction, removeAction])
        return finalAction
    }
    
}

// Sound
extension SKAction {
    
    static let pickCoinSound: SKAction = {
        SKAction.playSoundFileNamed("pickCoin.mp3", waitForCompletion: false)
    }()
    
    static let electricGateCreationSound: SKAction = {
        SKAction.playSoundFileNamed("electricCreate.wav", waitForCompletion: false)
    }()
    
    static let deathFromElectricGateSound: SKAction = {
        SKAction.playSoundFileNamed("electricDead.mp3", waitForCompletion: false)
    }()
    
    static let shieldOnSound: SKAction = {
        SKAction.playSoundFileNamed("shieldOn.mp3", waitForCompletion: false)
    }()
    
    static let shieldOffSound: SKAction = {
        SKAction.playSoundFileNamed("shieldOff.mp3", waitForCompletion: false)
    }()
    
}
