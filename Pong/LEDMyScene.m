//
//  LEDMyScene.m
//  Pong
//
//  Created by Chris Ledet on 2/11/14.
//  Copyright (c) 2014 Chris Ledet. All rights reserved.
//

#import "LEDMyScene.h"

@interface LEDMyScene()

@property (nonatomic, strong) SKSpriteNode *cpuPaddle;
@property (nonatomic, strong) SKSpriteNode *playerPaddle;
@property (nonatomic, strong) SKSpriteNode *ball;

@property (nonatomic, strong) SKLabelNode *playerScoreLabel;
@property (nonatomic, strong) SKLabelNode *cpuScoreLabel;
@property (nonatomic, strong) SKLabelNode *pauseLabel;

@property (nonatomic, strong) SKAction *fadeOutAction;
@property (nonatomic, strong) SKAction *fadeInAction;

@property (nonatomic, assign) BOOL gamePaused;
@property (nonatomic, assign) BOOL gameStarted;
@property (nonatomic, assign) BOOL moveUp;
@property (nonatomic, assign) BOOL moveDown;
@property (nonatomic, assign) BOOL bounceUp;
@property (nonatomic, assign) BOOL bounceLeft;

@property (nonatomic, assign) CGPoint previousLocation;
@property (nonatomic, assign) CGPoint currentLocation;

@property (nonatomic, assign) CGFloat ballVelocityX;
@property (nonatomic, assign) CGFloat ballVelocityY;
@property (nonatomic, assign) CGFloat cpuPaddleVelocityY;
@property (nonatomic, assign) CGFloat initialPlayerPositionX;
@property (nonatomic, assign) CGFloat initialCpuPositionX;
@property (nonatomic, assign) CGFloat ballVelocityModifier;

@property (nonatomic, assign) NSUInteger playerScore;
@property (nonatomic, assign) NSUInteger cpuScore;
@property (nonatomic, assign) NSUInteger hitCounter;

@end

@implementation LEDMyScene

#pragma mark - Initializers

- (id)initWithSize:(CGSize)size {

    if (self = [super initWithSize:size]) {

        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
        self.physicsWorld.contactDelegate = self;

        self.fadeOutAction = [SKAction fadeOutWithDuration:0.75f];
        self.fadeInAction  = [SKAction fadeInWithDuration:0.75f];

        self.playerScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        self.playerScoreLabel.fontSize = 45.0f;
        self.playerScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) + 100, CGRectGetMaxY(self.frame) - 85);
        [self addChild:self.playerScoreLabel];

        self.cpuScoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
        self.cpuScoreLabel.fontSize = 45.0f;
        self.cpuScoreLabel.position = CGPointMake(CGRectGetMidX(self.frame) - 100, CGRectGetMaxY(self.frame) - 85);
        [self addChild:self.cpuScoreLabel];

        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.gravity = CGVectorMake(0,0);
        self.physicsBody.categoryBitMask = kLEDEdgeCategory;
        self.physicsBody.friction = 0.0;

        self.initialPlayerPositionX = (CGRectGetMaxX(self.frame) - LED_PONG_PADDLE_SIZE.width/2) - LED_PONG_PADDING;
        self.playerPaddle = [[LEDPaddle alloc] initWithColor:[SKColor whiteColor] size:LED_PONG_PADDLE_SIZE];
        [self addChild:self.playerPaddle];

        self.initialCpuPositionX = (CGRectGetMinX(self.frame) + LED_PONG_PADDLE_SIZE.width/2) + LED_PONG_PADDING;
        self.cpuPaddle = [[LEDPaddle alloc] initWithColor:[SKColor whiteColor] size:LED_PONG_PADDLE_SIZE];
        [self addChild:self.cpuPaddle];

        self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"Ball"];
        self.ball.color = [SKColor whiteColor];
        self.ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:26.0f];
        self.ball.physicsBody.categoryBitMask = kLEDBallCategory;
        self.ball.physicsBody.contactTestBitMask = kLEDEdgeCategory | kLEDPaddleCategory;
        self.ball.physicsBody.friction = 0.0;
        self.ball.physicsBody.mass = 0.0;
        self.ball.physicsBody.velocity = CGVectorMake(0, 0);
        [self addChild:self.ball];

        self.pauseLabel = [[SKLabelNode alloc] initWithFontNamed:@"Helvetica"];
        self.pauseLabel.fontSize = 70.0f;
        self.pauseLabel.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        self.pauseLabel.text = nil;
        [self addChild:self.pauseLabel];

        self.gameStarted = NO;
        self.gamePaused = NO;
    }

    return self;
}

#pragma mark - OS X Event Handling

- (void)keyUp:(NSEvent *)keyEvent {
    [self handleKeyEvent:keyEvent keyDown:NO];
}

- (void)keyDown:(NSEvent*)keyEvent {

    if ([keyEvent keyCode] == LED_PONG_MOVE_SPACEBAR) {
        [self togglePause];
    }

    [self handleKeyEvent:keyEvent keyDown:YES];
}

- (void)handleKeyEvent:(NSEvent*)keyEvent keyDown:(BOOL)isKeyDown {

    if ([keyEvent keyCode] == LED_PONG_MOVE_UP || [keyEvent keyCode] == LED_PONG_MOVE_UP_ALT) {
        self.moveUp = isKeyDown;
    } else if ([keyEvent keyCode] == LED_PONG_MOVE_DOWN || [keyEvent keyCode] == LED_PONG_MOVE_DOWN_ALT) {
        self.moveDown = isKeyDown;
    }
}

