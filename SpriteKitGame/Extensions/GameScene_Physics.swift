//
//  GameScene_Physics.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 09.03.2024.
//

import SpriteKit

extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return}
        guard let nodeB = contact.bodyB.node else { return }
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        let obstacleNode = bodyA.categoryBitMask == CollisionType.obstacleGroup.rawValue ? nodeA : nodeB
        
        if score > highscore {
            highscore = score
            UserDefaults.standard.setValue(highscore, forKey: "UserHighscore")
        }
        
        if bodyA.categoryBitMask == CollisionType.groundGroup.rawValue || bodyB.categoryBitMask == CollisionType.groundGroup.rawValue {
            handleCollisionWithGround()
        }
        
        if bodyA.categoryBitMask == CollisionType.obstacleGroup.rawValue || bodyB.categoryBitMask == CollisionType.obstacleGroup.rawValue  {
            hero.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            
            if isShieldActive == false {
                handleFatalCollision()
            } else {
                obstacleNode.removeFromParent()
                hero.children.forEach { if $0.name == NodeType.shield.rawValue { $0.removeFromParent() } }
                isShieldActive = false
                run(SKAction.shieldOffSound)
            }
        }
         
        if  bodyA.categoryBitMask == CollisionType.shieldGroup.rawValue || bodyB.categoryBitMask == CollisionType.shieldGroup.rawValue {
            let shieldNode = bodyA.categoryBitMask == CollisionType.shieldGroup.rawValue ? nodeA : nodeB
            handleCollisionWithShield(shieldNode)

        }
        
        if bodyA.categoryBitMask == CollisionType.coinGroup.rawValue || bodyB.categoryBitMask == CollisionType.coinGroup.rawValue {
            let coinNode = bodyA.categoryBitMask == CollisionType.coinGroup.rawValue ? nodeA : nodeB
            handleCollisionWithCoin(coinNode)
        }
        
        if bodyA.categoryBitMask == CollisionType.redCoinGroup.rawValue || bodyB.categoryBitMask == CollisionType.redCoinGroup.rawValue {
            let redCoinNode = bodyA.categoryBitMask == CollisionType.redCoinGroup.rawValue ? nodeA : nodeB
            handleCollisionWithRedCoin(redCoinNode)
        }
        
    }
    
    private func removeNodes() {
        let nodes = self.children
        nodes.forEach { node in
            guard let nodeName = node.name, let _ = NodeType(rawValue: nodeName) else { return }
            node.removeFromParent()
        }
        self.hero.removeAllChildren()
    }
    
    private func handleFatalCollision() {
        operationQueue.cancelAllOperations()
        animationManager.shakeAndFlash(view: self.view!)
        run(SKAction.deathFromElectricGateSound)
        hero.physicsBody?.allowsRotation = false
        
        removeNodes()

        isHeroDead = true
        
        let heroDeathAnimation = SKAction.animate(with: SKTexture.heroDeadTextures, timePerFrame: 0.2)
        let completion = SKAction.run {
            DispatchQueue.main.async {
                self.hero.removeFromParent()
                self.showReloadGameButtonSubject.send(false)
                
                if self.score > self.highscore {
                    self.highscore = self.score
                }
                self.highscoreLabel.isHidden = false
                self.highscoreTextLabel.isHidden = false
                self.highscoreLabel.text = "\(self.highscore)"
            }
        }
        background.speed = 0
        hero.run(.sequence([heroDeathAnimation, completion]))
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        
        
    }
    
    private func handleCollisionWithGround() {
        guard !isHeroDead else { return }
        heroEmmiter.isHidden = true
        let heroAnimation = SKAction.animate(with: SKTexture.heroRunTextures, timePerFrame: 0.1)
        hero.run(.repeatForever(heroAnimation))
    }
    
    private func handleCollisionWithCoin(_ coinNode: SKNode) {
        run(SKAction.pickCoinSound)
        score += 1
        scoreLabel.text = "\(score)"
        coinNode.removeFromParent()
    }
    
    private func handleCollisionWithRedCoin(_ redCoinNode: SKNode) {
        run(SKAction.pickCoinSound)
        score += 2
        scoreLabel.text = "\(score)"
        redCoinNode.removeFromParent()
    }
    
    private func handleCollisionWithShield(_ shieldNode: SKNode) {
        if isShieldActive == false {
            run(SKAction.pickCoinSound)
            shieldNode.removeFromParent()
            addShield()
            isShieldActive = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
                self.isShieldActive = false
                self.heroShield.removeFromParent()
            }
        }
    }
    
}
