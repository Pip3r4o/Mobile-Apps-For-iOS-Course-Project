//
//  MainMenu.m
//  JustAnotherSpaceGame
//
//  Created by Peter on 06/02/2016.
//  Copyright © 2016 PeterK. All rights reserved.
//

#import "MainMenu.h"
#import "JustAnotherSpaceGame-Swift.h"

@implementation MainMenu

SKSpriteNode *background;
SKLabelNode *title;
SKLabelNode *instruction;
SKSpriteNode *ship;

-(void)didMoveToView:(SKView *)view
{
    background = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
    background.position = CGPointMake(0.0, 0.0);
    background.zPosition = -100;
    [self addChild:background];
    
    title = [SKLabelNode labelNodeWithFontNamed:@"Noteworthy"];
    title.text = @"Chalkboard Shooter";
    title.fontSize = 32;
    title.position = CGPointMake(self.size.width/2, self.size.height/1.5);
    [self addChild:title];
    
    instruction = [SKLabelNode labelNodeWithFontNamed:@"Noteworthy"];
    instruction.text = @"Tap to Start";
    instruction.position = CGPointMake(self.size.width/2, self.size.height/5);
    
    SKAction *grow = [SKAction scaleBy:2 duration:1.75];
    SKAction *shrink = [SKAction scaleBy:0.5 duration:1.75];
    
    [instruction runAction:[SKAction repeatActionForever: [SKAction sequence:@[grow, shrink]]]];
    
    [self addChild:instruction];
    
    ship = [SKSpriteNode spriteNodeWithImageNamed:@"ship.png"];
    ship.position = CGPointMake(self.size.width/3, self.size.height/2.5);
    ship.zRotation = 269.0;
    
    [self addChild:ship];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    CGPoint location = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:location];
    
    NSLog(@"%f", self.size.height);
    NSLog(@"%f", self.size.width);
    
    SKScene *newGameScene = [GameScene sceneWithSize:CGSizeMake(self.size.width, self.size.height)];
    newGameScene.scaleMode = SKSceneScaleModeAspectFill;
    SKTransition *transition = [SKTransition moveInWithDirection:SKTransitionDirectionUp duration:0.8];
    [self.view presentScene: newGameScene transition:transition];
}

@end
