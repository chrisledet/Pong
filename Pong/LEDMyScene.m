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

#define LED_PONG_BALL_SPEED     5.0f

static const uint32_t kLEDEdgeCategory   =  0x1 << 0;
static const uint32_t kLEDPaddleCategory =  0x1 << 1;
static const uint32_t kLEDBallCategory   =  0x1 << 2;

@interface LEDMyScene()

@property (nonatomic, strong) SKSpriteNode *playerPaddle;
@property (nonatomic, strong) SKSpriteNode *ball;

@property (nonatomic, assign) BOOL gameStarted;
@property (nonatomic, assign) BOOL moveUp;
@property (nonatomic, assign) BOOL moveDown;

@property (nonatomic, assign) BOOL bounceUp;
@property (nonatomic, assign) BOOL bounceLeft;

@property (nonatomic, assign) CGPoint previousLocation;
@property (nonatomic, assign) CGPoint currentLocation;

@property (nonatomic, assign) CGFloat ballVelocityX;
@property (nonatomic, assign) CGFloat ballVelocityY;

@end

@implementation LEDMyScene

- (id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {

        self.backgroundColor = [SKColor colorWithRed:0.20 green:0.20 blue:0.20 alpha:1.0];
        self.physicsWorld.contactDelegate = self;

        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsBody.categoryBitMask = kLEDEdgeCategory;
        self.physicsBody.friction = 0.0;

        self.playerPaddle = [SKSpriteNode spriteNodeWithColor:[NSColor whiteColor] size:LED_PONG_PADDLE_SIZE];
        self.playerPaddle.position = CGPointMake((CGRectGetMaxX(self.frame) - LED_PONG_PADDLE_SIZE.width/2) - LED_PONG_PADDING, CGRectGetMidX(self.frame));
        self.playerPaddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:LED_PONG_PADDLE_SIZE];
        self.playerPaddle.physicsBody.categoryBitMask = kLEDPaddleCategory;
        self.playerPaddle.physicsBody.contactTestBitMask = kLEDEdgeCategory;
        self.playerPaddle.physicsBody.allowsRotation = NO;
        self.playerPaddle.physicsBody.affectedByGravity = NO;
        self.playerPaddle.physicsBody.friction = 0.0;
        [self addChild:self.playerPaddle];

        self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"Ball"];
        self.ball.color = [SKColor whiteColor];
        self.ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:26.0f];
        self.ball.physicsBody.categoryBitMask = kLEDBallCategory;
        self.ball.physicsBody.contactTestBitMask = kLEDEdgeCategory | kLEDPaddleCategory;
        self.ball.physicsBody.friction = 0.0;
        [self addChild:self.ball];

        self.gameStarted = NO;
    }

    return self;
}

#pragma mark - OS X Event Handling

- (void)keyUp:(NSEvent *)keyEvent {
    [self handleKeyEvent:keyEvent keyDown:NO];
}

- (void)keyDown:(NSEvent*)keyEvent {
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

- (void)mouseDown:(NSEvent*)theEvent {
    NSLog(@"Mouse Restart Turned On!");
    self.gameStarted = NO;
}

- (void)startGame {
    self.gameStarted = YES;

    self.ballVelocityX = CGRectGetMidX(self.frame);
    self.ballVelocityY = CGRectGetMidY(self.frame);

    self.bounceUp   = (arc4random_uniform(2) + 1) % 2 == 0;
    self.bounceLeft = (arc4random_uniform(2) + 1) % 2 == 0;
}

#pragma mark - Update Frame

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    if (!self.gameStarted)
        [self startGame];

    if (self.moveUp) {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(currentPosition.x, currentPosition.y + LED_PONG_PADDLE_SPEED);
    } else if (self.moveDown) {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(currentPosition.x, currentPosition.y - LED_PONG_PADDLE_SPEED);
    }

    NSLog(@"Moving Ball to (%0.2f, %0.2f)", self.ballVelocityX, self.ballVelocityY);
    self.ball.position = CGPointMake(self.ballVelocityX, self.ballVelocityY);

    // Update position
    if (self.ballVelocityY >= self.frame.size.height - self.ball.size.height/2) {
        self.bounceUp = NO;
    } else if (self.ballVelocityY <= self.ball.size.height/2) {
        self.bounceUp = YES;
    }

    if (self.ballVelocityX >= self.frame.size.width - self.ball.size.width/2) {
        self.bounceLeft = YES;
    } else if (self.ballVelocityX < self.ball.size.width/2) {
        self.bounceLeft = NO;
    }


    if (self.bounceUp) {
        self.ballVelocityY += LED_PONG_BALL_SPEED;
    } else {
        self.ballVelocityY -= LED_PONG_BALL_SPEED;
    }

    if (self.bounceLeft) {
        self.ballVelocityX -= LED_PONG_BALL_SPEED;
    } else {
        self.ballVelocityX += LED_PONG_BALL_SPEED;
    }
}

- (void)didBeginContact:(SKPhysicsContact*)contact {

    BOOL ballTouched = (contact.bodyA.categoryBitMask == kLEDBallCategory || contact.bodyB.categoryBitMask == kLEDBallCategory);
    BOOL paddleTouched = (contact.bodyA.categoryBitMask == kLEDPaddleCategory || contact.bodyB.categoryBitMask == kLEDPaddleCategory);

    if (ballTouched && paddleTouched) {
        CGPoint p = CGPointMake(self.currentLocation.x, -self.currentLocation.y);
    }
}

@end
