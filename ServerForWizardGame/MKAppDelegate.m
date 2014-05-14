//
//  MKAppDelegate.m
//  ServerForWizardGame
//
//  Created by Андрей Рычков on 10.04.14.
//  Copyright (c) 2014 Andrey Rychkov. All rights reserved.
//

#import "MKAppDelegate.h"
#import "MKServerScene.h"
#import "MKServer.h"

@implementation MKAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    _server = [[MKServer alloc] init];
    /* Pick a size for the scene */
    SKScene *scene = [[MKServerScene alloc] initWithSize:CGSizeMake(1024, 768)
                                                  server:_server];

    /* Set the scale mode to scale to fit the window */
    scene.scaleMode = SKSceneScaleModeAspectFit;

    [self.skView presentScene:scene];

    self.skView.showsFPS = YES;
    self.skView.showsNodeCount = YES;
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [_server stop];
}

@end
