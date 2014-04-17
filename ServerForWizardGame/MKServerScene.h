//
//  MKServerScene.h
//  ServerForWizardGame
//
//  Created by Андрей Рычков on 10.04.14.
//  Copyright (c) 2014 Andrey Rychkov. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MKServer;

@interface MKServerScene : SKScene

@property (nonatomic, strong) MKServer *server;

@property (nonatomic) SKLabelNode *label;

@end
