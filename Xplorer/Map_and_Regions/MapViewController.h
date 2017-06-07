//
//  MapViewController.h
//  Xplorer
//
//  Created by Verónica Rocha on 18/05/17.
//  Copyright © 2017 something. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController : UIViewController <CLLocationManagerDelegate>

// ====================================================================================== //
// Controler variables
// ====================================================================================== //
@property (strong, nonatomic) CLLocationManager *location_manager;
@property (nonatomic) CLLocationCoordinate2D user_location;

// ====================================================================================== //
// UI Elements
// ====================================================================================== //
@property (weak, nonatomic) IBOutlet MKMapView *objMapView;
@property (weak, nonatomic) IBOutlet UIButton *btnStandard;
@property (weak, nonatomic) IBOutlet UIButton *btnSatellite;
@property (weak, nonatomic) IBOutlet UIButton *btnHybrid;

@end
	
