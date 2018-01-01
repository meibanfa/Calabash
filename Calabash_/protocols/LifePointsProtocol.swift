//
//  LifePointsProtocol.swift
//  Calabash
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 NJU. All rights reserved.
//

import Foundation
typealias DidRunOutOfLifePointsEventHandler = (_ object: AnyObject) -> ()

protocol LifePointsProtocol {
    var lifePoints: Int { get set }
    var didRunOutOfLifePointsEventHandler: DidRunOutOfLifePointsEventHandler? { get set }
}
