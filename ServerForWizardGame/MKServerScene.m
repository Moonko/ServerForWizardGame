//
//  MKServerScene.m
//  ServerForWizardGame
//
//  Created by Андрей Рычков on 10.04.14.
//  Copyright (c) 2014 Andrey Rychkov. All rights reserved.
//

#import "MKServerScene.h"
#import "MKServer.h"

@implementation MKServerScene

- (id)initWithSize:(CGSize)size server:(MKServer *)server
{
    if (self == [super initWithSize:size])
    {
        _server = server;
        
        _label = [SKLabelNode labelNodeWithFontNamed:@"Chulkduster"];
        _label.fontSize = 50;
        _label.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
        _label.text = [NSString stringWithFormat:@"Waiting for clients... %d/2", _server.clients];
        [self addChild:_label];
        
        NSThread *setUp = [[NSThread alloc] initWithTarget:_server
                                                  selector:@selector(setUp:)
                                                    object:_label];
        [setUp start];
    }
    
    return self;
}

@end
