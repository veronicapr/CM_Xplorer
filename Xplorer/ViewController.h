//
//  ViewController.h
//  Xplorer
//
//  Created by Miguel Ferreira on 16/05/2017.
//  Copyright © 2017 Miguel Ferreira. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController <AVCaptureMetadataOutputObjectsDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewPreview;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *bbitemStart;
@property (weak, nonatomic) IBOutlet UILabel *label_landmark_ico;

- (IBAction)startStopReading:(id)sender;

@end

