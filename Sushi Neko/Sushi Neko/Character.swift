//
//  Character.swift
//  Sushi Neko
//
//  Created by Campbell CRAVENS on 6/27/17.
//  Copyright © 2017 Campbell CRAVENS. All rights reserved.
//

import SpriteKit


class Character: SKSpriteNode {
    
    
    // Character Side
    var side: Side = .left {
        didSet {
            if side == .left {
                xScale = 1
                position.x = 70
            } else {
                xScale = -1
                position.x = 252
            }
            // load/run the punch action
            let punch = SKAction(named: "Punch")!
            run(punch)
        }
    }
    
    /* You are required to implement this for your subclass to work */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
