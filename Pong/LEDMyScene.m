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
#define LED_PONG_PADDLE_SPEED   20

@interface LEDMyScene()

@property (nonatomic, strong) SKSpriteNode *playerPaddle;

@property (nonatomic, assign) BOOL moveUp;
@property (nonatomic, assign) BOOL moveDown;

@end

@implementation LEDMyScene

- (id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {

        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.backgroundColor = [SKColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0];

        self.playerPaddle = [SKSpriteNode spriteNodeWithColor:[NSColor whiteColor] size:LED_PONG_PADDLE_SIZE];
        self.playerPaddle.position = CGPointMake((CGRectGetMaxX(self.frame) - LED_PONG_PADDLE_SIZE.width/2) - LED_PONG_PADDING, CGRectGetMidX(self.frame));
        [self addChild:self.playerPaddle];
    }

    return self;
}

#pragma mark - OS X Event Handling

- (void)keyUp:(NSEvent *)keyEvent {
    [self handleKeyEvent:keyEvent keyDown:NO];
}

-(void)keyDown:(NSEvent *)keyEvent {
    [self handleKeyEvent:keyEvent keyDown:YES];
}

- (void)handleKeyEvent:(NSEvent*)keyEvent keyDown:(BOOL)isKeyDown {

    if ([keyEvent keyCode] == LED_PONG_MOVE_UP || [keyEvent keyCode] == LED_PONG_MOVE_UP_ALT) {
        self.moveUp = isKeyDown;
    }
    else if ([keyEvent keyCode] == LED_PONG_MOVE_DOWN || [keyEvent keyCode] == LED_PONG_MOVE_DOWN_ALT) {
        self.moveDown = isKeyDown;
    }
}

#pragma mark - Update Frame

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    if (self.moveUp) {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(currentPosition.x, currentPosition.y + LED_PONG_PADDLE_SPEED);
    } else if (self.moveDown) {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(currentPosition.x, currentPosition.y - LED_PONG_PADDLE_SPEED);
    }

}

@end
