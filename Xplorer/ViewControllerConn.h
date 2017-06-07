//
//  ViewControllerConn.h
//  Xplorer
//
//  Created by Verónica Rocha on 07/06/17.
//  Copyright © 2017 something. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewControllerConn : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UISwitch *swVisible;
@property (weak, nonatomic) IBOutlet UITableView *tblConnectedDevices;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;

- (IBAction)searchForDevices:(id)sender;
- (IBAction)toggleVisibility:(id)sender;
- (IBAction)disconnect:(id)sender;

@end
