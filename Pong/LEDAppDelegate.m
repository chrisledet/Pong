//
//  LEDAppDelegate.m
//  Pong
//
//  Created by Chris Ledet on 2/11/14.
//  Copyright (c) 2014 Chris Ledet. All rights reserved.
//

#import "LEDAppDelegate.h"
#import "LEDMyScene.h"

@interface LEDAppDelegate()

@property (nonatomic, strong) LEDMyScene *currentScene;

@end

@implementation LEDAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    /* Pick a size for the scene */
    self.currentScene = [LEDMyScene sceneWithSize:CGSizeMake(1024, 768)];

    /* Set the scale mode to scale to fit the window */
    self.currentScene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:self.currentScene];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationWillResignActive:(NSNotification*)notification {
    [self.currentScene pauseGame];
}

- (void)applicationWillBecomeActive:(NSNotification*)notification {
    [self.currentScene unpauseGame];
}

@end
