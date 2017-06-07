//
//  MPCHandler.h
//  Xplorer
//
//  Created by Verónica Rocha on 07/06/17.
//  Copyright © 2017 something. All rights reserved.
//

#import "ConnectionsViewController.h"

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface MPCHandler : NSObject <MCSessionDelegate>

@property (nonatomic, strong) MCPeerID *peerID;     //represents the device
@property (nonatomic, strong) MCSession *session;   //session of the current peer
@property (nonatomic, strong) MCBrowserViewController *browser; //default UI provided by apple
@property (nonatomic, strong) MCAdvertiserAssistant *advertiser;    //used to advertise peer


-(void)setupPeerAndSessionWithDisplayName:(NSString *)displayName;
-(void)setupMCBrowser;
-(void)advertiseSelf:(BOOL)shouldAdvertise;


@end
