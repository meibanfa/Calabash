//
//  MainMenuScene.swift
//  Calabash
//
//  Created by apple on 2017/12/9.
//  Copyright © 2017年 NJU. All rights reserved.
//

import SpriteKit

protocol MainMenuSceneDelegate: class {
    
    func mainMenuSceneDidTapResumeButton(_ mainMenuScene: MainMenuScene)
    func mainMenuSceneDidTapRestartButton(_ mainMenuScene: MainMenuScene)
}

class MainMenuScene: SKScene {
    
    private var infoButton: Button?
    private var resumeButton: Button?
    private var restartButton: Button?
    private var buttons: [Button]?
    private var background: SKSpriteNode?
    weak var mainMenuSceneDelegate: MainMenuSceneDelegate?
    
    // MARK: - Scene lifecycle
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
        
        self.configureButtons()
        self.configureBackground()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
        // Track event
        // AnalyticsManager.sharedInstance.trackScene("MainMenuScene")
    }
    
}

// MARK: - Configuration

extension MainMenuScene{
    
    private func configureBackground() {
        self.background = SKSpriteNode(imageNamed: ImageName.MenuBackgroundPhone.rawValue)
        self.background!.size = self.size
        self.background!.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        self.background!.zPosition = -1000
        self.addChild(self.background!)
    }
    
    private func configureButtons() {
        
        // Resume button.
        self.resumeButton = Button(
            normalImageNamed: ImageName.MenuButtonResumeNormal.rawValue,
            selectedImageNamed: ImageName.MenuButtonResumeNormal.rawValue)
        
        self.resumeButton!.touchUpInsideEventHandler = self.resumeButtonTouchUpInsideHandler()
        
        // Restart button.
        self.restartButton = Button(
            normalImageNamed: ImageName.MenuButtonRestartNormal.rawValue,
            selectedImageNamed: ImageName.MenuButtonRestartNormal.rawValue)
        
        self.restartButton!.touchUpInsideEventHandler = self.restartButtonTouchUpInsideHandler()
        
        self.buttons = [self.resumeButton!, self.restartButton!]
        let horizontalPadding: CGFloat = 20.0
        var totalButtonsWidth: CGFloat = 0.0
        
        // Calculate total width of the buttons area.
        for (index, button) in (buttons!).enumerated() {
            totalButtonsWidth += button.size.width
            totalButtonsWidth += index != buttons!.count - 1 ? horizontalPadding : 0.0
        }
        
        // Calculate origin of first button.
        var buttonOriginX = self.frame.width / 2.0 + totalButtonsWidth / 2.0
        
        // Place buttons in the scene.
        for (_, button) in (self.buttons!).enumerated() {
            button.position = CGPoint(
                x: buttonOriginX - button.size.width/2,
                y: button.size.height * 1.1)
            
            self.addChild(button)
            
            buttonOriginX -= button.size.width + horizontalPadding
            
            //let rotateAction = SKAction.rotate(byAngle: CGFloat(.pi/180.0 * 5.0), duration: 2.0)
            //let sequence = SKAction.sequence([rotateAction, rotateAction.reversed()])
            
            //button.run(SKAction.repeatForever(sequence))
        }
    }
    
    private func resumeButtonTouchUpInsideHandler() -> TouchUpInsideEventHandler {
        return { () -> () in
            self.mainMenuSceneDelegate?.mainMenuSceneDidTapResumeButton(self)
            return
        }
    }
    
    private func restartButtonTouchUpInsideHandler() -> TouchUpInsideEventHandler {
        return { () -> () in
            self.mainMenuSceneDelegate?.mainMenuSceneDidTapRestartButton(self)
            return
        }
    }
    
    
}

