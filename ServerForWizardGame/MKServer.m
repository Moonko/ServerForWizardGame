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
    NSNumber *background = [NSNumber numberWithInt:arc4random() % 4 + 1];
    
    _label = label;
    _clients = 0;
    _shouldStop = NO;
    
    _listener = socket(AF_INET, SOCK_STREAM, 0);
    
    _addr1.sin_family = AF_INET;
    _addr1.sin_port = htons(3425);
    _addr1.sin_addr.s_addr = ntohl(INADDR_ANY);
    
    if (bind(_listener, (struct sockaddr *)&_addr1, sizeof(_addr1)) < 0)
    {
        perror("bind");
        exit(2);
    }
    
    listen(_listener, 1);
    
    NSThread *firstThread = [[NSThread alloc] initWithTarget:self
                                                    selector:@selector(f1:)
                                                      object:background];
    NSThread *secondThread = [[NSThread alloc] initWithTarget:self
                                                     selector:@selector(f2:)
                                                       object:background];
    NSThread *waitingThread = [[NSThread alloc] initWithTarget:self
                                                      selector:@selector(waiting)
                                                    object:nil];
    [waitingThread start];
    [firstThread start];
    [secondThread start];
}

- (void)f1:(NSNumber *)background
{
    int bg = background.intValue;
    while (!_shouldStop)
    {
        if (!_client1)
        {
            _client1 = accept(_listener, NULL, NULL);
            send(_client1, &bg, sizeof(int), 0);
            ++_clients;
            _label.text = [NSString stringWithFormat:@"Waiting for clients... %d/2", _clients];
        }
        recv(_client1, &_firstClientSkill, sizeof(int), 0);
        switch (_firstClientSkill)
        {
            case -1:
            {
                close(_client1);
                NSLog(@"Client 1 disconnected from the server");
                --_clients;
                _label.text = [NSString stringWithFormat:@"Waiting for clients... %d/2", _clients];
                _client1 = accept(_listener, NULL, NULL);
                send(_client1, &bg, sizeof(int), 0);
                ++_clients;
                _label.text = [NSString stringWithFormat:@"Waiting for clients... %d/2", _clients];
                break;
            }
            case -2:
            {
                send(_client1, &_secondClientSkill, sizeof(int), 0);
                _shouldStop = YES;
                [self stop];
                break;
            }
            case -3:
            {
                send(_client1, &_firstClientSkill, sizeof(int), 0);
                send(_client2, &_firstClientSkill, sizeof(int), 0);
                break;
            }
            case -4:
            {
                send(_client1, &_firstClientSkill, sizeof(int), 0);
                send(_client2, &_firstClientSkill, sizeof(int), 0);
                break;
            }
            case -5:
            {
                /*int win = -6;
                send(_client1, &_firstClientSkill, sizeof(int), 0);
                send(_client2, &win, sizeof(int), 0); */
                [self stop];
                [self setUp:_label];
                break;
            }
            case -6:
            {
                /*int lose = -5;
                send(_client1, &_firstClientSkill, sizeof(int), 0);
                send(_client2, &lose, sizeof(int), 0);*/
                [self stop];
                [self setUp:_label];
                break;
            }
            default:
            {
                int doubleSkill = _firstClientSkill * 2;
                send(_client2, &doubleSkill, sizeof(int), 0);
                send(_client1, &_firstClientSkill, sizeof(int), 0);
                break;
            }
        }
    }
}

- (void)f2:(NSNumber *)background;
{
    int bg = background.intValue;
    while (!_shouldStop)
    {
        if (!_client2)
        {
            _client2 = accept(_listener, NULL, NULL);
            send(_client2, &bg, sizeof(int), 0);
            ++_clients;
            _label.text = [NSString stringWithFormat:@"Waiting for clients... %d/2", _clients];
        }

        recv(_client2, &_secondClientSkill, sizeof(int), 0);
        switch (_secondClientSkill)
        {
            case -1:
            {
                close(_client2);
                NSLog(@"Client 2 disconnected from the server");
                --_clients;
                _label.text = [NSString stringWithFormat:@"Waiting for clients... %d/2", _clients];
                _client2 = accept(_listener, NULL, NULL);
                send(_client2, &bg, sizeof(int), 0);
                ++_clients;
                _label.text = [NSString stringWithFormat:@"Waiting for clients... %d/2", _clients];
                break;
            }
            case -2:
            {
                send(_client1, &_secondClientSkill, sizeof(int), 0);
                _shouldStop = YES;
                [self stop];
                break;
            }
            case -3:
            {
                send(_client1, &_secondClientSkill, sizeof(int), 0);
                send(_client2, &_secondClientSkill, sizeof(int), 0);
                break;
            }
            case -4:
            {
                send(_client1, &_secondClientSkill, sizeof(int), 0);
                send(_client2, &_secondClientSkill, sizeof(int), 0);
                break;
            }
            case -5:
            {
                /*int win = -6;
                send(_client2, &_secondClientSkill, sizeof(int), 0);
                send(_client1, &win, sizeof(int), 0); */
                [self stop];
                [self setUp:_label];
                break;
            }
            case -6:
            {
                /* int lose = -5;
                send(_client2, &_secondClientSkill, sizeof(int), 0);
                send(_client1, &lose, sizeof(int), 0); */
                [self stop];
                [self restart];
                break;
            }
            default:
            {
                int doubleSkill = _secondClientSkill * 2;
                send(_client1, &doubleSkill, sizeof(int), 0);
                send(_client2, &_secondClientSkill, sizeof(int), 0);
                break;
            }
        }

    }
}

- (void)stop
{
    _label.text = @"Disconnected";
    close(_client1);
    close(_client2);
    _client1 = 0;
    _client2 = 0;
}

- (void)waiting
{
    while (_clients != 2)
    {
        NSLog(@"Waiting, %d", _clients);
        // Waiting for clients;
    }
    
    NSThread *readyThread = [[NSThread alloc] initWithTarget:self
                                                    selector:@selector(sendReady)
                                                      object:nil];
    [readyThread start];
}

- (void)sendReady
{
    int ready = 5;
    send(_client1, &ready, sizeof(int), 0);
    send(_client2, &ready, sizeof(int), 0);
}

- (void)restart
{
    NSNumber *background = [NSNumber numberWithInt:arc4random() % 4 + 1];
    
    _clients = 0;
    _shouldStop = NO;
    
    NSThread *firstThread = [[NSThread alloc] initWithTarget:self
                                                    selector:@selector(f1:)
                                                      object:background];
    NSThread *secondThread = [[NSThread alloc] initWithTarget:self
                                                     selector:@selector(f2:)
                                                       object:background];
    NSThread *waitingThread = [[NSThread alloc] initWithTarget:self
                                                      selector:@selector(waiting)
                                                        object:nil];
    [waitingThread start];
    [firstThread start];
    [secondThread start];
}

@end
