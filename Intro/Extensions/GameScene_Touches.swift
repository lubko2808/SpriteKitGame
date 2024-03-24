//
//  GameScene_Touches.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 09.03.2024.
//

import SpriteKit



extension GameScene {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        heroEmmiter.isHidden = false
        
        guard !isHeroDead else { return }
                
        if tapToPlayTextLabel.isHidden == false { tapToPlayTextLabel.isHidden = true }
        hero.physicsBody?.velocity = CGVector.zero
        let impulse = 0.2 * self.height
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: impulse))
        
        let heroAnimation = SKAction.animate(with: SKTexture.heroFlyTextures, timePerFrame: 0.1)
        hero.run(.repeatForever(heroAnimation))
    }
}
