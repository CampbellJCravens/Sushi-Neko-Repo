//
//  SushiPiece.swift
//  Sushi Neko
//
//  Created by Campbell CRAVENS on 6/27/17.
//  Copyright © 2017 Campbell CRAVENS. All rights reserved.
//

import SpriteKit

class SushiPiece: SKSpriteNode {
    
    var side: Side = .none {
        didSet {
            switch  side {
            case .left:
                leftChopstick.isHidden = false
            case .right:
                rightChopstick.isHidden = false
            case .none:
                leftChopstick.isHidden = true
                rightChopstick.isHidden = true
            }
        }
    }
    
    /* Chopsticks objects */
    var rightChopstick: SKSpriteNode!
    var leftChopstick: SKSpriteNode!
    
    /* You are required to implement this for your subclass to work */
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    /* You are required to implement this for your subclass to work */
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func connectChopsticks() {
        // set references to chopsticks
        leftChopstick = childNode(withName: "leftChopstick") as! SKSpriteNode
        rightChopstick = childNode(withName: "rightChopstick") as! SKSpriteNode
        
        // set the default side
        side = .none
    }
    
    func flip(_ side: Side) {
        /* Flip the sushi out of the screen */
        
        var actionName: String = ""
        
        if side == .left {
            actionName = "FlipRight"
        } else if side == .right {
            actionName = "FlipLeft"
        }
        
        /* Load appropriate action */
        let flip = SKAction(named: actionName)!
        
        /* Create a node removal action */
        let remove = SKAction.removeFromParent()
        
        /* Build sequence, flip then remove from scene */
        let sequence = SKAction.sequence([flip,remove])
        run(sequence)
    }
    
}
