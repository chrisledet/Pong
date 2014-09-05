//
//  LEDMyScene.h
//  Pong
//

//  Copyright (c) 2014 Chris Ledet. All rights reserved.
//

#import "LEDMacros.h"
#import "LEDPaddle.h"

@interface LEDMainScene : SKScene <SKPhysicsContactDelegate>

- (void)pauseGame;
- (void)unpauseGame;

@end
