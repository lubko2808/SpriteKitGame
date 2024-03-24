//
//  SKTexture+Ext.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 09.03.2024.
//

import SpriteKit

extension SKTexture {
    
   static var heroFlyTextures: [SKTexture] {
        [SKTexture(imageNamed: "Fly0"), SKTexture(imageNamed: "Fly1"), SKTexture(imageNamed: "Fly2"), SKTexture(imageNamed: "Fly3"), SKTexture(imageNamed: "Fly4")]
    }
    
    static var heroRunTextures: [SKTexture] {
        [SKTexture(imageNamed: "Run0"), SKTexture(imageNamed: "Run1"), SKTexture(imageNamed: "Run2"), SKTexture(imageNamed: "Run3"), SKTexture(imageNamed: "Run4"), SKTexture(imageNamed: "Run5"), SKTexture(imageNamed: "Run6")]
    }
    
    static var coinTextures: [SKTexture] {
        [SKTexture(imageNamed: "Coin0"), SKTexture(imageNamed: "Coin1"), SKTexture(imageNamed: "Coin2"), SKTexture(imageNamed: "Coin3")]
    }
    
    static var electricGateTextures: [SKTexture] {
        [SKTexture(imageNamed: "ElectricGate01"), SKTexture(imageNamed: "ElectricGate02"), SKTexture(imageNamed: "ElectricGate03"), SKTexture(imageNamed: "ElectricGate04")]
    }
    
    static var heroDeadTextures: [SKTexture] {
        [SKTexture(imageNamed: "Dead0"), SKTexture(imageNamed: "Dead1"), SKTexture(imageNamed: "Dead2"), SKTexture(imageNamed: "Dead3")]
    }
    
}
