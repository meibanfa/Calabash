//
//  GameScene.swift
//  Calabash
//
//  Created by apple on 2017/12/8.
//  Copyright © 2017年 NJU. All rights reserved.
//

import SpriteKit
import GameplayKit
protocol GameSceneDelegate: class {
    func didTapMainMenuButton(in gameScene: GameScene)
    func playerDidLose(withScore score: Int, in gameScene:GameScene)
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private struct Constants {
        static let hudControlMargin: CGFloat = 20.0
        static let maxRandomTimeBetweenEnemySpawns: UInt32 = 3
        static let scoresNodeBottomMargin: CGFloat = 40.0
        static let fireButtonBottomMargin: CGFloat = 40.0
        static let joystickMaximumRadius: CGFloat = 40.0
        static let initialEnemyLifePoints = 20
        static let enemyFlightDuration: TimeInterval = 4.0
        static let enemyspeed: CGFloat = 200.0
        static let explosionEmmiterFileName = "Explosion"
    }
    weak var gameSceneDelegate: GameSceneDelegate?
    
    //Nodes
    private var background: SKSpriteNode?
    private var calabash: Calabash?
    private var calabash2: Calabash?
    private var joystick: Joystick?
    private var fireButton: Button?
    private var menuButton: Button?
    private var enemy_head: Enemy?
    
    // life
    private let lifeIndicator = LifeIndicator(texture: SKTexture(imageNamed: ImageName.LifeBall.rawValue))
    
    //score
    private let scoresNode = ScoresNode()
    
    /// Timer used for spawning enemies
    private var spawnEnemyTimer: Timer?
    /// Timer used for update enemies movements
    private var updateEnemyTimer: Timer?
    
    
    override func sceneDidLoad(){
        
        super.sceneDidLoad()
        // set scale mode
        self.scaleMode=SKSceneScaleMode.resizeFill
        
        // configure scene contents
        self.configureBackground()
        // configure physics
        self.configurePhysics()
        // configure Calabash
        self.configureCalabash()
        // configure enemy
        self.enemy_head = nil
        
        // configure the joystick
        self.configureJoystick()
        // configure the firebutton
        self.configureFireButton()
        // configure the score node
        self.configureScoresNode()
        // configure the life indicator
        self.configureLifeIndicator()
        // configure the menu button
        self.configureMenuButton()
        
        // start the game
        self.startSpawningEnemies()
    }
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        // enable multitouch
        view.isMultipleTouchEnabled = true
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}

// configuration

extension GameScene{
    
