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

- (id)initWithSize:(CGSize)size
{
    if (self == [super initWithSize:size])
    {
        _server = [[MKServer alloc] init];
        
        _label = [SKLabelNode labelNodeWithFontNamed:@"Chulkduster"];
        _label.text = @"Waiting for clients... 0/2";
        _label.fontSize = 50;
        _label.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMidY(self.frame));
        [self addChild:_label];
        
        NSThread *setUp = [[NSThread alloc] initWithTarget:_server
                                                  selector:@selector(setUp:)
                                                    object:_label];
        [setUp start];
    }
    
    return self;
}

@end
