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

class GameScene: SKScene {
    
    
    var dummyplayer: SKSpriteNode!
    
    var motionManager = CMMotionManager()
    var motionQueue = OperationQueue()
    
    override func didMove(to view: SKView) {
        setupMotionManager()
        dummyplayer = (childNode(withName: "Dummy Player") as! SKSpriteNode)
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
    
    func updateBallLocation(_ motionData: CMDeviceMotion) {
        //detect how much movement should be applies to the ball
        var moveX = CGFloat(motionData.attitude.pitch * 10)
        var moveY = CGFloat(motionData.attitude.roll * 10)
        
        //move the ball visually limitation (ok lah, ini nanti aja)
        let currentLocation = dummyplayer.position
        if currentLocation.x < -896 || currentLocation.x > 896 || currentLocation.y < -414 || currentLocation.y > 414 {
            moveX = 0.0
            moveY = 0.0
        }
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
