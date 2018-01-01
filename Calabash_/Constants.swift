//
//  Constants.swift
//  Calabash
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 NJU. All rights reserved.
//

import Foundation


enum ImageName: String{
    case GameBackground = "background"
    case JoystickBase = "joystick_base"
    case JoystickStick = "joystick_stick"
    case Calabash = "calabash"
    case Calabash2 = "calabash2"
    case Enemy = "enemy"
    case Missile = "calabash_missile"
    case FireButtonNormal = "fire_button_normal"
    case FireButtonSelected = "fire_button_selected"
    case LifeBall = "life_ball"
    case ShowMenuButtonNormal = "show_menu_button_normal"
    case ShowMenuButtonSelected = "show_menu_button_selected"
    case MenuBackgroundPhone = "menu_button"
    case MenuButtonRestartNormal = "restart"
    case MenuButtonResumeNormal = "resume"
    //case MenuButtonRestartNormal = "menu_button_restart_normal"
    //case MenuButtonRestartSelected = "menu_button_restart_selected"
    //case MenuButtonResumeNormal = "menu_button_resume_normal"
    //case MenuButtonResumeSelected = "menu_button_resume_selected"
}
enum FontName: String {
    case Wawati = "Heiti SC"
}

enum CategoryBitmask: UInt32 {
    case calabash =  0
    case enemy =   0b10
    case playerMissile =    0b100
    case enemyMissile =     0b1000
    case screenBounds =     0b10000
}


enum CollisionType {
    case calabashenemy
    case playermissileenemy
    case enemymissilecalabash
}

enum ScoreValue: Int {
    case playerMissileHitEnemy =  10
    case calabashHitEnemy =   0b10
}

enum LifePointsValue: Int {
    case enemyMissileHitCalabash =  -10
    case enemyHitCalabash =  -20
    case playerMissileHitEnemy =  -25
}

