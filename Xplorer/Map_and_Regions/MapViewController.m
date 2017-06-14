//
//  MapViewController.m
//  Xplorer
//
//  Created by Verónica Rocha on 18/05/17.
//  Copyright © 2017 something. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"

@interface MapViewController ()

@end

#define UPDATE_FILTER_METERS ((double) 20.0)
#define LOAD_RADIUS_KM ((double) 2.5)

@implementation MapViewController

// Controler variables
@synthesize location_manager = _location_manager;
@synthesize user_location = _user_location;
@synthesize loaded_regions_center = _loaded_regions_center;

// UI Elements
@synthesize objMapView = _objMapView;
@synthesize btnHybrid = _btnHybrid;
@synthesize btnSatellite = _btnSatellite;
@synthesize btnStandard = _btnStandard;

// ====================================================================================== //
// Map Controller calls
// ====================================================================================== //
/* Called after the controller's view is loaded into memory */
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLocationManager];
    CLRegion *region = [self createRegionWithName:@"Segunda ponte do forum" Latitude:40.641476 Longitude:-8.651161 andRadius:100.0];
    [_location_manager startMonitoringForRegion:region];
}
/* Notifies the view controller that its view was added to a view hierarchy  */
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [_location_manager startUpdatingLocation];
}
/* Notifies the view controller that its view was removed from a view hierarchy */
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
    [_location_manager stopUpdatingLocation];
}
/* Memory warning handler */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// ====================================================================================== //
// Location Manager Auxiliar Methods
// ====================================================================================== //
/* Starts location manager */
- (void) startLocationManager
{
    _location_manager = [[CLLocationManager alloc] init];
    _location_manager.delegate = self;
    _location_manager.distanceFilter = UPDATE_FILTER_METERS;
    _location_manager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([_location_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_location_manager requestWhenInUseAuthorization];
    }
    if ([_location_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_location_manager requestAlwaysAuthorization];
    }
    
    [_location_manager startUpdatingLocation];
}
/* Zooms map at user location */
- (void)zoomAtUserLocation
{
    MKCoordinateSpan objCoorSpan = {.latitudeDelta = 0.005, .longitudeDelta = 0.005};
    MKCoordinateRegion objMapRegion = {_user_location, objCoorSpan};
    [_objMapView setRegion:objMapRegion];
}
/* Create region with the given coodinates and radius */
- (CLCircularRegion *)createRegionWithName:(NSString *)name Latitude:(CLLocationDegrees)latitude Longitude:(CLLocationDegrees)longitude andRadius:(int) radius
{
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:centerCoordinate radius:radius identifier:name];
    return region;
}

// ====================================================================================== //
// CLLocationManagerDelegate notifications handlers
// ====================================================================================== //
/* Tells the delegate that new location data is available */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    _user_location = locations.firstObject.coordinate;
    [self zoomAtUserLocation];
}
/* Tells the delegate that the location manager was unable to retrieve a location value */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error.localizedDescription);
    if (error.code != 0) {
        NSString *message = [NSString stringWithFormat:@"%@", error.localizedDescription];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Location update alert" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/* Tells the delegate that the user entered the specified region */
- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
}
/* Tells the delegate that the user left the specified region */
- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
}
/* Tells the delegate about the state of the specified region */
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            NSLog(@"Region state inside");
            _found_landmarks = _found_landmarks + 1;
            
            break;
        case CLRegionStateOutside:
            NSLog(@"Region state outside");
            break;
        case CLRegionStateUnknown:
            NSLog(@"Region state unknown");
            break;
        default:
            NSLog(@"It shouldn't happen");
            break;
    }
}
/* Tells the delegate that a region monitoring error occurred */
- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"monitoringDidFailForRegion %@ %@",region, error.localizedDescription);
    for (CLRegion *monitoredRegion in manager.monitoredRegions) {
        NSLog(@"monitoredRegion: %@", monitoredRegion);
    }
    if ([manager.monitoredRegions containsObject:region]) {
        NSString *message = [NSString stringWithFormat:@"%@ %@", region, error.localizedDescription];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Region monitoring alert" message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}
/* Tells the delegate that a new region is being monitored */
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{
    [_location_manager requestStateForRegion:region];
}

// ====================================================================================== //
// Button functions
// ====================================================================================== //
/* Generates a new text for the info labels */
- (void)updateLabelInfo
{
    NSString *landmark_info = [NSString stringWithFormat:@"%d / %lu", _found_landmarks, _region_landmarks];
    _label_Obelisk_Counter.text = landmark_info;
}

// ====================================================================================== //
// Button functions
// ====================================================================================== //
/* Changes map to show only roads */
- (IBAction)btnStandardTapped:(id)sender
{
    [_btnStandard setBackgroundColor:[UIColor greenColor]];
    [_btnSatellite setBackgroundColor:[UIColor clearColor]];
    [_btnHybrid setBackgroundColor:[UIColor clearColor]];
    [_objMapView setMapType:MKMapTypeStandard];
}
/* Changes map to a satalite view */
- (IBAction)btnSatelliteTapped:(id)sender
{
    [_btnStandard setBackgroundColor:[UIColor clearColor]];
    [_btnSatellite setBackgroundColor:[UIColor greenColor]];
    [_btnHybrid setBackgroundColor:[UIColor clearColor]];
    [_objMapView setMapType:MKMapTypeSatellite];
}
/* Changes map to a satalite view with roads */
- (IBAction)btnHybridTapped:(id)sender
{
    [_btnStandard setBackgroundColor:[UIColor clearColor]];
    [_btnSatellite setBackgroundColor:[UIColor clearColor]];
    [_btnHybrid setBackgroundColor:[UIColor greenColor]];
    [_objMapView setMapType:MKMapTypeHybrid];
}

@end

