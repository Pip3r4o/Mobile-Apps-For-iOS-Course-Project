//
//  Enemy.swift
//  JustAnotherSpaceGame
//
//  Created by Peter on 06/02/2016.
//  Copyright © 2016 PeterK. All rights reserved.
//

import Foundation

class Enemy : SKSpriteNode {
    
    init() {
        let enemySize = CGSize(width: ENEMY_SHIP_SIZE_WIDTH, height: ENEMY_SHIP_SIZE_HEIGHT);
        super.init(texture: SKTexture(imageNamed: "ship1.png"), color: UIColor.clearColor(), size: enemySize);
        
        self.setup();
    }
    
    func setup() {
        let enemySpeed = (Double)(arc4random_uniform(UInt32(ENEMY_MAX_VELOCITY) - UInt32(ENEMY_MIN_VELOCITY)) + UInt32(ENEMY_MIN_VELOCITY)) / 10;
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size);
        self.physicsBody?.affectedByGravity = false;
        self.physicsBody?.dynamic = true;
        self.physicsBody?.restitution = 1;
        self.physicsBody?.allowsRotation = false;
        self.physicsBody?.categoryBitMask = Physics.Enemy;
        self.physicsBody?.contactTestBitMask = Physics.Projectile | Physics.Player;
        
        let action = SKAction.moveToY(0, duration: enemySpeed);
        let actionDone = SKAction.removeFromParent();
        
        self.runAction(SKAction.sequence([action, actionDone]));
    }

    func moveToPos(x: CGFloat, y: CGFloat) {
        self.position = CGPoint(x: x, y: y);
    }
    
    func moveToPos(point: CGPoint) {
        self.moveToPos(point.x, y: point.y);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}