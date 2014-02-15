//
//  LEDMacros.h
//  Pong
//
//  Created by Chris Ledet on 2/15/14.
//  Copyright (c) 2014 Chris Ledet. All rights reserved.
//

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
