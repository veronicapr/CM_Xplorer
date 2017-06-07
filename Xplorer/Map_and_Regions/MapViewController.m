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

@implementation MapViewController

// ====================================================================================== //
// Controler variables
// ====================================================================================== //
@synthesize location_manager = _location_manager;
@synthesize user_location = _user_location;

// ====================================================================================== //
// UI Elements
// ====================================================================================== //
@synthesize objMapView;
@synthesize btnHybrid, btnSatellite, btnStandard;

// ============================================================================================================================================================================ //
// Map Controller calls
// ============================================================================================================================================================================ //
/* Called after the controller's view is loaded into memory */
- (void)viewDidLoad
{
    [super viewDidLoad];
    //[self loadUserLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/* Memory warning handler */
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
// ============================================================================================================================================================================ //
// Map methods
// ============================================================================================================================================================================ //
// ====================================================================================== //
// Location Manager
// ====================================================================================== //
/* Create region with the given coodinates and radius */
- (void) loadUserLocation
{
    _location_manager = [[CLLocationManager alloc] init];
    _location_manager.delegate = self;
    _location_manager.distanceFilter = kCLDistanceFilterNone;
    _location_manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    if ([_location_manager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_location_manager requestWhenInUseAuthorization];
    }
    [_location_manager startUpdatingLocation];
}
/* Create region with the given coodinates and radius */
- (void) loadMapView
{
    MKCoordinateSpan objCoorSpan = {.latitudeDelta =  0.2, .longitudeDelta =  0.2};
    MKCoordinateRegion objMapRegion = {_user_location, objCoorSpan};
    [objMapView setRegion:objMapRegion];
}
// ====================================================================================== //
// Regions
// ====================================================================================== //
/* Create region with the given coodinates and radius */
- (CLCircularRegion *)createRegionWithName:(NSString *)name Latitude:(CLLocationDegrees)latitude Longitude:(CLLocationDegrees)longitude andRadius:(int) radius
{
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:centerCoordinate radius:radius identifier:name];
    return region;
}
/* Starts region monitor for given region and checks that region state */
- (void)startRegionMonitoringAndCheckStateForRegion:(CLRegion *)region
{
    [_location_manager startMonitoringForRegion:region];
    [_location_manager requestStateForRegion:region];
}

// ============================================================================================================================================================================ //
// CLLocationManagerDelegate notifications handlers
// ============================================================================================================================================================================ //
// ====================================================================================== //
// Responding to Location Events
// ====================================================================================== //
/* Tells the delegate that new location data is available */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"%@", locations.description);
    
    CLLocation *newLocation = [locations objectAtIndex:0];

    _user_location = newLocation.coordinate;
    
    [_location_manager stopUpdatingLocation];

    [self loadMapView];
}
/* Tells the delegate that the location manager was unable to retrieve a location value */
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [_location_manager stopUpdatingLocation];
}
// ====================================================================================== //
// Responding to Location Events
// ====================================================================================== //
/* Tells the delegate about the state of the specified region */
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    NSLog(@"Type CLRegionStateInside : %li", CLRegionStateInside);
    NSLog(@"Type CLRegionStateOutside : %li", CLRegionStateOutside);
    NSLog(@"Type CLRegionStateUnknown : %li", CLRegionStateUnknown);
    NSLog(@"%li", state);
    
    switch (state)
    {
        case CLRegionStateInside:
            break;
        case CLRegionStateOutside:
            break;
        case CLRegionStateUnknown:
            break;
        default:
            break;
    }
}

// ============================================================================================================================================================================ //
// Button functions
// ============================================================================================================================================================================ //
/* Changes map to show only roads */
- (IBAction)btnStandardTapped:(id)sender
{
    [btnStandard setBackgroundColor:[UIColor greenColor]];
    [btnSatellite setBackgroundColor:[UIColor clearColor]];
    [btnHybrid setBackgroundColor:[UIColor clearColor]];
    [objMapView setMapType:MKMapTypeStandard];
    [self loadUserLocation];
}
/* Changes map to a satalite view */
- (IBAction)btnSatelliteTapped:(id)sender
{
    [btnStandard setBackgroundColor:[UIColor clearColor]];
    [btnSatellite setBackgroundColor:[UIColor greenColor]];
    [btnHybrid setBackgroundColor:[UIColor clearColor]];
    [objMapView setMapType:MKMapTypeSatellite];
    [self loadUserLocation];
}
/* Changes map to a satalite view with roads */
- (IBAction)btnHybridTapped:(id)sender
{
    [btnStandard setBackgroundColor:[UIColor clearColor]];
    [btnSatellite setBackgroundColor:[UIColor clearColor]];
    [btnHybrid setBackgroundColor:[UIColor greenColor]];
    [objMapView setMapType:MKMapTypeHybrid];
    [self loadUserLocation];
}

@end

