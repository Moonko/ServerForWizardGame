//
//  MKServer.h
//  ServerForWizardGame
//
//  Created by Андрей Рычков on 10.04.14.
//  Copyright (c) 2014 Andrey Rychkov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import <sys/socket.h>
#import <sys/types.h>
#import <netinet/in.h>

@interface MKServer : NSObject

@property (nonatomic) int client1;
@property (nonatomic) int client2;
@property (nonatomic) int clients;
@property (nonatomic) int listener;
@property (nonatomic) BOOL shouldStop;
@property (nonatomic) struct sockaddr_in addr1;

@property (nonatomic) int firstClientSkill;
@property (nonatomic) int secondClientSkill;

@property (nonatomic, weak) SKLabelNode *label;

- (void)setUp:(SKLabelNode *)label;

- (void)stop;

@end
