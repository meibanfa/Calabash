//
//  Enemy.swift
//  Calabash
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 NJU. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: Figure {
    
    var nxt : Enemy?
    var pre : Enemy?
    fileprivate var missileLaunchTimer: Timer?
    
    // MARK: - Initialization
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nxt = nil
        self.pre = nil
    }
    
    required init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        self.nxt = nil
        self.pre = nil
    }
    
    init(lifePoints: Int) {
        let size = CGSize(width: 100, height: 100)
        super.init(texture: SKTexture(imageNamed: ImageName.Enemy.rawValue), color: UIColor.brown, size: size)
        
        self.lifePoints = lifePoints
        self.configureCollisions()
        self.nxt = nil
        self.pre = nil
    }
    
    deinit {
        self.missileLaunchTimer?.invalidate()
    }
    
    // MARK: - Configuration
    
    fileprivate func configureCollisions() {
        self.physicsBody = SKPhysicsBody(rectangleOf: size)
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.categoryBitMask = CategoryBitmask.enemy.rawValue
        self.physicsBody!.collisionBitMask =
            CategoryBitmask.enemy.rawValue |
            CategoryBitmask.playerMissile.rawValue |
            CategoryBitmask.calabash.rawValue
        
        self.physicsBody!.contactTestBitMask =
            CategoryBitmask.calabash.rawValue |
            CategoryBitmask.playerMissile.rawValue
    }
    
    // MARK: - Special actions
    
    // launch missile
    
}
