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

-(void)didMoveToView:(SKView *)view
{
    background = [SKSpriteNode spriteNodeWithImageNamed:@"background.jpg"];
    background.position = CGPointMake(0.0, 0.0);
    [self addChild:background];
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
