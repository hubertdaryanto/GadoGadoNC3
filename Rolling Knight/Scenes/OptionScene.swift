//
//  OptionScene.swift
//  Rolling Knight
//
//  Created by Hubert Daryanto on 16/06/20.
//  Copyright © 2020 Hubert Daryanto. All rights reserved.
//

import UIKit
import GameplayKit
class OptionScene: SKScene {
    var backButton: SKSpriteNode!
    var applyButton: SKSpriteNode!
    override func didMove(to view: SKView) {
        backButton = (childNode(withName: "Back Button") as! SKSpriteNode)
        applyButton = (childNode(withName: "Apply Button") as! SKSpriteNode)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
        if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode {
            if node == backButton
            {
                    backToMainMenu()
            }
            else if node == applyButton
            {
                backToMainMenu()
            }
        }
    }
    
    func backToMainMenu()
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
    
   
}
