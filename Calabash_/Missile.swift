//
//  Missile.swift
//  Calabash
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 NJU. All rights reserved.
//

import SpriteKit

class Missile: SKSpriteNode {
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    required override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
    }
    
    convenience init() {
        let size = CGSize(width: 10.0, height: 10.0)
        
        self.init(texture: SKTexture(imageNamed:ImageName.Missile.rawValue),
                  color: UIColor.brown,
                  size: size)
        
        self.name = NSStringFromClass(Missile.self)
        
        // Configure physics body
        self.physicsBody = SKPhysicsBody(circleOfRadius: size.width/2)
        self.physicsBody!.usesPreciseCollisionDetection = true
    }
    
    // MARK: - Factory methods
    
    class func enemyMissile() -> Missile {
        let missile = Missile()
        missile.physicsBody!.categoryBitMask = CategoryBitmask.enemyMissile.rawValue
        missile.physicsBody!.contactTestBitMask = CategoryBitmask.calabash.rawValue
        return missile
    }
    
    class func playerMissile() -> Missile {
        let missile = Missile()
        missile.physicsBody!.categoryBitMask = CategoryBitmask.playerMissile.rawValue
        missile.physicsBody!.contactTestBitMask = CategoryBitmask.enemy.rawValue
        return missile
    }
    
}
