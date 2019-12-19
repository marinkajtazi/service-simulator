//
//  ServiceCommunicator.h
//  ServiceSimulator
//
//  Created by Marin Kajtazi on 14/10/2019.
//  Copyright © 2019 Marin Kajtazi. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServiceCommunicatorDelegate;

typedef enum
{
    StatusDisconnected,
    StatusListening,
    StatusConnected,
}
ConnectionStatus;

NS_ASSUME_NONNULL_BEGIN

@interface ServiceCommunicator : NSObject

@property (nullable, weak) id<ServiceCommunicatorDelegate> delegate;
@property (nonatomic) ConnectionStatus connectionStatus;
@property (copy) NSString *streamingMessage;

- (void)startListening;
- (void)closeSocket;

@end


@protocol ServiceCommunicatorDelegate <NSObject>

- (void)connectionStatusChanged:(ConnectionStatus)status;

@end

NS_ASSUME_NONNULL_END
