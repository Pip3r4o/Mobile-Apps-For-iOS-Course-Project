//
//  Projectile.swift
//  JustAnotherSpaceGame
//
//  Created by Peter on 06/02/2016.
//  Copyright © 2016 PeterK. All rights reserved.
//

import Foundation

class Projectile : SKSpriteNode {
    init(x: CGFloat, y: CGFloat, top: CGFloat) {
        let projectileSize = CGSize(width: PLAYER_PROJECTILE_SIZE_WIDTH, height: PLAYER_PROJECTILE_SIZE_HEIGHT);
        
        super.init(texture: SKTexture(imageNamed: "proj3.png"), color: UIColor.clearColor(), size: projectileSize);
        
        self.setup(x, y: y, top: top);
    }

    func setup(x: CGFloat, y: CGFloat, top: CGFloat) {
        self.zPosition = -1;
        self.position = CGPoint(x: x, y: y);
        
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size);
        self.physicsBody?.affectedByGravity = false;
        self.physicsBody?.dynamic = false;
        self.physicsBody?.categoryBitMask = Physics.Projectile;
        self.physicsBody?.contactTestBitMask = Physics.Enemy;
        
        let action = SKAction.moveToY(top + self.size.height, duration: 1);
        let actionDone = SKAction.removeFromParent();
        
        self.runAction(SKAction.sequence([action, actionDone]));
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}