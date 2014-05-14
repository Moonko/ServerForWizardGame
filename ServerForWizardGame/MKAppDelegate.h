//
//  MKAppDelegate.h
//  ServerForWizardGame
//

//  Copyright (c) 2014 Andrey Rychkov. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <SpriteKit/SpriteKit.h>

@class MKServer;

@interface MKAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet SKView *skView;

@property (nonatomic) MKServer *server;

@end
