//
//  Utils.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 09.03.2024.
//

import CoreGraphics

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    CGPoint(x: left.x - right.x, y: left.y - right.y)
}


