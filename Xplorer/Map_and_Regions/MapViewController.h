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

@interface MapViewController : UIViewController <CLLocationManagerDelegate, MKMapViewDelegate>

// ====================================================================================== //
// Controler variablesS
// ====================================================================================== //
@property (strong, nonatomic) CLLocationManager *location_manager;
@property (nonatomic) CLLocationCoordinate2D user_location;
@property (nonatomic) CLLocationCoordinate2D loaded_regions_center;
@property (nonatomic) int found_landmarks;
@property (nonatomic) NSUInteger region_landmarks;

// ====================================================================================== //
// UI Elements
// ====================================================================================== //
@property (weak, nonatomic) IBOutlet MKMapView *objMapView;
@property (weak, nonatomic) IBOutlet UIButton *btnStandard;
@property (weak, nonatomic) IBOutlet UIButton *btnSatellite;
@property (weak, nonatomic) IBOutlet UIButton *btnHybrid;
@property (weak, nonatomic) IBOutlet UILabel *label_Obelisk_Counter;

// ====================================================================================== //
// CLLocationManagerDelegate notifications handlers
// ====================================================================================== //
/* Tells the delegate that new location data is available */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations;
/* Tells the delegate that the location manager was unable to retrieve a location value */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;
/* Tells the delegate that the user entered the specified region */
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region;
/* Tells the delegate that the user left the specified region */
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region;
/* Tells the delegate about the state of the specified region */
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region;
/* Tells the delegate that a region monitoring error occurred */
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error;
/* Tells the delegate that a new region is being monitored */
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region;
@end
	
