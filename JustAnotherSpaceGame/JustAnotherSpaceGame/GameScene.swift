//
//  GameScene.swift
//  JustAnotherSpaceGame
//
//  Created by Peter on 03/02/2016.
//  Copyright (c) 2016 PeterK. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene {
    
    var Player = SKSpriteNode(imageNamed: "ship.png");
    var motionManager = CMMotionManager();
    var destX = CGFloat(0.0);
    var enemySpawnRate = 3.0;
    var enemyVelocity = 3.0;
    
    override func didMoveToView(view: SKView) {
        Player.position = CGPointMake(self.size.width/2, self.size.height/8);
        
        self.addChild(Player);
        
        let playerProjectilesTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("ShootProjectiles"), userInfo: nil, repeats: true);
        
        let enemySpawnTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(enemySpawnRate), target: self, selector: ("SpawnBaddies"), userInfo: nil, repeats: true);
        
        if motionManager.accelerometerAvailable == true {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:{
                data, error in
                
                let currentX = self.Player.position.x;
                
                if data!.acceleration.x < 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 10);
                }
                else if data!.acceleration.x > 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 10);
                }
            });
        } else {
            NSLog("Motion manager not available");
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        // Enable to work with acceleration instead of taps
        // let action = SKAction.moveToX(destX, duration: 1);
        // self.Player.runAction(action);
    }
    
    func ShootProjectiles(){
        let Projectile = SKSpriteNode(imageNamed: "proj3.png");
        
        Projectile.zPosition = -1;
        Projectile.position = CGPointMake(Player.position.x, Player.position.y);
        
        let action = SKAction.moveToY(self.size.height + Projectile.size.height, duration: 1);
        Projectile.runAction(SKAction.repeatActionForever(action));
        
        self.addChild(Projectile);
        
    }
    
    func SpawnBaddies(){
        let Enemy = SKSpriteNode(imageNamed: "ship1.png");
        Enemy.size.height = Enemy.size.height / 2;
        Enemy.size.width = Enemy.size.width / 2;
        
        let minX = self.size.width/8;
        let maxX = self.size.width - Enemy.size.width / 2;
        
        let spawnPoint = UInt32(maxX - minX);
        
        Enemy.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height);
        
        let action = SKAction.moveToY(0 - Enemy.size.height, duration: enemyVelocity);
        
        Enemy.runAction(action);
        
        self.addChild(Enemy);
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
            
            // Player.position.x = location.x;
            
            let action = SKAction.moveToX(location.x, duration: 0.2);
            
            Player.runAction(action);
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        for touch in touches {
            let location = touch.locationInNode(self)
            
            // Player.position.x = location.x;
            
            let action = SKAction.moveToX(location.x, duration: 0.2);
            
            Player.runAction(action);
        }
    }
}
