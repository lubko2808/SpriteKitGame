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
        
        guard gameover == 0 else { return }
        
        if tapToPlayTextLabel.isHidden == false { tapToPlayTextLabel.isHidden = true }
        
        hero.physicsBody?.velocity = CGVector.zero
        hero.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 180))
        
        heroFlyTextures = SKTexture.heroFlyTextures
        let heroFlyAnimation = SKAction.animate(with: heroFlyTextures, timePerFrame: 0.1)
        let flyHero = SKAction.repeatForever(heroFlyAnimation)
        hero.run(flyHero)
    }
}
