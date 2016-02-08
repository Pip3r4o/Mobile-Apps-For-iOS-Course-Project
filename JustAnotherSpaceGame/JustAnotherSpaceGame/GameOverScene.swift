//
//  GameOverScene.swift
//  JustAnotherSpaceGame
//
//  Created by Peter on 04/02/2016.
//  Copyright © 2016 PeterK. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene : SKScene {
    
    var background = SKSpriteNode(imageNamed: "background.jpg");
    
    override func didMoveToView(view: SKView) {
        background.position = CGPointMake(0, 0);
        background.zPosition = -100;
        
        self.addChild(background);
        
        let currentScoreLabel = SKLabelNode(fontNamed: "Noteworthy");
        currentScoreLabel.text = "Your Score: \(PublicScore.currentScore)";
        currentScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height/1.25);
        
        self.addChild(currentScoreLabel);
        
        let highScoreLabel = SKLabelNode(fontNamed: "Noteworthy");
        highScoreLabel.text = "Current Top: \(PublicScore.highScore)";
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height/1.45);
        
        self.addChild(highScoreLabel);
        
        let tapToStartLabel = SKLabelNode(fontNamed: "Noteworthy");
        tapToStartLabel.text = "Tap to start over";
        tapToStartLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/5);
        
        self.addChild(tapToStartLabel);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self);
            
            let node = self.nodeAtPoint(location);
            
            let transition:SKTransition = SKTransition.revealWithDirection(SKTransitionDirection.Down, duration: 0.2);
            
            self.view?.presentScene(MainMenu(size: CGSize(width: self.size.width, height: self.size.height)), transition: transition);
            break;
        }
    }
}