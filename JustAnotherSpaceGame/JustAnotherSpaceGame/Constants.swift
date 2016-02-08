//
//  Constants.swift
//  JustAnotherSpaceGame
//
//  Created by Peter on 07/02/2016.
//  Copyright © 2016 PeterK. All rights reserved.
//

import Foundation

struct Physics {
    static let Enemy : UInt32 = 1;
    static let Projectile : UInt32 = 2;
    static let Player : UInt32 = 3;
    static let EnemyProjectile : UInt32 = 4;
    
    static let GameSceneBoundaries : UInt32 = 5;
}

let INITIAL_LIVES = 1;
let INITIAL_ENEMY_SPAWNRATE = 1.0;

let ENEMY_SPAWNRATE_DELTA = 0.05;
let ENEMY_MIN_VELOCITY = 25;
let ENEMY_MAX_VELOCITY = 50;

let ENEMY_SHIP_SIZE_WIDTH = 40;
let ENEMY_SHIP_SIZE_HEIGHT = 60;

let PLAYER_SHIP_SIZE_WIDTH = 80;
let PLAYER_SHIP_SIZE_HEIGHT = 100;
let PLAYER_SHOOTING_RATE = 0.4;

let SCORE_ENEMY = 50;
let SCORE_BULLET = 20;

let PLAYER_PROJECTILE_SIZE_WIDTH = 30;
let PLAYER_PROJECTILE_SIZE_HEIGHT = 15;