//
//  ServiceCommunicator.m
//  ServiceSimulator
//
//  Created by Marin Kajtazi on 14/10/2019.
//  Copyright © 2019 Marin Kajtazi. All rights reserved.
//

#import "ServiceCommunicator.h"
#import <netinet/in.h>

#define PORT 8004
#define BUFFER_SIZE 1000

const char delimiter = '\r';

@implementation ServiceCommunicator
{
    int serverfd;
    int clientfd;
    struct sockaddr_in serveraddr;
    struct sockaddr_in clientaddr;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _connectionStatus = StatusDisconnected;
        
        bzero(&self->serveraddr, sizeof(self->serveraddr));
        self->serveraddr.sin_family = AF_INET;
        self->serveraddr.sin_addr.s_addr = INADDR_ANY;
        self->serveraddr.sin_port = htons(PORT);
    }
    return self;
}

- (void)startListening
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
        if(self.connectionStatus != StatusDisconnected) return;
        
        self->serverfd = socket(AF_INET, SOCK_STREAM, 0);
        if(self->serverfd < 0)
        {
            [self closeSocket];
            return;
        }
        
        if(bind(self->serverfd, (struct sockaddr*)&self->serveraddr, sizeof(self->serveraddr)) < 0)
        {
            [self closeSocket];
            return;
        }
        
        self.connectionStatus = StatusListening;
        
        if(listen(self->serverfd, 1) < 0)
        {
            [self closeSocket];
            return;
        }
        
        int len = sizeof(self->clientaddr);
        self->clientfd = accept(self->serverfd, (struct sockaddr*)&self->clientaddr, (socklen_t*)&len);
        if(self->clientfd < 0)
        {
            [self closeSocket];
            return;
        }
        
        self.connectionStatus = StatusConnected;
        
        [self startStreaming];
    });
}

- (void)closeSocket
{
    close(serverfd);
    close(clientfd);
    self.connectionStatus = StatusDisconnected;
}

- (void)startStreaming
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void)
    {
        ssize_t result;
        char buffer[BUFFER_SIZE];
        
        while(true)
        {
            @autoreleasepool
            {
                result = recv(self->clientfd, buffer, BUFFER_SIZE, 0);
                if(result <= 0)
                {
                    break;
                }
                
                // If not all data received
                if(buffer[result - 1] != delimiter)
                {
                    continue;
                }
                
                @synchronized (self.streamingMessage) {
                    result = send(self->clientfd, [self.streamingMessage UTF8String], self.streamingMessage.length, 0);
                }
                
                if(result < 0)
                {
                    break;
                }
            }
        }
        
        [self closeSocket];
    });
}

- (void)setConnectionStatus:(ConnectionStatus)connectionStatus
{
    _connectionStatus = connectionStatus;
    dispatch_async(dispatch_get_main_queue(), ^(void)
    {
        [self.delegate connectionStatusChanged:connectionStatus];
    });
}

@end
