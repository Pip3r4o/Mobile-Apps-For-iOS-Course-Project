//
//  GameScene.swift
//  JustAnotherSpaceGame
//
//  Created by Peter on 03/02/2016.
//  Copyright (c) 2016 PeterK. All rights reserved.
//

import SpriteKit
import CoreMotion

struct Physics {
    static let Enemy : UInt32 = 1;
    static let Projectile : UInt32 = 2;
    static let Player : UInt32 = 3;
    static let EnemyProjectile : UInt32 = 4;
    
    static let GameSceneBoundaries : UInt32 = 5;
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var score = 0;
    var scoreLabel = UILabel();
    
    var background = SKSpriteNode(imageNamed: "background.jpg");
    
    var Player = SKSpriteNode(imageNamed: "ship.png");
    var motionManager = CMMotionManager();
    var destX = CGFloat(0.0);
    
    var enemySpawnRate = 0.5;
    var enemyVelocity = 3.0;
    var shootingRate = 0.5;
    var scorePerEnemyKilled = 50;
    var scorePerBulletIntercepted = 1;
    var gameDifficulty = 1;
    var initialLives = 3;
    
    override func didMoveToView(view: SKView) {
        // add constraint to scene to ensure no object leaves the scene
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame);
        self.physicsBody?.categoryBitMask = Physics.GameSceneBoundaries;
        
        background.position = CGPointMake(0, 0);
        background.zPosition = -100;
        
        self.addChild(background);
        
        physicsWorld.contactDelegate = self;
        
        Player.position = CGPointMake(self.size.width/2, self.size.height/8);
        Player.physicsBody = SKPhysicsBody(rectangleOfSize: Player.size);
        
        Player.physicsBody?.affectedByGravity = false;
        Player.physicsBody?.categoryBitMask = Physics.Player;
        Player.physicsBody?.contactTestBitMask = Physics.Enemy;
        Player.physicsBody?.dynamic = false;
        
        self.addChild(Player);
        
        scoreLabel.text = "\(score)";
        scoreLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20));
        scoreLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0);
        scoreLabel.textColor = UIColor.whiteColor();
        
        self.view?.addSubview(scoreLabel);
        
        let playerProjectilesTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("ShootProjectiles"), userInfo: nil, repeats: true);
        
        let enemySpawnTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(enemySpawnRate), target: self, selector: ("SpawnBaddies"), userInfo: nil, repeats: true);
        
        if (motionManager.accelerometerAvailable == true) {
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:{
                data, error in
                
                let currentX = self.Player.position.x;
                
                if data!.acceleration.x < 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 400);
                }
                else if data!.acceleration.x > 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 400);
                }
            });
        } else {
            NSLog("Motion manager not available");
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
         // Enable to work with acceleration instead of taps
          let action = SKAction.moveToX(destX, duration: 1);
          self.Player.runAction(action);
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        let bodyA : SKPhysicsBody = contact.bodyA;
        let bodyB : SKPhysicsBody = contact.bodyB;
        
        if ((bodyA.categoryBitMask == Physics.Enemy && bodyB.categoryBitMask == Physics.Projectile)
            || (bodyA.categoryBitMask == Physics.Projectile && bodyB.categoryBitMask == Physics.Enemy)) {
            CollisionWithProjectile(bodyA.node as! SKSpriteNode, bullet: bodyB.node as! SKSpriteNode);
        }
        
        // if ((bodyA.categoryBitMask == Physics.Enemy && bodyB.categoryBitMask == Physics.Player)
        //    || (bodyA.categoryBitMask == Physics.Player && bodyB.categoryBitMask == Physics.Enemy)) {
        //        CollisionWithPlayer(bodyA.node as! SKSpriteNode, player: bodyB.node as! SKSpriteNode);
        //}
    }
    
    func CollisionWithProjectile(enemy: SKSpriteNode, bullet: SKSpriteNode) {
        // TODO: Add score flash +50 or something
        enemy.removeFromParent();
        bullet.removeFromParent();
        score += scorePerEnemyKilled;
        
        scoreLabel.text = "\(score)";
    }
    
    func CollisionWithPlayer(enemy: SKSpriteNode, player: SKSpriteNode) {
        // take away 1 life, perform check whether there's more life else go game over
    }
    
    func CollisionProjectileWithEnemyProjectile(projectile: SKSpriteNode, enemyProjectile: SKSpriteNode) {
        // destroy both projectiles;
    }
    
    func GameOver() {
        // navigate to game over screen where score is displayed
        self.view?.presentScene(GameOverScene());
    }
    
    func ShootProjectiles(){
        let projectile = SKSpriteNode(imageNamed: "proj3.png");
        
        projectile.zPosition = -1;
        projectile.position = CGPointMake(Player.position.x, Player.position.y);
        
        let action = SKAction.moveToY(self.size.height + projectile.size.height, duration: 1);
        let actionDone = SKAction.removeFromParent();
        
        projectile.runAction(SKAction.sequence([action, actionDone]));
        
        projectile.physicsBody = SKPhysicsBody(rectangleOfSize: projectile.size);
        projectile.physicsBody?.affectedByGravity = false;
        projectile.physicsBody?.dynamic = false;
        projectile.physicsBody?.categoryBitMask = Physics.Projectile;
        projectile.physicsBody?.contactTestBitMask = Physics.Enemy;
        
        self.addChild(projectile);
    }
    
    func SpawnBaddies(){
        let enemy = SKSpriteNode(imageNamed: "ship1.png");
        enemy.size.height = enemy.size.height / 2;
        enemy.size.width = enemy.size.width / 2;
        
        let minX = 0 + enemy.size.width + 20;
        let maxX = self.size.width - enemy.size.width - 20;
        
        let spawnPoint = UInt32(maxX - minX);
        
        enemy.position = CGPoint(x: CGFloat(arc4random_uniform(spawnPoint)), y: self.size.height);
        
        let action = SKAction.moveToY(0 - enemy.size.height, duration: enemyVelocity);
        let actionDone = SKAction.removeFromParent();
        
        enemy.runAction(SKAction.sequence([action, actionDone]));
        
        enemy.physicsBody = SKPhysicsBody(rectangleOfSize: enemy.size);
        enemy.physicsBody?.affectedByGravity = false;
        enemy.physicsBody?.dynamic = true;
        enemy.physicsBody?.categoryBitMask = Physics.Enemy;
        enemy.physicsBody?.contactTestBitMask = Physics.Projectile;
        
        self.addChild(enemy);
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
