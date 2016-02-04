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
    var scoreNode = SKLabelNode();
    
    var lifeNodes : [SKSpriteNode] = [];
    
    var background = SKSpriteNode(imageNamed: "background.jpg");
    
    var Player = SKSpriteNode(imageNamed: "ship.png");
    var motionManager = CMMotionManager();
    var destX = CGFloat(0.0);
    
    var enemySpawnRate = 0.5;
    var enemyVelocity = 3.0;
    var shootingRate = 0.5;
    var scorePerEnemyKilled = 50;
    var scorePerBulletIntercepted = 10;
    var gameDifficulty = 1;
    var remainingLives = 3;
    var timeElapsed = 0.0;
    
    var gamePaused = false;
    
    var hasAccelerometer = true;
    
    var playingSceneXOffset = CGFloat(200.0);
    
    func createHUD() {
        let hud = SKSpriteNode(color: UIColor.blackColor(), size: CGSizeMake(self.size.width, self.size.height * 0.05))
        hud.anchorPoint = CGPointMake(0, 0);
        hud.position = CGPointMake(0, self.size.height - hud.size.height);
        hud.zPosition = 10;
        self.addChild(hud);
        
        // Display the remaining lifes
        // Add icons to display the remaining lifes
        // Reuse the Spaceship image: Scale and position releative to the HUD size
        let lifeSize = CGSizeMake(hud.size.height - 10, hud.size.height - 10)
        
        for(var i = 0; i < self.remainingLives; i++) {
            let tmpNode = SKSpriteNode(imageNamed: "ship.png");
            lifeNodes.append(tmpNode);
            tmpNode.size = lifeSize;
            tmpNode.position = CGPointMake((hud.size.width/3.5) + tmpNode.size.width * 1.1 * (1.0 + CGFloat(i)), 15);
            hud.addChild(tmpNode);
        }
        
        // Pause button container and label
        // Needed to increase the touchable area
        // Names will be used to identify these elements in the touch handler
        let pauseContainer = SKSpriteNode();
        pauseContainer.position = CGPointMake(hud.size.width/1.5, 15);
        pauseContainer.size = CGSizeMake(hud.size.height * 3, hud.size.height * 1.5);
        pauseContainer.name = "PauseButtonContainer";
        hud.addChild(pauseContainer);
        
        let pauseButton = SKLabelNode();
        pauseButton.position = CGPointMake(hud.size.width/1.5, 10);
        pauseButton.text = "||";
        pauseButton.fontSize = hud.size.height * 0.80;
        pauseButton.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center;
        pauseButton.name = "PauseButton";
        hud.addChild(pauseButton);
        
        // Display the current score
        self.score = 0;
        self.scoreNode.position = CGPointMake(hud.size.width/2, 5);
        self.scoreNode.text = "0";
        self.scoreNode.fontSize = hud.size.height;
        hud.addChild(self.scoreNode);
    }
    
    override func didMoveToView(view: SKView) {
        background.position = CGPointMake(0, 0);
        background.zPosition = -100;
        
        self.addChild(background);
        
        createHUD();
        
        physicsWorld.contactDelegate = self;
        
        Player.position = CGPointMake(self.size.width/2, self.size.height/8);
        Player.physicsBody = SKPhysicsBody(rectangleOfSize: Player.size);
        
        Player.physicsBody?.affectedByGravity = false;
        Player.physicsBody?.categoryBitMask = Physics.Player;
        Player.physicsBody?.contactTestBitMask = Physics.Enemy;
        Player.physicsBody?.dynamic = false;
        
        self.addChild(Player);
        
        //scoreLabel.text = "\(score)";
        //scoreLabel = UILabel(frame: CGRect(x: 20, y: 10, width: 100, height: 20));
        //scoreLabel.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.0);
        //scoreLabel.textColor = UIColor.whiteColor();
        
        //self.view?.addSubview(scoreLabel);
        
        let playerProjectilesTimer = NSTimer.scheduledTimerWithTimeInterval(0.3, target: self, selector: Selector("ShootProjectiles"), userInfo: nil, repeats: true);
        
        let enemySpawnTimer = NSTimer.scheduledTimerWithTimeInterval(NSTimeInterval(enemySpawnRate), target: self, selector: ("SpawnBaddies"), userInfo: nil, repeats: true);
        
        if (motionManager.accelerometerAvailable == true) {
            motionManager.accelerometerUpdateInterval = 0.1;
            motionManager.startAccelerometerUpdatesToQueue(NSOperationQueue.currentQueue()!, withHandler:{
                data, error in
                
                let currentX = self.Player.position.x;
                
                self.destX = currentX + CGFloat(data!.acceleration.x * 350);
                
                if(self.destX > (self.size.width / 2) + self.playingSceneXOffset) {
                    self.destX = (self.size.width / 2) + self.playingSceneXOffset;
                }
                
                if(self.destX < (self.size.width / 2) - self.playingSceneXOffset) {
                    self.destX = (self.size.width / 2) - self.playingSceneXOffset;
                }
            });
        } else {
            hasAccelerometer = false;
            NSLog("Motion manager not available");
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
         // Enable to work with acceleration instead of taps
        
        if(!self.gamePaused) {
        
            if(!hasAccelerometer) {
                return;
            }
        
          let action = SKAction.moveToX(destX, duration: 0.2);
          self.Player.runAction(action);
        }
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
        
        self.scoreNode.text = "\(score)";
    }
    
    func CollisionWithPlayer(enemy: SKSpriteNode, player: SKSpriteNode) {
        // take away 1 life, perform check whether there's more life else go game over
        self.remainingLives--;
        
        if(self.remainingLives <= 0) {
            GameOver();
        }
        
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
        
        let minX : UInt32 = UInt32((self.size.width / 2) - self.playingSceneXOffset);
        let maxX : UInt32 = UInt32((self.size.width / 2) + self.playingSceneXOffset);
        
        enemy.position = CGPoint(x: CGFloat(arc4random_uniform(maxX - minX) + minX), y: self.size.height);
        
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
            let location = touch.locationInNode(self);
            
            let node = self.nodeAtPoint(location);
            
            if((node.name == "PauseButton") || (node.name == "PauseButtonContainer")) {
                
                pauseGame();
            }
            
            // Player.position.x = location.x;
            
            let action = SKAction.moveToX(location.x, duration: 0.2);
            
            Player.runAction(action);
        }
    }
    
    func pauseGame() {
        // TODO:
        NSLog("Hi!");
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
