//
//  MKServer.m
//  ServerForWizardGame
//
//  Created by Андрей Рычков on 10.04.14.
//  Copyright (c) 2014 Andrey Rychkov. All rights reserved.
//

#import "MKServer.h"

@implementation MKServer

- (void)setUp:(SKLabelNode *)label;
{
    struct sockaddr_in addr1;
    
    _listener = socket(AF_INET, SOCK_STREAM, 0);
    
    addr1.sin_family = AF_INET;
    addr1.sin_port = htons(3425);
    addr1.sin_addr.s_addr = ntohl(INADDR_ANY);
    
    if (bind(_listener, (struct sockaddr *)&addr1, sizeof(addr1)) < 0)
    {
        perror("bind");
        exit(2);
    }
    
    listen(_listener, 1);
    
    _client1 = accept(_listener, NULL, NULL);
    
    label.text = @"Waiting for clients... 1/2";
    
    _client2 = accept(_listener, NULL, NULL);
    
    label.text = @"Connection established";
    
    int background = arc4random() % 4 + 1;
    
    send(_client1, &background, sizeof(int), 0);
    send(_client2, &background, sizeof(int), 0);
    
    _isConnected = YES;
    
    NSThread *firstThread = [[NSThread alloc] initWithTarget:self
                                                    selector:@selector(f1)
                                                      object:nil];
    NSThread *secondThread = [[NSThread alloc] initWithTarget:self
                                                     selector:@selector(f2)
                                                       object:nil];
    [firstThread start];
    [secondThread start];
    
    while (!_shouldStop)
    {
        // Do nothing
    }
    [self stop:label];
}

- (void)f1
{
    while (!_shouldStop)
    {
        recv(_client1, &_firstClientSkill, sizeof(int), 0);
        if (_firstClientSkill != 100502)
        {
            send(_client2, &_firstClientSkill, sizeof(int), 0);
        } else
        {
            _shouldStop = YES;
        }
    }
}

- (void)f2
{
    while (!_shouldStop)
    {
        recv(_client2, &_secondClientSkill, sizeof(int), 0);
        if (_secondClientSkill != 100502)
        {
            send(_client1, &_secondClientSkill, sizeof(int), 0);
        } else
        {
            _shouldStop = YES;
        }
    }
}

- (void)stop:(SKLabelNode *)label
{
    label.text = @"Disconnected";
    close(_client1);
    close(_client2);
}

@end
