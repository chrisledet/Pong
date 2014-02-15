//
//  LEDMyScene.h
//  Pong
//

//  Copyright (c) 2014 Chris Ledet. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "LEDMacros.h"
#import "LEDPaddle.h"

@interface LEDMyScene : SKScene <SKPhysicsContactDelegate>

- (void)pauseGame;
- (void)unpauseGame;

@end