    private func configurePhysics() {
        // Disable gravity
        self.physicsWorld.gravity = CGVector(dx: 0,dy: 0)
        self.physicsWorld.contactDelegate=self
        
        // Add boundaries
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody!.categoryBitMask = CategoryBitmask.screenBounds.rawValue
        self.physicsBody!.collisionBitMask = CategoryBitmask.calabash.rawValue
    }
    private func configureBackground(){
        // create background node
        let background = SKSpriteNode(imageNamed:ImageName.GameBackground.rawValue)
        background.size = self.size
        background.position = CGPoint(x:self.size.width/2, y:self.size.height/2)
        background.zPosition = -10000
        
        // add back to the scene
        self.addChild(background)
        self.background = background
    }
    private func configureCalabash(){
        self.calabash = Calabash()
        // position
        self.calabash!.position = CGPoint(x: self.calabash!.size.width/2 + 30.0,y: self.frame.height/3)
        // Life points
        self.calabash!.lifePoints = 100
        self.calabash!.didRunOutOfLifePointsEventHandler
            = self.playerDidRunOutOfLifePointsEventHandler()
        // add to the scene
        self.addChild(self.calabash!)
    }
    private func configureJoystick(){
        self.joystick = Joystick(maximumRadius: Constants.joystickMaximumRadius,
                                 stickImageNamed: ImageName.JoystickStick.rawValue,
                                 baseImageNamed: ImageName.JoystickBase.rawValue)
        // Position
        self.joystick!.position = CGPoint(x: self.joystick!.size.width * 2,
                                          y: self.joystick!.size.height * 1.5)
        // Handler that gets called on joystick move
        self.joystick!.updateHandler = { (joystickTranslation: CGPoint) -> () in
            self.updateCalabashPosition(with: joystickTranslation)
        }
        // Add it to the scene
        self.addChild(self.joystick!)
    }
    private func configureFireButton() {
        self.fireButton = Button(normalImageNamed: ImageName.FireButtonNormal.rawValue,
                                 selectedImageNamed: ImageName.FireButtonSelected.rawValue)
        self.fireButton!.position = CGPoint(x: self.frame.width - fireButton!.frame.width ,
                                            y: self.fireButton!.frame.height/2 + Constants.fireButtonBottomMargin)
        // Touch handler
        self.fireButton!.touchUpInsideEventHandler = { () -> () in
            self.calabash!.launchMissile()
            return
        }
        // Add it to the scene
        self.addChild(self.fireButton!)
    }
    private func configureScoresNode() {
        // Position
        self.scoresNode.position = CGPoint(x: Constants.hudControlMargin, y: self.frame.height - Constants.scoresNodeBottomMargin )
        // Add it to the scene
        self.addChild(self.scoresNode)
    }
    private func configureLifeIndicator() {
        // Position
        self.lifeIndicator.position = CGPoint(x: self.joystick!.frame.maxX + 4 * self.joystick!.joystickRadius,
                                              y: self.joystick!.frame.minY - self.joystick!.joystickRadius)
        // Life points
        self.lifeIndicator.setLifePoints(self.calabash!.lifePoints, animated: false)
        // Add it to the scene
        self.addChild(self.lifeIndicator)
    }
    private func configureMenuButton() {
        self.menuButton = Button(normalImageNamed: ImageName.ShowMenuButtonNormal.rawValue,
                                 selectedImageNamed: ImageName.ShowMenuButtonSelected.rawValue)
        self.menuButton!.position = CGPoint(x: self.frame.width - self.menuButton!.frame.width/2 - 2.0,
                                            y: self.frame.height - self.menuButton!.frame.height/2)
        // Touch handler
        self.menuButton!.touchUpInsideEventHandler = { () -> () in
            self.gameSceneDelegate?.didTapMainMenuButton(in: self)
            return
        }
        // Add it to the scene
        self.addChild(self.menuButton!)
    }
    
}

// managing Calabash
extension GameScene{
    
    private func updateCalabashPosition(with joystickTranslation: CGPoint) {
        let translationConstant: CGFloat = 10.0
        self.calabash!.position.x += translationConstant * joystickTranslation.x
        self.calabash!.position.y += translationConstant * joystickTranslation.y
        
    }
}

// managing enemies
extension GameScene{
    private func startSpawningEnemies() {
        self.scheduleEnemySpawn()
    }
    private func stopSpawningEnemies() {
        self.spawnEnemyTimer?.invalidate()
    }
    private func scheduleEnemySpawn() {
        let randomTimeInterval = TimeInterval(arc4random_uniform(Constants.maxRandomTimeBetweenEnemySpawns) + 1)
        self.spawnEnemyTimer = Timer.scheduledTimer(
            timeInterval: randomTimeInterval,
            target: self,
            selector: #selector(GameScene.spawnEnemyTimerFireMethod),
            userInfo: nil,
            repeats: false)
        // schedule the time that enemies update
        let rti = TimeInterval(0.2)
        self.updateEnemyTimer = Timer.scheduledTimer(
            timeInterval: rti,
            target: self,
            selector: #selector(GameScene.move_enemies),
            userInfo: nil,
            repeats: false)
    }
    //private func updateenemy(enemy:Enemy){
    //let moveAction = SKAction.moveBy(x: self.calabash!.position.x - enemy.position.x, y: self.calabash!.position.y - enemy.position.y, duration: Constants.enemyFlightDuration)
    //enemy.run(SKAction.sequence([moveAction]))
    //}
    @objc private func move_enemies(){
        var enemy = self.enemy_head
        while enemy != nil{
            let dis = hypot(self.calabash!.position.x - enemy!.position.x, self.calabash!.position.y - enemy!.position.y)
            let moveAction = SKAction.moveBy(x: self.calabash!.position.x - enemy!.position.x, y: self.calabash!.position.y - enemy!.position.y, duration: TimeInterval(dis/Constants.enemyspeed) )
            enemy!.run(moveAction, withKey: "hello")
            enemy = enemy?.nxt
        }
    }
    @objc private func spawnEnemyTimerFireMethod() {
        // Spawn enemy
        self.spawnEnemy()
        // Schedule spawn of the next one
        self.scheduleEnemySpawn()
    }
    private func spawnEnemy() {
        let enemy = Enemy(lifePoints: Constants.initialEnemyLifePoints)
        enemy.didRunOutOfLifePointsEventHandler = enemyDidRunOutOfLifePointsEventHandler()
        
        // Determine where to spawn the enemy along the Y axis
        let minY = enemy.size.height
        let maxY = self.frame.height - enemy.size.height
        let rangeY = (maxY - minY)/2
        let randomY: UInt32 = arc4random_uniform(UInt32(rangeY)) + UInt32(minY)
        
        // Set position of the enemy to be slightly off-screen along the right edge,
        // and along a random position along the Y axis
        enemy.position = CGPoint(x: frame.size.width + enemy.size.width/2, y: CGFloat(randomY))
        enemy.zPosition = self.calabash!.zPosition
        
        // Add it to the scene
        self.addChild(enemy)
        enemy.nxt = self.enemy_head
        if self.enemy_head != nil {
            self.enemy_head?.pre = enemy
        }
        self.enemy_head = enemy
        
        // Determine dis of the enemy
        let dis = hypot(self.calabash!.position.x - enemy.position.x, self.calabash!.position.y - enemy.position.y)
        let moveAction = SKAction.moveBy(x: self.calabash!.position.x - enemy.position.x, y: self.calabash!.position.y - enemy.position.y, duration: TimeInterval(dis/Constants.enemyspeed) )
        enemy.run(moveAction, withKey: "hello")
    }
}

