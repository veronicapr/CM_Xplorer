//
//  ConnectionsViewController.h
//  Xplorer
//
//  Created by Verónica Rocha on 06/06/17.
//  Copyright © 2017 something. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ConnectionsViewController : UIViewController <MCBrowserViewControllerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
@property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;

- (IBAction)searchForDevices:(id)sender;
- (IBAction)toggleVisibility:(id)sender;
- (IBAction)disconnect:(id)sender;

@end
