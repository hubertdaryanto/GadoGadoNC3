//
//  HomeScene.swift
//  Rolling Knight
//
//  Created by Hubert Daryanto on 16/06/20.
//  Copyright © 2020 Hubert Daryanto. All rights reserved.
//

import UIKit
import GameplayKit

class HomeScene: SKScene {
    var missionButton: SKSpriteNode!
    var playButton: SKSpriteNode!
    var optionButton: SKSpriteNode!
    override func didMove(to view: SKView) {
        print("test masuk")
        missionButton = (childNode(withName: "Mission Button") as! SKSpriteNode)
        playButton = (childNode(withName: "Play Button") as! SKSpriteNode)
        optionButton = (childNode(withName: "Option Button") as! SKSpriteNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode {
            if node == playButton
            {
                    playTheGame()
            }
            else if node == missionButton
            {
                viewMissionList()
            }
            else if node == optionButton
            {
                viewOption()
            }
        }
    }
    
    func playTheGame()
    {
            if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = Level1(fileNamed: "Level 1") {
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
    
    func viewMissionList()
    {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = MissionScene(fileNamed: "MissionScene") {
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
    
    func viewOption()
    {
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = OptionScene(fileNamed: "OptionScene") {
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
