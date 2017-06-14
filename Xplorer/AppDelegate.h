//
//  AppDelegate.h
//  Xplorer
//
//  Created by Verónica Rocha on 17/05/17.
//  Copyright © 2017 something. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPCHandler.h"
#import "DBManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MPCHandler *mcManager;
@property (strong, nonatomic) DBManager *database_manager;

@end
