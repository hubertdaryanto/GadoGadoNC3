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
}

var lives = 3
class GameScene: SKScene {
    
    let enemy1 = SKSpriteNode(imageNamed: "Idle (1)")
    var dummyplayer: SKSpriteNode!
    var health1: SKSpriteNode!
    var health2: SKSpriteNode!
    var health3: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    let enemy2 = SKSpriteNode(imageNamed: "Dead (1)")
    let potion = SKSpriteNode(imageNamed: "medicine_test")
    
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
        pauseButton = (childNode(withName: "PauseButton") as! SKSpriteNode)
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
        
        enemy1.position = CGPoint(x: -400, y: 300)
        enemy1.zPosition = 2
        addChild(enemy1)
        
        enemy2.position = CGPoint(x: 400, y: 100)
        enemy2.zPosition = 2
        enemy2.name = "enemy2"
        let physicsBody2 = SKPhysicsBody(circleOfRadius: enemy2.size.width / 2)
        physicsBody2.affectedByGravity = false
        physicsBody2.allowsRotation = false
        physicsBody2.isDynamic = false
        physicsBody2.categoryBitMask = PhysicsCategory.enemy
        enemy2.physicsBody = physicsBody2
        addChild(enemy2)
        
    }
    
    func updateEnemy1Function(_ motionData: CMDeviceMotion)
    {
        var moveX = CGFloat(motionData.attitude.pitch * 10)
        var moveY = CGFloat(motionData.attitude.roll * 10)
        let currentLocation = enemy1.position
        enemy1.position = CGPoint(x: currentLocation.x + moveX, y: currentLocation.y + moveY)
        
    }
    func updateBallLocation(_ motionData: CMDeviceMotion) {
        //detect how much movement should be applies to the ball
        var moveX = CGFloat(motionData.attitude.pitch * 10)
        var moveY = CGFloat(motionData.attitude.roll * 10)
        
        //move the ball visually limitation (ok lah, ini nanti aja)
        let currentLocation = dummyplayer.position
//        if currentLocation.x < -896 || currentLocation.x > 896 || currentLocation.y < -414 || currentLocation.y > 414 {
//            moveX = 0.0
//            moveY = 0.0
//        }
        dummyplayer.position = CGPoint(x: currentLocation.x + moveX, y: currentLocation.y + moveY)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {
     
    }
    
    func touchUp(atPoint pos : CGPoint) {
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      
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
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategory.player | PhysicsCategory.enemy {
            if lives != 0
            {
                lives = lives - 1
                health3.removeFromParent()
                print("player kena enemy")
                let node = contact.bodyA.node?.name == "enemy2" ? contact.bodyA.node : contact.bodyB.node
                node?.run(SKAction.sequence(
                    [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
                ))
            }
            else
            {
                print("yah meninggal")
            }
        }
        else if contactMask == PhysicsCategory.player | PhysicsCategory.potion
        {
            print("player kena potion")
            lives = lives + 1
            addChild(health3)
            let node = contact.bodyA.node?.name == "potion" ? contact.bodyA.node : contact.bodyB.node
            node?.run(SKAction.sequence(
                [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
            ))
        }
    }
}
