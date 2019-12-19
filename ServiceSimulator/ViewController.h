//
//  ViewController.h
//  ServiceSimulator
//
//  Created by Marin Kajtazi on 14/10/2019.
//  Copyright © 2019 Marin Kajtazi. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ServiceCommunicator.h"

@interface ViewController : NSViewController<ServiceCommunicatorDelegate, NSTextViewDelegate>

@property (strong) IBOutlet NSImageView *onlineStatusImage;
@property (strong) IBOutlet NSButton *startListeningButton;
@property (strong) IBOutlet NSButton *closeSocketButton;
@property (strong) IBOutlet NSTextView *streamingMessageTextView;
@property (strong) IBOutlet NSButton *changeStreamingMessageButton;

- (IBAction)startListeningButtonClicked:(NSButton *)sender;
- (IBAction)closeSocketButtonClicked:(NSButton *)sender;
- (IBAction)changeStreamingMessageButtonClicked:(NSButton *)sender;

- (void)connectionStatusChanged:(ConnectionStatus)status;

@end

