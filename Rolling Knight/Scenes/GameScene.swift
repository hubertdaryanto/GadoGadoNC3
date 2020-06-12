//
//  GameScene.swift
//  Rolling Knight
//
//  Created by Hubert Daryanto on 10/06/20.
//  Copyright © 2020 Hubert Daryanto. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

struct PhysicsCategory {
    static let player: UInt32 = 0b1 //1
    static let enemy: UInt32 = 0b10 // 2
    static let tembok: UInt32 = 0b100 // 4
    static let potion: UInt32 = 0b1000 // 8
    static let jarum: UInt32 = 0b10000 // 16
    static let pintu: UInt32 = 0b100000 // 32
    static let sakelar: UInt32 = 0b1000000 // 64
    static let kunci: UInt32 = 0b10000000 // 128
}

var playerlives = 3
var enemy1lives = 2
var enemy2lives = 2
class GameScene: SKScene {
    
    let enemy1 = SKSpriteNode(imageNamed: "Idle (1)")
    var dummyplayer: SKSpriteNode!
    var health1: SKSpriteNode!
    var health2: SKSpriteNode!
    var health3: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    let enemy2 = SKSpriteNode(imageNamed: "Dead (1)")
    let potion = SKSpriteNode(imageNamed: "medicine_test")
    let resumeButton = SKSpriteNode(imageNamed: "resume_test")
    let restartButton = SKSpriteNode(imageNamed: "restart_test")
    let backToHomeButton = SKSpriteNode(imageNamed: "backtohome_test")
    var tembok1: SKSpriteNode!
    var tembok2: SKSpriteNode!
    var tembok3: SKSpriteNode!
    var tembok4: SKSpriteNode!
    var jarum1: SKSpriteNode!
    var sakelar1: SKSpriteNode!
    var pintu1: SKSpriteNode!
    var pintu2: SKSpriteNode!
    var kunci1: SKSpriteNode!
    
    var pegangkunci1: Bool = false
    var gameIsPaused: Bool = false
    var motionManager = CMMotionManager()
    var motionQueue = OperationQueue()
    
    override func didMove(to view: SKView) {
        setupMotionManager()
        spawnEnemy()
        spawnPotion()
        dummyplayer = (childNode(withName: "Dummy Player") as! SKSpriteNode)
        health1 = (childNode(withName: "Health 1") as! SKSpriteNode)
        health2 = (childNode(withName: "Health 2") as! SKSpriteNode)
        health3 = (childNode(withName: "Health 3") as! SKSpriteNode)
        tembok1 = (childNode(withName: "tembok 1") as! SKSpriteNode)
        tembok2 = (childNode(withName: "tembok 2") as! SKSpriteNode)
        tembok3 = (childNode(withName: "tembok 3") as! SKSpriteNode)
        tembok4 = (childNode(withName: "tembok 4") as! SKSpriteNode)
        jarum1 = (childNode(withName: "jarum 1") as! SKSpriteNode)
        pintu1 = (childNode(withName: "pintu 1") as! SKSpriteNode)
        pintu2 = (childNode(withName: "pintu 2") as! SKSpriteNode)
        sakelar1 = (childNode(withName: "sakelar 1") as! SKSpriteNode)
        pauseButton = (childNode(withName: "PauseButton") as! SKSpriteNode)
        kunci1 = (childNode(withName: "kunci 1") as! SKSpriteNode)
        physicsWorld.contactDelegate = self
    }
    
    
    func setupMotionManager() {
        //check if avaiable
        if (motionManager.isDeviceMotionAvailable) {
            //how many timses do we wanna get sensor data in a second?
            motionManager.deviceMotionUpdateInterval = 1 / 30
            
            //start device
            motionManager.startDeviceMotionUpdates(to: motionQueue) {
                motionData, error in
                guard let data = motionData else {return}
                
                DispatchQueue.main.async {
                    self.updateBallLocation(data)
                    self.updateEnemy1Function(data)
                }
            }
        }
    }
    
    func spawnPotion()
    {
        potion.zPosition = 2
        potion.setScale(0.1)
        potion.name = "potion"
        let physicsBody2 = SKPhysicsBody(circleOfRadius: potion.size.width / 2)
        physicsBody2.affectedByGravity = false
        physicsBody2.allowsRotation = false
        physicsBody2.isDynamic = false
        physicsBody2.categoryBitMask = PhysicsCategory.potion
        potion.physicsBody = physicsBody2
        let x = CGFloat.random(in: -400...400)
        let y = CGFloat.random(in: -800...800)
        potion.position = CGPoint(x: -300, y: -300)
        
        addChild(potion)
    }
    
