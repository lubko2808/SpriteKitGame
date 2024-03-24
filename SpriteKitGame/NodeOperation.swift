//
//  NodeOperation.swift
//  Intro
//
//  Created by Lubomyr Chorniak on 24.03.2024.
//

import Foundation

class NodeOperation: Operation {
    
    let nodeGenerator: () -> ()
    let intervalRange: ClosedRange<Int>
    
    init(nodeGenerator: @escaping () -> Void, intervalRange: ClosedRange<Int>) {
        self.nodeGenerator = nodeGenerator
        self.intervalRange = intervalRange
        super.init()
    }
    
    var workItem: DispatchWorkItem?
    
    override func main() {
        while(true) {
            if isCancelled {
                return
            }
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            workItem = DispatchWorkItem {
                if self.isCancelled {
                    return
                }
                self.nodeGenerator()
                dispatchGroup.leave()
            }
            
            let randomInterval = DispatchTimeInterval.seconds(Int.random(in: intervalRange))
            DispatchQueue.main.asyncAfter(deadline: .now() + randomInterval, execute: workItem!)
            dispatchGroup.wait()
        }
    }
    
}
