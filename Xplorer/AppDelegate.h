//
//  AppDelegate.h
//  Xplorer
//
//  Created by Verónica Rocha on 17/05/17.
//  Copyright © 2017 something. All rights reserved.
//

#import "MPCHandler.h"
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) MPCHandler *mcManager;
@end

