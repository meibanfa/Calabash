//
//  ScoresNode.swift
//  Calabash
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 NJU. All rights reserved.
//

import SpriteKit

class ScoresNode: SKLabelNode {
    
    var value: Int = 0 {
        didSet {
            self.update()
        }
    }
    
    // MARK: - Initialization
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        
        self.fontSize = 30.0
        self.fontColor = UIColor(white: 0, alpha: 0.7)
        self.fontName = FontName.Wawati.rawValue
        self.horizontalAlignmentMode = .left;
        
        self.update()
    }
    
    // MARK: - Configuration
    
    func update() {
        self.text = "Score: \(value)"
    }
    
}
