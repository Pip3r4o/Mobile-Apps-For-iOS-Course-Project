//
//  Player.swift
//  JustAnotherSpaceGame
//
//  Created by Peter on 06/02/2016.
//  Copyright © 2016 PeterK. All rights reserved.
//

import Foundation

class Player : SKSpriteNode {
    
    var isInvincible = false;
    
    init() {
        let shipSize = CGSize(width: PLAYER_SHIP_SIZE_WIDTH, height: PLAYER_SHIP_SIZE_HEIGHT);
        super.init(texture: SKTexture(imageNamed: "ship.png"), color: UIColor.clearColor(), size: shipSize);
        
        self.setup();
    }
    
    func setup() {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size);
        self.physicsBody?.affectedByGravity = false;
        self.physicsBody?.categoryBitMask = Physics.Player;
        self.physicsBody?.contactTestBitMask = Physics.Enemy;
        self.physicsBody?.dynamic = false;
    }
    
    func move(toX: CGFloat) {
        let action = SKAction.moveToX(toX, duration: 0.2);
        self.runAction(action);
    }
    
    func pulse() {
        let fadeOut = SKAction.fadeOutWithDuration(0.5);
        let fadeIn = SKAction.fadeInWithDuration(0.5);
        
        let pulse = SKAction.sequence([fadeOut, fadeIn, fadeOut, fadeIn, fadeOut, fadeIn]);
        
        self.runAction(pulse);
    }
    
    func toggleInvincibility() {
        self.isInvincible = !self.isInvincible;
    }
    
    func playerIsInvincible() -> Bool {
        return self.isInvincible;
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}