//
//  MenuScene.swift
//  Rolling Knight
//
//  Created by Hubert Daryanto on 12/06/20.
//  Copyright © 2020 Hubert Daryanto. All rights reserved.
//

import UIKit
import GameplayKit

class MenuScene: SKScene {
    let homeLabel = SKLabelNode(text: "You are in home!. Tap to play!")
    override func didMove(to view: SKView) {
        backgroundColor = UIColor.yellow
        addLabel()
    }
    
    
    func addLabel()
    {
        homeLabel.fontSize = 50
        homeLabel.fontColor = UIColor.black
        homeLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(homeLabel)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        
         if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode {
            if node == homeLabel
            {
                    playTheGame()
            }

        }
        playTheGame()
    }
    func playTheGame()
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
}