    func spawnEnemy()
    {
        
        enemy1.position = CGPoint(x: 400, y: 300)
        enemy1.zPosition = 2
        enemy1.scale(to: CGSize(width: 200, height: 200))
        let physicsBody1 = SKPhysicsBody(circleOfRadius: enemy1.size.width / 2)
        physicsBody1.affectedByGravity = false
        physicsBody1.allowsRotation = false
        physicsBody1.isDynamic = true
        physicsBody1.categoryBitMask = PhysicsCategory.enemy
        physicsBody1.collisionBitMask = 0b11111111111111111111111111111111
        physicsBody1.contactTestBitMask = 0b11111111111111111111111111111111
        enemy1.physicsBody = physicsBody1
        addChild(enemy1)
        
        enemy2.position = CGPoint(x: 400, y: 100)
        enemy2.zPosition = 2
        enemy2.name = "enemy2"
        enemy2.scale(to: CGSize(width: 200, height: 200))
        let physicsBody2 = SKPhysicsBody(circleOfRadius: enemy2.size.width / 2)
        physicsBody2.affectedByGravity = false
        physicsBody2.allowsRotation = false
        physicsBody2.isDynamic = true
        physicsBody2.categoryBitMask = PhysicsCategory.enemy
        physicsBody2.mass = 1.0
        enemy2.physicsBody = physicsBody2
        addChild(enemy2)
        
    }
    
    func setupPauseScreen()
       {
           resumeButton.position = CGPoint(x: 0, y: 0)
        resumeButton.zPosition = 5
        resumeButton.name = "resume button"
        resumeButton.scale(to: CGSize(width: 250, height: 250))
        addChild(resumeButton)
        
        restartButton.position = CGPoint(x: -300, y: 0)
        restartButton.zPosition = 5
        restartButton.name = "restart button"
        restartButton.scale(to: CGSize(width: 200, height: 200))
        addChild(restartButton)
        
        backToHomeButton.position = CGPoint(x: 300, y: 0)
        backToHomeButton.zPosition = 5
        backToHomeButton.name = "backtohome button"
        backToHomeButton.scale(to: CGSize(width: 200, height: 200))
        addChild(backToHomeButton)
       }
    
    func updateEnemy1Function(_ motionData: CMDeviceMotion)
    {
        var moveX = CGFloat(motionData.attitude.pitch * 100)
        var moveY = CGFloat(motionData.attitude.roll * 100)
        enemy1.physicsBody!.applyForce(CGVector(dx: moveX, dy: moveY))
        
    }
    
