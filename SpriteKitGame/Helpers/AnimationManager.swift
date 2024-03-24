//
//  Animation.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 09.03.2024.
//

import SpriteKit

class AnimationManager {
    
    func scaleZdirection(sprite: SKSpriteNode) {
        sprite.run(.repeatForever(.sequence([.scale(by: 2.0, duration: 0.5), .scale(to: 1.0, duration: 1.0)])))
    }
    
    func redColorAnimation(sprite: SKSpriteNode, duration: TimeInterval) {
        sprite.run(.repeatForever(.sequence([.colorize(with: .red, colorBlendFactor: 1.0, duration: duration), .colorize(withColorBlendFactor: 0.0, duration: duration)])))
    }
    
    func rotate(sprite: SKSpriteNode) {
        sprite.run(.repeatForever(.rotate(byAngle: CGFloat.pi * 2, duration: 1)))
    }
    
    func shakeAndFlash(view: SKView) {
        // white flash
        let aView = UIView(frame: view.frame)
        aView.backgroundColor = .white
        view.addSubview(aView)
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseInOut) {
            aView.alpha = 0.0
        } completion: { _ in
            aView.removeFromSuperview()
        }

        // shake animation
        let shake = CAKeyframeAnimation(keyPath: "transform")
        shake.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-15, 5, 5)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(15, 5, 5)),
        ]
        
        shake.autoreverses = true
        shake.repeatCount = 2
        shake.duration = 7 / 100
        
        view.layer.add(shake, forKey: nil)
    }
    
}
 
