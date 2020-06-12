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
        
//         if let node = self.nodes(at: touch.location(in: self)).first as? SKSpriteNode {
//            if node == homeLabel
//            {
//                    playTheGame()
//            }
//
//        }
//        playTheGame() dicomment karena error pas load GameScene
    }
    func playTheGame()
    {
        let gameScene = GameScene(size: view!.bounds.size)
        view!.presentScene(gameScene)
    }
}
