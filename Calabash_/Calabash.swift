//
//  Calabash.swift
//  Calabash
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 NJU. All rights reserved.
//

import Foundation
import CoreGraphics
import SpriteKit

class Calabash: Figure {
    
    // MARK: - Initialization
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init() {
        let size = CGSize(width: 64, height: 100)
        
        self.init(texture: SKTexture(imageNamed: ImageName.Calabash.rawValue),
                  color: UIColor.brown,
                  size: size)
        
        self.name = NSStringFromClass(Calabash.self)
        
        self.configureCollisions()
    }
    
    // MARK: - Configuration
    
    fileprivate func configureCollisions() {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.allowsRotation = false
        
        self.physicsBody!.categoryBitMask = CategoryBitmask.calabash.rawValue
        self.physicsBody!.collisionBitMask =
            CategoryBitmask.enemyMissile.rawValue |
            CategoryBitmask.screenBounds.rawValue
        
        self.physicsBody!.contactTestBitMask =
            CategoryBitmask.enemy.rawValue |
            CategoryBitmask.enemyMissile.rawValue
    }
    
    // MARK: - Special actions
    func launchMissile() {
        // Create a missile
        let missile = Missile.playerMissile()
        missile.position = CGPoint(x: self.frame.maxX + 10.0, y: position.y)
        missile.zPosition = self.zPosition - 1
        
        // Place it in the scene
        self.scene!.addChild(missile)
        
        // Make it move
        let velocity: CGFloat = 1000.0
        let moveDuration = scene!.size.width / velocity
        let missileEndPosition = CGPoint(x: position.x + scene!.size.width, y: position.y)
        
        let moveAction = SKAction.move(to: missileEndPosition, duration: TimeInterval(moveDuration))
        let removeAction = SKAction.removeFromParent()
        missile.run(SKAction.sequence([moveAction, removeAction]))
        
    }
}
