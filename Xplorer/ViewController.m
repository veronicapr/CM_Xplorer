//
//  ViewController.m
//  Xplorer
//
//  Created by Miguel Ferreira on 16/05/2017.
//  Copyright © 2017 Miguel Ferreira. All rights reserved.
//

#import "ViewController.h"
#import "MapRegion.h"
#import <AVFoundation/AVFoundation.h>


@interface ViewController ()
@property (nonatomic) BOOL isReading;

@property (nonatomic, strong) CLLocationManager *location_manager;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *videoPreviewLayer;

-(BOOL)startReading;
-(void)stopReading;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [super viewDidLoad];
    
    _isReading = NO;
    _captureSession = nil;
    
    self.location_manager = [[CLLocationManager alloc] init];
    self.location_manager.delegate = self;
    self.location_manager.desiredAccuracy = kCLLocationAccuracyBest;
    
    NSString *regionID = @"Test_Region";
    NSString *regionName = @"Residencia";
    MapRegion *region = [[MapRegion alloc] initRegionWithIdentifier:regionID Name:regionName LatitudeInDegrees:40.641825 LongitudeInDegrees:-8.651025 RadiusInMeters:100.0];
    
    [region addRegionToLocationManager:self.location_manager];
    [_label_landmark_ico setText:@"Region Added"];
    [region requestRegionState:self.location_manager];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Region Detection
-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region{
    switch (state) {
        case CLRegionStateInside:
            [_label_landmark_ico setText:@"Inside"];
            break;
        case CLRegionStateOutside:
            [_label_landmark_ico setText:@"Outside"];
            break;
        default:
            [_label_landmark_ico setText:@"Unkown"];
            break;
    }
}

// QR Code
- (IBAction)startStopReading:(id)sender {
    if (!_isReading) {
        if ([self startReading]) {
            [_bbitemStart setTitle:@"Stop"];
            [_lblStatus setText:@"Scanning for QR Code..."];
        }
    }
    else{
        [self stopReading];
        [_bbitemStart setTitle:@"Start!"];
    }
    
    _isReading = !_isReading;
}


- (BOOL)startReading {
    NSError *error;
    
    AVCaptureDevice *captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:&error];
    
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
        return NO;
    }
    
    _captureSession = [[AVCaptureSession alloc] init];
    [_captureSession addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [_captureSession addOutput:captureMetadataOutput];
    
    dispatch_queue_t dispatchQueue;
    dispatchQueue = dispatch_queue_create("myQueue", NULL);
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatchQueue];
    [captureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    
    _videoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    [_videoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [_videoPreviewLayer setFrame:_viewPreview.layer.bounds];
    [_viewPreview.layer addSublayer:_videoPreviewLayer];
    
    [_captureSession startRunning];
    
    return YES;
}

-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects != nil && [metadataObjects count] > 0) {
        AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
        if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode]) {
            [_lblStatus performSelectorOnMainThread:@selector(setText:) withObject:[metadataObj stringValue] waitUntilDone:NO];
            
            [self performSelectorOnMainThread:@selector(stopReading) withObject:nil waitUntilDone:NO];
            [_bbitemStart performSelectorOnMainThread:@selector(setTitle:) withObject:@"Start!" waitUntilDone:NO];
            _isReading = NO;
        }
    }
}

-(void)stopReading{
    [_captureSession stopRunning];
    _captureSession = nil;
    
    [_videoPreviewLayer removeFromSuperlayer];
}

@end
