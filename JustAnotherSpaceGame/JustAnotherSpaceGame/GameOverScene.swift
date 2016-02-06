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
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = SKColor(red: 0.2, green: 1, blue: 0.7, alpha: 1);
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