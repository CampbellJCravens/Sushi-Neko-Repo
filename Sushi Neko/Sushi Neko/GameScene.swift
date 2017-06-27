//
//  GameScene.swift
//  Sushi Neko
//
//  Created by Campbell CRAVENS on 6/27/17.
//  Copyright © 2017 Campbell CRAVENS. All rights reserved.
//

import SpriteKit


enum Side {
    case left, right, none
}

enum GameState {
    case title, ready, playing, gameOver
}


class GameScene: SKScene {
 
    var state: GameState = .title
    var sushiBasePiece: SushiPiece!
    var character: Character!
    var sushiTower: [SushiPiece] = []
    var playButton: MSButtonNode!
    var healthBar: SKSpriteNode!
    var health: CGFloat = 1.0 {
        didSet {
            if health > 1.0 {
                health = 1.0
            }
            // scale bar between 0.0 and 1.0
            healthBar.xScale = health
        }
    }
    var scoreLabel: SKLabelNode!
    var score: Int = 0 {
        didSet {
            scoreLabel.text = String(score)
        }
    }
    

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // set reference to nodes
        sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        character = childNode(withName: "character") as! Character
        playButton = childNode(withName: "playButton") as! MSButtonNode
        healthBar = childNode(withName: "healthBar") as! SKSpriteNode
        scoreLabel = childNode(withName: "scoreLabel") as! SKLabelNode
        
        // run connect chopsticks method
        sushiBasePiece.connectChopsticks()
        
        /* Manually stack the start of the tower */
        addTowerPiece(side: .none)
        addTowerPiece(side: .right)
        
        // add 10 pieces to the tower
        addRandomPieces(total: 10)
        
        playButton.selectedHandler = {
            // start game
            self.state = .ready
        }
        
        
    }
    
    func addTowerPiece(side: Side) {
        // add a new piece to sushi tower
        
        // copy sushi base piece
        let newPiece = sushiBasePiece.copy() as! SushiPiece
        newPiece.connectChopsticks()
        
        // access last piece properties
        let lastPiece = sushiTower.last
        
        // add on top of last piece, default on first piece
        let lastPosition = lastPiece?.position ?? sushiBasePiece.position
        newPiece.position.x = lastPosition.x
        newPiece.position.y = lastPosition.y + 55
        
        // increment the z position, default on first piece
        let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
        newPiece.zPosition = lastZPosition + 1
        
        // set side
        newPiece.side = side
        
        // add sushi to scene
        addChild(newPiece)
        
        // add sushi piece to tower
        sushiTower.append(newPiece)

    }
    
    func addRandomPieces(total: Int) {
        // add random sushi pieces to the tower
        
        for _ in 1...total {
            // need to access last piece properties
            let lastPiece = sushiTower.last!
            
            // need to ensure we dont create impossible sushi pairings
            if lastPiece.side != .none {
                addTowerPiece(side: .none)
            } else {
                // RNG
                let rand = arc4random_uniform(100)
            
                if rand < 45 {
                    // 45% chance of left
                    addTowerPiece(side: .left)
                } else if rand < 90 {
                    // 45% chance of right
                    addTowerPiece(side: .right)
                } else {
                    // 10% chance of none
                    addTowerPiece(side: .none)
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // check if game is playing
        if state != .playing {
            return
        }
        moveTowerDown()
        // Decrease health
        health -= 0.01
        
        // has the player run out of health?
        if health < 0 {
            gameOver()
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // game not ready to play
        if state == .gameOver || state == .title {
            return
        }
        // game begins on first touch 
        if state == .ready {
            state = .playing
        }
        // we only need a single touch
        let touch = touches.first!
        
        // get the touch position in the scene
        let location = touch.location(in: self)
        
        // was touch on left or right hand side of screen?
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
        // grab sushi above the base piece, it will always be "first"
        if let firstPiece = sushiTower.first {
            /* Check character side against sushi piece side (this is our death collision check)*/
            if character.side == firstPiece.side {
                
                gameOver()
                
                /* No need to continue as player is dead */
                return
            }
            
            // remove sushi from tower
            sushiTower.removeFirst()
            // animate the sushi piece
            firstPiece.flip(character.side)
            
            // add a new sushi piece to the top
            addRandomPieces(total: 1)
        }
        health += 0.1
        score += 1
    
    }
    
    func moveTowerDown() {
        var n: CGFloat = 0
        for piece in sushiTower {
            let y = (n * 55) + 215
            piece.position.y -= (piece.position.y - y) * 0.5
            n += 1
        }
    }
    
    func gameOver() {
        // GAME OVER
        state = .gameOver
        
        // turn all the sushi pieces red
        for sushiPiece in sushiTower {
            sushiPiece.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        }
        // Make the base turn red //
        sushiBasePiece.run(SKAction.colorize(with: UIColor.red, colorBlendFactor: 1.0, duration: 0.50))
        
        // change play button handler
        playButton.selectedHandler = {
            // Grab reference to the SpriteKit view //
            let skView = self.view as SKView!
            
            // Load Game scene //
            guard let scene = GameScene(fileNamed:"GameScene") as GameScene! else {
                return
            }
            
            // Ensure correct aspect mode //
            scene.scaleMode = .aspectFill
            
            // Restart GameScene //
            skView?.presentScene(scene)
        }
    }
    
}
