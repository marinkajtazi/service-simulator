//
//  ViewController.m
//  ServiceSimulator
//
//  Created by Marin Kajtazi on 14/10/2019.
//  Copyright © 2019 Marin Kajtazi. All rights reserved.
//

#import "ViewController.h"
#import "ServiceCommunicator.h"

@implementation ViewController
{
    ServiceCommunicator *_serviceCommunicator;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if(!_serviceCommunicator)
    {
        _serviceCommunicator = [[ServiceCommunicator alloc] init];
        [_serviceCommunicator setDelegate:self];
    }
}

// MARK: Actions
- (IBAction)startListeningButtonClicked:(NSButton *)sender
{
    [self->_serviceCommunicator startListening];
}

- (IBAction)closeSocketButtonClicked:(NSButton *)sender
{
    [self->_serviceCommunicator closeSocket];
}

- (IBAction)changeStreamingMessageButtonClicked:(NSButton *)sender {
    self->_serviceCommunicator.streamingMessage = self.streamingMessageTextView.textStorage.string;
    self.changeStreamingMessageButton.enabled = false;
}

// MARK: ServiceCommunicatorDelegate method
- (void)connectionStatusChanged:(ConnectionStatus)status
{
    switch (status)
    {
        case StatusDisconnected:
            self.startListeningButton.enabled = true;
            self.closeSocketButton.enabled = false;
            self.onlineStatusImage.image = [NSImage imageNamed:NSImageNameStatusUnavailable];
            break;
            
        case StatusListening:
            self.startListeningButton.enabled = false;
            self.closeSocketButton.enabled = true;
            self.onlineStatusImage.image = [NSImage imageNamed:NSImageNameStatusPartiallyAvailable];
            break;
            
        case StatusConnected:
            self.startListeningButton.enabled = false;
            self.closeSocketButton.enabled = true;
            self.onlineStatusImage.image = [NSImage imageNamed:NSImageNameStatusAvailable];
            break;
            
        default:
            break;
    }
}

// MARK: NSTextViewDelegate method
- (void)textDidChange:(NSNotification *)notification
{
    self.changeStreamingMessageButton.enabled = true;
}



@end
