//
//  LEDPaddle.m
//  Pong
//
//  Created by Chris Ledet on 2/15/14.
//  Copyright (c) 2014 Chris Ledet. All rights reserved.
//

#import "LEDPaddle.h"

@implementation LEDPaddle

- (instancetype)initWithColor:(SKColor *)color size:(CGSize)size {
    self = [super initWithColor:color size:size];

    if (self)
        [self setUp];

    return self;
}

- (void)setUp {

    self.name = @"Paddle";

    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:LED_PONG_PADDLE_SIZE];
    self.physicsBody.categoryBitMask = kLEDPaddleCategory;
    self.physicsBody.contactTestBitMask = kLEDEdgeCategory | kLEDBallCategory;
    self.physicsBody.allowsRotation = NO;
    self.physicsBody.friction = 0.0;
    self.physicsBody.mass = 0.0;
}

@end
