//
//  ViewController.h
//  Xplorer
//
//  Created by Miguel Ferreira on 16/05/2017.
//  Copyright © 2017 Miguel Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;
- (IBAction)startStopReading:(id)sender;
@end