    func mental(object1: SKSpriteNode, object2: SKSpriteNode)
    {
        let object1speed = object1.physicsBody?.velocity
        let object2speed = object2.physicsBody?.velocity
//        object2.physicsBody?.restitution = 10
//        object1.physicsBody?.restitution = 10
        object1.physicsBody?.applyImpulse(CGVector(dx: object2speed!.dx * -3, dy: object2speed!.dy * -3))
        object2.physicsBody?.applyImpulse(CGVector(dx: object1speed!.dx * -3, dy: object1speed!.dy * -3))
        
        print(object1speed!.dx)
        print(object1speed!.dy)
        print(object2speed!.dx)
        print(object2speed!.dy)
        
    }
    func updateBallLocation(_ motionData: CMDeviceMotion) {
        //detect how much movement should be applies to the ball
        var moveX = CGFloat(motionData.attitude.pitch * 500)
        var moveY = CGFloat(motionData.attitude.roll * 500)
        
        dummyplayer.physicsBody!.applyForce(CGVector(dx: moveX, dy: moveY))
        
        //move the ball visually limitation (ok lah, ini nanti aja)
//        let currentLocation = dummyplayer.position
//        if currentLocation.x < -896 || currentLocation.x > 896 || currentLocation.y < -414 || currentLocation.y > 414 {
//            moveX = 0.0
//            moveY = 0.0
//        }
//        dummyplayer.position = CGPoint(x: currentLocation.x + moveX, y: currentLocation.y + moveY)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
     
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
         if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode {
            if node == pauseButton
            {
                    pauseTheGame()
            }
            else if node == resumeButton{
                unpauseTheGame()
            }
            else if node == restartButton{
                print("ini buat restart")
//                restart() dicomment karena error pas load GameScene
            }
            else if node == backToHomeButton{
                print("ini buat balik ke home")
                backToHome()
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
    func pauseTheGame()
    {
        gameIsPaused = true
        physicsWorld.speed = 0
        setupPauseScreen()
    }
    
    func unpauseTheGame()
    {
        gameIsPaused = false
        physicsWorld.speed = 1
        removeChildren(in: [restartButton, resumeButton, backToHomeButton])
    }
    
    func restart()
    {
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
   func backToHome()
   {
    let homeScene = MenuScene(size: view!.bounds.size)
    view!.presentScene(homeScene)
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategory.player | PhysicsCategory.enemy {
            if playerlives > 0
            {
                playerlives = playerlives - 1
                health3.removeFromParent()
                print("player kena enemy")
                let node2 = contact.bodyA.node?.name == "Dummy Player" ? contact.bodyA.node : contact.bodyB.node
                if let node = contact.bodyA.node?.name == "enemy2" ? contact.bodyA.node : contact.bodyB.node
                {
                    enemy2lives = enemy2lives - 1
                    if enemy2lives == 0
                    {
                    node.run(SKAction.sequence(
                    [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
                    ))
                    }
                    else
                    {
                        mental(object1: (node2) as! SKSpriteNode, object2: (node) as! SKSpriteNode)
                    }
                }
                if let node = contact.bodyA.node?.name == "enemy1" ? contact.bodyA.node : contact.bodyB.node
                {
                    enemy1lives = enemy1lives - 1
                    if enemy1lives == 0
                    {
                        node.run(SKAction.sequence(
                        [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
                         ))
                    }
                    else
                    {
                        mental(object1: (contact.bodyA.node) as! SKSpriteNode, object2: (contact.bodyB.node) as! SKSpriteNode)
                    }
                }
            }
            else
            {
                print("yah meninggal")
            }
        }
        else if contactMask == PhysicsCategory.player | PhysicsCategory.potion
        {
            print("player kena potion")
            if playerlives < 3
            {
                playerlives = playerlives + 1
                addChild(health3)
            }
            let node = contact.bodyA.node?.name == "potion" ? contact.bodyA.node : contact.bodyB.node
            node?.run(SKAction.sequence(
                [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
            ))
        }
        else if contactMask == PhysicsCategory.player | PhysicsCategory.tembok
        {
            print("player kena tembok")
        }
        else if contactMask == PhysicsCategory.enemy | PhysicsCategory.tembok
        {
            print("enemy kena tembok")
        }
        else if contactMask == PhysicsCategory.player | PhysicsCategory.jarum
        {
            if playerlives > 1
            {
            print("player kena jarum")
            playerlives = playerlives - 1
            }
            else
            {
                print("yah meninggal")
            }
        }
        else if contactMask == PhysicsCategory.enemy | PhysicsCategory.jarum
        {
            print("enemy kena jarum")
            if let node = contact.bodyA.node?.name == "enemy1" ? contact.bodyA.node : contact.bodyB.node
            {
                enemy1lives = enemy1lives - 1
                if enemy1lives == 0
                {
                    node.run(SKAction.sequence(
                    [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
                     ))
                }
                
            }
            if let node = contact.bodyA.node?.name == "enemy2" ? contact.bodyA.node : contact.bodyB.node
            {
                enemy2lives = enemy2lives - 1
                if enemy2lives == 0
                {
                node.run(SKAction.sequence(
                [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
            ))
                }
            }
        }
        else if contactMask == PhysicsCategory.player | PhysicsCategory.pintu
        {
            print("player buka pintu")
            if let node = contact.bodyA.node?.name == "pintu 1" ? contact.bodyA.node : nil
            {
                if node != nil
                {
                    print("ada yang menghilang")
                                       node.run(SKAction.sequence(
                                       [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
                                        ))
                }
            }
            
            if let node = contact.bodyA.node?.name == "pintu 2" ? contact.bodyA.node : contact.bodyB.node
            {
                if pegangkunci1
                {
                    print("ada yang menghilang")
                node.run(SKAction.sequence(
                    [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
                     ))
                }
            }
        }
        else if contactMask == PhysicsCategory.player | PhysicsCategory.sakelar
        {
            print("player tekan sakelar buat buka pintu")
            
            let node = pintu1!
            node.run(SKAction.sequence(
                    [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
                     ))
                
        }
        else if contactMask == PhysicsCategory.player | PhysicsCategory.kunci
        {
            print("player ambil kunci")
            pegangkunci1 = true
            if let node = contact.bodyA.node?.name == "kunci 1" ? contact.bodyA.node : contact.bodyB.node
            {
                    node.run(SKAction.sequence(
                    [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
                     ))

            }
        }
    }
}