#if DEBUG
- (void)mouseDown:(NSEvent*)theEvent {
    NSLog(@"Mouse Restart Turned On!");
    self.gameStarted = NO;
}
#endif

#pragma mark - Game Events

/// Starts game, resets scores, etc
- (void)startGame {
    self.gameStarted = YES;

    self.playerScore = 0;
    self.cpuScore = 0;
    self.hitCounter = 0;

    self.ballVelocityModifier = tanf([self randomAngle]);

    self.playerPaddle.position = CGPointMake(self.initialPlayerPositionX, CGRectGetMidY(self.frame));
    self.cpuPaddle.position    = CGPointMake(self.initialCpuPositionX, CGRectGetMidY(self.frame));

    [self resetPositions];
}

/// Starts the ball from mid and moves in a random direction
- (void)resetPositions {
    self.ballVelocityX = CGRectGetMidX(self.frame);
    self.ballVelocityY = CGRectGetMidY(self.frame);

    self.bounceUp   = (arc4random_uniform(2) + 1) % 2 == 0;
    self.bounceLeft = (arc4random_uniform(2) + 1) % 2 == 0;

    self.hitCounter = 0;
}

- (void)pauseGame {
    self.gamePaused = YES;

    if (!self.pauseLabel.text) {
        self.pauseLabel.text = @"Paused";
    }

    [self.pauseLabel runAction:self.fadeInAction];
}

- (void)unpauseGame {
    self.gamePaused = NO;
    [self.pauseLabel runAction:self.fadeOutAction];
}

- (void)togglePause {
    if (self.gamePaused)
        [self unpauseGame];
    else
        [self pauseGame];
}

#pragma mark - Utilities

/// Return a random angle in radians
- (CGFloat)randomAngle {
    CGFloat angleInDegrees = 45 - (arc4random_uniform(35) + 1);
    return angleInDegrees * M_PI / 180;
}

#pragma mark - Update Frame

- (void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */

    if (!self.gameStarted)
        [self startGame];

    if (self.gamePaused)
        return;

    // NOTICE: Just reset paddle's position.x when it collides with ball
    self.playerPaddle.position = CGPointMake(self.initialPlayerPositionX, self.playerPaddle.position.y);
    self.cpuPaddle.position    = CGPointMake(self.initialCpuPositionX, self.cpuPaddle.position.y);

    float speedBoost = (self.hitCounter * 0.20);

    // Move Paddle
    if (self.moveUp) {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(currentPosition.x, currentPosition.y + LED_PONG_PADDLE_SPEED);
    } else if (self.moveDown) {
        CGPoint currentPosition = self.playerPaddle.position;
        self.playerPaddle.position = CGPointMake(currentPosition.x, currentPosition.y - LED_PONG_PADDLE_SPEED);
    }

    // Move CPU Paddle
    self.cpuPaddle.position = CGPointMake(self.cpuPaddle.position.x, self.ballVelocityY * LED_PONG_CPU_THROTTLE + speedBoost);

    // Ball's next movement when it hits top or bottom
    if (self.ballVelocityY >= self.frame.size.height - self.ball.size.height/2) {
        self.bounceUp = NO;
    } else if (self.ballVelocityY <= self.ball.size.height/2) {
        self.bounceUp = YES;
    }

    // When ball touches the sides
    if (self.ballVelocityX >= self.frame.size.width + self.ball.size.width/2) {
        self.cpuScore++;
        [self resetPositions];
    } else if (self.ballVelocityX < self.ball.size.width/2) {
        self.playerScore++;
        [self resetPositions];
    }

    // Calculate the speed and angle of the ball's direction
    float currentBallVelocity = (LED_PONG_BALL_SPEED * self.ballVelocityModifier) + speedBoost;
    float speedDifference = (LED_PONG_BALL_SPEED - currentBallVelocity) + speedBoost;

    if (self.bounceUp) {
        self.ballVelocityY += currentBallVelocity;
    } else {
        self.ballVelocityY -= currentBallVelocity;
    }

    if (self.bounceLeft) {
        self.ballVelocityX -= (LED_PONG_BALL_SPEED + speedDifference);
    } else {
        self.ballVelocityX += (LED_PONG_BALL_SPEED + speedDifference);
    }

    // Move Ball
    self.ball.position = CGPointMake(self.ballVelocityX, self.ballVelocityY);
}

#pragma mark - SKPhysicsContactDelegate Methods

- (void)didBeginContact:(SKPhysicsContact*)contact {

    BOOL ballTouched = (contact.bodyA.categoryBitMask == kLEDBallCategory || contact.bodyB.categoryBitMask == kLEDBallCategory);
    BOOL paddleTouched = (contact.bodyA.categoryBitMask == kLEDPaddleCategory || contact.bodyB.categoryBitMask == kLEDPaddleCategory);

    if (ballTouched && paddleTouched) {

        ++self.hitCounter;

        // Apply some force
        if (self.moveUp) {
            self.bounceUp = YES;
        } else if (self.moveDown) {
            self.bounceUp = NO;
        }

        self.bounceLeft = !self.bounceLeft;
        self.ballVelocityModifier = tanf([self randomAngle]);
    }
}

#pragma mark - Properties

- (void)setPlayerScore:(NSUInteger)playerScore {
    _playerScore = playerScore;
    self.playerScoreLabel.text = [NSString stringWithFormat:@"%lu", _playerScore];
}

- (void)setCpuScore:(NSUInteger)cpuScore {
    _cpuScore = cpuScore;
    self.cpuScoreLabel.text = [NSString stringWithFormat:@"%lu", _cpuScore];
}

@end
