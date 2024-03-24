//
//  CollisionType.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 20.03.2024.
//

import Foundation

enum CollisionType: UInt32 {
    case heroGroup = 1
    case groundGroup = 2
    case coinGroup = 4
    case redCoinGroup = 8
    case obstacleGroup = 16
    case shieldGroup = 32
}
