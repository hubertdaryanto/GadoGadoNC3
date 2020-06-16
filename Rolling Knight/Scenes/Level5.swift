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

class Level5: SKScene {
    var enemylives = 1
    var playerlives = 3
    var enemyhit = false
    var doorisopened = false
    var pegangkunci1: Bool = false
    let soundNode = SKAudioNode(fileNamed: "deadSound.m4a")
    let soundNode2 = SKAudioNode(fileNamed: "swordUse.m4a")
    let soundNode3 = SKAudioNode(fileNamed: "heartbeatSound.m4a")
    let soundNode4 = SKAudioNode(fileNamed: "doorSound.m4a")
    var player: SKSpriteNode!
    var health1: SKSpriteNode!
    var health2: SKSpriteNode!
    var health3: SKSpriteNode!
    var pauseButton: SKSpriteNode!
    let resumeButton = SKSpriteNode(imageNamed: "Play Button")
    let restartButton = SKSpriteNode(imageNamed: "restart_test")
    let backToHomeButton = SKSpriteNode(imageNamed: "backtohome_test")
    var tembok: SKSpriteNode!
    var pintu1: SKSpriteNode!
    var gameIsPaused: Bool = false
    var gameOver: Bool = false
    var motionManager = CMMotionManager()
    var motionQueue = OperationQueue()
    
    override func didMove(to view: SKView) {
        setupMotionManager()
        
        player = (childNode(withName: "Player") as! SKSpriteNode)
        health1 = (childNode(withName: "Health 1") as! SKSpriteNode)
        health2 = (childNode(withName: "Health 2") as! SKSpriteNode)
        health3 = (childNode(withName: "Health 3") as! SKSpriteNode)
        tembok = (childNode(withName: "tembok") as! SKSpriteNode)
        pintu1 = (childNode(withName: "pintu 1") as! SKSpriteNode)
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
                }
            }
        }
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
    
    func setupGameOverScreen()
    {
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
        
        player.physicsBody!.applyForce(CGVector(dx: moveX, dy: moveY))
        
        //move the ball visually limitation (ok lah, ini nanti aja)
//        let currentLocation = dummyplayer.position
//        if currentLocation.x < -896 || currentLocation.x > 896 || currentLocation.y < -414 || currentLocation.y > 414 {
//            moveX = 0.0
//            moveY = 0.0
//        }
//        dummyplayer.position = CGPoint(x: currentLocation.x + moveX, y: currentLocation.y + moveY)
        
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
                if gameOver == true
                {
                    restartAbisMati()
                }
                else
                {
                    restart()
                }
            }
            else if node == backToHomeButton{
                print("ini buat balik ke home")
                if gameOver == true
                {
                    backToHomeAbisMati()
                }
                else
                {
                    backToHome()
                }
                
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
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    func restartAbisMati()
    {
        soundNode.removeFromParent()
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = Level5(fileNamed: "Level 5") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        gameOver = false
    }
   func backToHome()
   {
    if let view = self.view as! SKView? {
        // Load the SKScene from 'GameScene.sks'
        if let scene = HomeScene(fileNamed: "HomeScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            
            // Present the scene
            view.presentScene(scene)
        }
        
        view.ignoresSiblingOrder = true
        
        view.showsFPS = true
        view.showsNodeCount = true
    }
    }
    func backToHomeAbisMati()
    {
        removeChildren(in: [soundNode])
      if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = HomeScene(fileNamed: "HomeScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        gameOver = false
     }
    
    func gameover()
    {
        physicsWorld.speed = 0
        soundNode.autoplayLooped = false
        if gameOver == false
        {
            addChild(soundNode)
            gameOver = true
            setupGameOverScreen()
        }
        soundNode.run(SKAction.play())
        
    }
}

extension Level5: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategory.player | PhysicsCategory.enemy {
            if playerlives > 0
            {
                if playerlives == 3
                {
                    playerlives = playerlives - 1
                    health3.isHidden = true
                }
                else if playerlives == 2
                {
                    playerlives = playerlives - 1
                    health2.isHidden = true
                }
                else if playerlives == 1
                {
                    playerlives = playerlives - 1
                    health1.isHidden = true
                    gameover()
                }
                print("player kena enemy")
                soundNode2.autoplayLooped = false
                if enemyhit == false
                {
                    addChild(soundNode2)
                    enemyhit = true
                }
                soundNode2.run(SKAction.play())
                let node2 = contact.bodyA.node?.name == "Player" ? contact.bodyA.node : contact.bodyB.node
                if let node = contact.bodyA.node?.name == "enemy" ? contact.bodyA.node : contact.bodyB.node
                {
                    enemylives = enemylives - 1
                    if enemylives == 0
                    {
                    node.run(SKAction.removeFromParent()
                    )
                        pintu1.texture = SKTexture(imageNamed: "DoorOpen(key)")
                                          pintu1.physicsBody = nil
                        soundNode4.autoplayLooped = false
                        if doorisopened == false
                        {
                        addChild(soundNode4)
                        doorisopened = true
                        }
                        soundNode4.run(SKAction.play())
                    }
                    else
                    {
                        mental(object1: (node2) as! SKSpriteNode, object2: (node) as! SKSpriteNode)
                    }
                }
            }
            else
            {
                print("yah meninggal")
                gameover()
            }
        }
        else if contactMask == PhysicsCategory.player | PhysicsCategory.potion
        {
            if playerlives == 1
            {
                playerlives = playerlives + 1
                health2.isHidden = false
            }
            else if playerlives == 2
            {
                playerlives = playerlives + 1
                health3.isHidden = false
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
           if playerlives == 3
            {
                playerlives = playerlives - 1
                health3.isHidden = true
            }
            else if playerlives == 2
            {
                playerlives = playerlives - 1
                health2.isHidden = true
            }
            else if playerlives == 1
            {
                playerlives = playerlives - 1
                health1.isHidden = true
            }
            }
            else
            {
                print("yah meninggal")
                gameover()
            }
        }
        else if contactMask == PhysicsCategory.enemy | PhysicsCategory.jarum
        {
            print("enemy kena jarum")

        }
        else if contactMask == PhysicsCategory.player | PhysicsCategory.pintu
        {
            print("player buka pintu")
            if let node = contact.bodyA.node?.name == "pintu 1" ? contact.bodyA.node : contact.bodyB.node
            {
            }
            
//            if let node = contact.bodyA.node?.name == "pintu 1" ? contact.bodyA.node : contact.bodyB.node
//            {
//
//                    print("ada yang menghilang")
//                node.run(SKAction.sequence(
//                    [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
//                     ))
//            }
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
            if let node = contact.bodyA.node?.name == "kunci 1" ? contact.bodyA.node : contact.bodyB.node
            {
                    node.run(SKAction.sequence(
                    [SKAction.wait(forDuration: 0.5), SKAction.removeFromParent()]
                     ))
                pegangkunci1 = true
            }
        }
        else if contactMask == PhysicsCategory.player | PhysicsCategory.goal
        {
            if let view = self.view as! SKView? {
                // Load the SKScene from 'GameScene.sks'
                if let scene = Level6(fileNamed: "Level 6") {
                    // Set the scale mode to scale to fit the window
                    scene.scaleMode = .aspectFill
                    
                    // Present the scene
                    view.presentScene(scene)
                }
                
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
            }
        }
    }
}

