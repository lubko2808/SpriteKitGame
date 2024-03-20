//
//  GameScene_Physics.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 09.03.2024.
//

import SpriteKit

enum CollisionType: UInt32 {
    case heroGroup = 1
    case groundGroup = 2
    case coinGroup = 4
    case redCoinGroup = 8
    case objectGroup = 16
    case shieldGroup = 32
}

extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return}
        guard let nodeB = contact.bodyB.node else { return }
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let objectNode = contact.bodyA.categoryBitMask == objectGroup ? contact.bodyA.node : contact.bodyB.node
        
        if score > highscore {
            highscore = score
        }
        UserDefaults.standard.setValue(highscore, forKey: "UserHighscore")
        
        
        if contact.bodyA.categoryBitMask == objectGroup || contact.bodyB.categoryBitMask == objectGroup  {
            hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            if shieldBool == false {
                
                animationManager.shakeAndFlash(view: self.view!)
                
                if sound == true {
                    run(electricGateDeadPreload)
                }
                
                hero.physicsBody?.allowsRotation = false
                
                heroEmmiterObject.removeAllChildren()
                coinObject.removeAllChildren()
                redCoinObject.removeAllChildren()
                groundObject.removeAllChildren()
                movingObject.removeAllChildren()
                shieldObject.removeAllChildren()
                shieldItemObject.removeAllChildren()
                
                stopGame()
                
                [timerAddCoin, timerAddRedCoin, timerAddElectircGate, timerAddMine].forEach { $0.invalidate() }
                
                let heroDeathAnimation = SKAction.animate(with: SKTexture.heroDeadTextures, timePerFrame: 0.2)
                hero.run(heroDeathAnimation)
                
                labelObject.addChild(highscoreLabel)
                gameover = 1
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 7 * 0.2) {
                    self.scene?.isPaused = true
                    self.heroObject.removeAllChildren()
                    self.labelObject.addChild(self.highscoreTextLabel)
                    self.gameViewControllerBridge.reloadGameButton.isHidden = false
                    
                    self.stageLabel.isHidden = true
                    if self.score > self.highscore {
                        self.highscore = self.score
                    }
                    self.highscoreLabel.isHidden = false
                    self.highscoreTextLabel.isHidden = false
                    self.highscoreLabel.text = "\(self.highscore)"
                }
                SKTAudio.sharedInstance().pauseBackgroundMusic() 
            } else {
                objectNode?.removeFromParent()
                shieldObject.removeFromParent()
                shieldBool = false
                if sound == true { run(shieldOffPreload) }
            }
        }
         
        if  contact.bodyA.categoryBitMask == shieldGroup || contact.bodyB.categoryBitMask == shieldGroup {
            let shieldNode = contact.bodyA.categoryBitMask == shieldGroup ? contact.bodyA.node : contact.bodyB.node
        
            if shieldBool == false {
                if sound == true { run(pickCoinPreload) }
                shieldNode?.removeFromParent()
                addShield()
                shieldBool = true
            }
        }
        
        if contact.bodyA.categoryBitMask == groundGroup || contact.bodyB.categoryBitMask == groundGroup {
            guard gameover == 0 else { return }
            heroEmmiter.isHidden = true
            
            heroRunTextures = SKTexture.heroRunTextures
            
            let heroRunAnimation = SKAction.animate(with: heroRunTextures, timePerFrame: 0.1)
            let heroRun = SKAction.repeatForever(heroRunAnimation)
            
            hero.run(heroRun)
        }
        
        if contact.bodyA.categoryBitMask == coinGroup || contact.bodyB.categoryBitMask == coinGroup {
            let coinNode = contact.bodyA.categoryBitMask == coinGroup ? contact.bodyA.node : contact.bodyB.node
            if sound == true {
                run(pickCoinPreload)
            }
            score += 1
            scoreLabel.text = "\(score)"
            coinNode?.removeFromParent()
        }
        
        if contact.bodyA.categoryBitMask == redCoinGroup || contact.bodyB.categoryBitMask == redCoinGroup {
            let redCoinNode = contact.bodyA.categoryBitMask == redCoinGroup ? contact.bodyA.node : contact.bodyB.node
            if sound == true {
                run(pickCoinPreload)
            }
            score += 2
            scoreLabel.text = "\(score)"
            redCoinNode?.removeFromParent()
        }
        
    }
    
    
}
