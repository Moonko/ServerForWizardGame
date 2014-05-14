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
    while (1)
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
            case 0:
            {
                break;
            }
            default:
                send(_client2, &_firstClientSkill, sizeof(int), 0);
                break;
        }
    }
}

- (void)f2:(NSNumber *)background;
{
    int bg = background.intValue;
    while (1)
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
                [self stop];
                break;
            }
            default:
                send(_client1, &_secondClientSkill, sizeof(int), 0);
                break;
        }

    }
}

- (void)stop
{
    _label.text = @"Disconnected";
    close(_client1);
    close(_client2);
}

- (void)waiting
{
    while (_clients != 2)
    {
        NSLog(@"%d", _clients);
        // Waiting for clients;
    }
    sleep(0.5);
    int ready = 5;
    send(_client1, &ready, sizeof(int), 0);
    send(_client2, &ready, sizeof(int), 0);
}

@end
