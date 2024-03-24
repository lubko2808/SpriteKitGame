//
//  RandomizerManager.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 20.03.2024.
//

import SpriteKit

class RandomizerManager {
    
    static let shared = RandomizerManager()
    
    private init() {}
    
    public func generateNodePisition(on background: CGSize, nodeSize: CGSize) -> CGPoint {
        let backgroundHeight = background.height
        let groundHeight = backgroundHeight * Constants.groundPortionOfBg
        let playableAreaHeight = backgroundHeight * (1 - Constants.groundPortionOfBg)
        let yPosition = groundHeight + CGFloat.random(in: (nodeSize.height / 2)...(playableAreaHeight - nodeSize.height / 2))
        return CGPoint(x: background.width + nodeSize.width / 2, y: yPosition)
    }
    
    public func generateNodePositionAndMovement(on background: CGSize, node: SKSpriteNode) {
        let playableAreaHeight = background.height * (1 - Constants.groundPortionOfBg)
        let position = generateNodePisition(on: background, nodeSize: node.size)
        let speed: CGFloat = 150
        let distanceToSky = background.height - position.y
        let durationToSky = distanceToSky / speed
        let moveToSky = SKAction.moveBy(x: 0, y: distanceToSky, duration: durationToSky)
        let duration = playableAreaHeight / speed
        var isMovingToGround = true
        let moveAction = SKAction.run {
            if isMovingToGround {
                node.run(.sequence([.moveBy(x: 0, y: -playableAreaHeight, duration: duration), .wait(forDuration: duration)]))
            } else {
                node.run(.sequence([.moveBy(x: 0, y: playableAreaHeight, duration: duration), .wait(forDuration: duration)]))
            }
            isMovingToGround.toggle()
        }
        node.position = position
        node.run(.sequence([moveToSky, .repeatForever(.sequence([moveAction, .wait(forDuration: duration)]))]))
    }
    
    public func generateScale() -> CGFloat {
        let scale = CGFloat.random(in: 0.7...1)
        return scale
    }
    
}
