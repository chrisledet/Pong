//
//  LEDMyScene.m
//  Pong
//
//  Created by Chris Ledet on 2/11/14.
//  Copyright (c) 2014 Chris Ledet. All rights reserved.
//

#import "LEDMyScene.h"

#define LED_PONG_MOVE_UP        13  // W
#define LED_PONG_MOVE_UP_ALT    126 // Arrow Up
#define LED_PONG_MOVE_DOWN      1   // S
#define LED_PONG_MOVE_DOWN_ALT  125 // Arrow Down

#define LED_PONG_PADDLE_SIZE    CGSizeMake(35, 150)
#define LED_PONG_PADDING        20
#define LED_PONG_PADDLE_SPEED   15

@interface LEDMyScene()

@property (nonatomic, strong) SKSpriteNode *playerPaddle;

@end

@implementation LEDMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */

        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];

        NSLog(@"self.size: %@", NSStringFromSize(self.size));
        
        self.backgroundColor = [SKColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0];

        self.playerPaddle = [SKSpriteNode spriteNodeWithColor:[NSColor whiteColor] size:LED_PONG_PADDLE_SIZE];
        self.playerPaddle.position = CGPointMake((CGRectGetMaxX(self.frame) - LED_PONG_PADDLE_SIZE.width/2) - LED_PONG_PADDING, CGRectGetMidX(self.frame));
        [self addChild:self.playerPaddle];
    }

    return self;
}

-(void)keyDown:(NSEvent *)keyEvent
{
    if ([keyEvent keyCode] == LED_PONG_MOVE_UP || [keyEvent keyCode] == LED_PONG_MOVE_UP_ALT)
    {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(currentPosition.x, currentPosition.y + LED_PONG_PADDLE_SPEED);
    }
    else if ([keyEvent keyCode] == LED_PONG_MOVE_DOWN || [keyEvent keyCode] == LED_PONG_MOVE_DOWN_ALT)
    {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(currentPosition.x, currentPosition.y - LED_PONG_PADDLE_SPEED);
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