// collision detection
extension GameScene {
    
    func didBegin(_ contact: SKPhysicsContact) {
        // Get collision type
        let collisionType: CollisionType? = self.collisionType(for: contact)
        guard collisionType != nil else {
            return
        }
        
        switch collisionType! {
        case .playermissileenemy:
            // Get the enemy node
            var enemy: Enemy
            var missile: Missile
            
            if contact.bodyA.node as? Enemy != nil {
                enemy = contact.bodyA.node as! Enemy
                missile = contact.bodyB.node as! Missile
            } else {
                enemy = contact.bodyB.node as! Enemy
                missile = contact.bodyA.node as! Missile
            }
            
            // Handle collision
            self.handleCollision(between: missile, and: enemy)
            
        case .calabashenemy:
            // Get the enemy node
            let enemy: Enemy = contact.bodyA.node as? Enemy != nil ?
                contact.bodyA.node as! Enemy :
                contact.bodyB.node as! Enemy
            
            // Handle collision
            self.handleCollision(between: calabash!, and: enemy)
            
        case .enemymissilecalabash:
            // Get the enemy node
            let missile: Missile = contact.bodyA.node as? Missile != nil ?
                contact.bodyA.node as! Missile :
                contact.bodyB.node as! Missile
            
            // Handle collision
            self.handleCollision(between: calabash!, and: missile)
        }
    }
    
    private func collisionType(for contact: SKPhysicsContact!) -> (CollisionType?) {
        guard
            let categoryBitmaskBodyA = CategoryBitmask(rawValue: contact.bodyA.categoryBitMask),
            let categoryBitmaskBodyB = CategoryBitmask(rawValue: contact.bodyB.categoryBitMask) else {
                return nil
        }
        
        switch (categoryBitmaskBodyA, categoryBitmaskBodyB) {
        // Player missile - enemy spaceship
        case (.enemy, .playerMissile), (.playerMissile, .enemy):
            return .playermissileenemy
            
        // Player spaceship - enemy spaceship
        case (.enemy, .calabash), (.calabash, .enemy):
            return .calabashenemy
            
        default:
            return nil
        }
    }
    
}
// handle collision


extension GameScene {
    
    /// Handle collision between player spaceship and the enemy spaceship
    private func handleCollision(between calabash: Calabash, and enemy: Enemy!) {
        // Update score
        self.increaseScore(by: ScoreValue.playerMissileHitEnemy.rawValue)
        // Update life points
        self.decreasecalabashLifePoints(by: LifePointsValue.enemyHitCalabash.rawValue)
        self.decreaseLifePoints(of: enemy, by: LifePointsValue.enemyHitCalabash.rawValue)
    }
    
    private func handleCollision(between playerMissile: Missile, and enemy: Enemy) {
        // Remove missile
        playerMissile.removeFromParent()
        // Update score
        self.increaseScore(by: ScoreValue.playerMissileHitEnemy.rawValue)
        // Update life points
        self.decreaseLifePoints(of: enemy, by: LifePointsValue.playerMissileHitEnemy.rawValue)
    }
    
    private func handleCollision(between calabash: Calabash, and enemyMissile: Missile) {
        // Not supported
    }
    
}


// scores

extension GameScene {
    
    private func increaseScore(by value: Int) {
        self.scoresNode.value += value
    }
    
}
// life points

extension GameScene {
    
    private func increasecalabashLifePoints(by value: Int) {
        self.calabash!.lifePoints += value
        self.lifeIndicator.setLifePoints(self.calabash!.lifePoints, animated: true)
        
        // Add a green color blend for a short moment to indicate the increase of health
        let colorizeAction = SKAction.colorize(with: UIColor.green,
                                               colorBlendFactor: 0.7,
                                               duration: 0.2)
        let uncolorizeAction = SKAction.colorize(withColorBlendFactor: 0.0, duration: 0.2)
        
        self.calabash!.run(SKAction.sequence([colorizeAction, uncolorizeAction]))
    }
    
    private func decreasecalabashLifePoints(by value: Int) {
        self.calabash!.lifePoints += value
        self.lifeIndicator.setLifePoints(self.calabash!.lifePoints, animated: true)
        
        // Add a red color blend for a short moment to indicate the decrease of health
        let colorizeAction = SKAction.colorize(with: UIColor.red,
                                               colorBlendFactor: 0.7,
                                               duration: 0.2)
        let uncolorizeAction = SKAction.colorize(withColorBlendFactor: 0.0,
                                                 duration: 0.2)
        self.calabash!.run(SKAction.sequence([colorizeAction, uncolorizeAction]))
    }
    
    private func decreaseLifePoints(of enemy: Enemy, by value: Int) {
        enemy.lifePoints += value
        
        // Add a red color blend for a short moment to indicate the decrease of health
        let colorizeAction = SKAction.colorize(with: UIColor.red,
                                               colorBlendFactor: 0.7,
                                               duration: 0.2)
        let uncolorizeAction = SKAction.colorize(withColorBlendFactor: 0.0,
                                                 duration: 0.2)
        enemy.run(SKAction.sequence([colorizeAction, uncolorizeAction]))
    }
    
    private func enemyDidRunOutOfLifePointsEventHandler() -> DidRunOutOfLifePointsEventHandler {
        return { (object: AnyObject) -> () in
            let enemy = object as! Enemy
            let pre = enemy.pre
            let nxt = enemy.nxt
            if pre == nil {
                nxt?.pre = nil
                self.enemy_head = nxt
            }
            else if nxt == nil {
                pre?.nxt = nil
            }
            else {
                pre?.nxt = nxt
                nxt?.pre = pre
            }
            self.destroyFigure(enemy)
        }
    }
    
    private func playerDidRunOutOfLifePointsEventHandler() -> DidRunOutOfLifePointsEventHandler {
        return { (object: AnyObject) -> () in
            self.destroyFigure(self.calabash)
            self.gameSceneDelegate?.playerDidLose(withScore: self.scoresNode.value, in: self)
        }
    }
    
    private func destroyFigure(_ figure: Figure!) {
        // Create an explosion
        let explosionEmitter = SKEmitterNode(fileNamed: Constants.explosionEmmiterFileName)
        // Position it
        explosionEmitter!.position.x = figure.position.x - figure.size.width/2
        explosionEmitter!.position.y = figure.position.y
        explosionEmitter!.zPosition = figure.zPosition + 1
        // Add it to the scene
        self.addChild(explosionEmitter!)
        explosionEmitter!.run(SKAction.sequence([SKAction.wait(forDuration: 5), SKAction.removeFromParent()]))
        // Fade out the enemy and remove it
        figure.run(SKAction.sequence([SKAction.fadeOut(withDuration: 0.1), SKAction.removeFromParent()]))
    }
    
}






