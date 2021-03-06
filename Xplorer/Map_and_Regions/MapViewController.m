//
//  MapViewController.m
//  Xplorer
//
//  Created by Verónica Rocha on 18/05/17.
//  Copyright © 2017 something. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

#define UPDATE_FILTER_METERS ((double) 20.0)
#define LOAD_RADIUS_KM ((double) 2.5)

@implementation MapViewController

// Managers
@synthesize location_manager = _location_manager;
@synthesize database_manager = _database_manager;

// Controler variables
@synthesize query = _query;
@synthesize query_results = _query_results;
@synthesize user_location = _user_location;
@synthesize loaded_regions_center = _loaded_regions_center;

// UI Elements
@synthesize map_view = _map_view;
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
    _database_manager = [(AppDelegate*)[[UIApplication sharedApplication] delegate] database_manager];
    _query = nil;
    _query_results = nil;
    [self retrieveUserID];
    [self checkUserIDInDatabase];
    [self startLocationManager];
    [self retrieveLandmarksFromDatabase];
    [self updateLabelInfo];
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
-(void)startLocationManager
{
    _location_manager = [[CLLocationManager alloc] init];
    _location_manager.delegate = self;
    _location_manager.distanceFilter = UPDATE_FILTER_METERS;
    _location_manager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([_location_manager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
        [_location_manager requestAlwaysAuthorization];
    }
    [_location_manager startUpdatingLocation];
}
/* Zooms map at user location */
-(void)zoomAtUserLocation
{
    MKCoordinateSpan coordinate_span = {.latitudeDelta = 0.005, .longitudeDelta = 0.005};
    MKCoordinateRegion map_region = {_user_location, coordinate_span};
    [_map_view setRegion:map_region];
}
/* Create region with the given coodinates and radius */
-(CLCircularRegion *)createRegionWithName:(NSString *)name Latitude:(CLLocationDegrees)latitude Longitude:(CLLocationDegrees)longitude andRadius:(CLLocationDistance) radius
{
    CLLocationCoordinate2D center_coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLCircularRegion *region = [[CLCircularRegion alloc] initWithCenter:center_coordinate radius:radius identifier:name];
    return region;
}
/* Retrieves userID from gamecenter */
-(void)retrieveUserID
{
    GKLocalPlayer *local_player = [GKLocalPlayer localPlayer];
    local_player.authenticateHandler = ^(UIViewController *viewController, NSError *error)
    {
        if (viewController != nil) {
            [self presentViewController:viewController animated:YES completion:nil];
        }
    };
    NSLog(@"%@", local_player.playerID);
}
/* add user to database */
-(void)checkUserIDInDatabase
{
    
}
/* retreives landmarks from database to create regions */
-(void)retrieveLandmarksFromDatabase
{
    // retreive data from databaseß
    _query = @"Select * from Areas where Active = 1";
    _query_results = [[NSArray alloc] initWithArray:[_database_manager loadDataFromDB:_query]];
    
    // retrive indexes
    NSInteger index_of_landmark = [_database_manager.array_column_names indexOfObject:@"Landmark"];
    NSInteger index_of_latitude = [_database_manager.array_column_names indexOfObject:@"Latitude"];
    NSInteger index_of_longitude = [_database_manager.array_column_names indexOfObject:@"Longitude"];
    NSInteger index_of_radius = [_database_manager.array_column_names indexOfObject:@"Radius"];
    NSInteger index_of_row;
   
    // instanciate values
    CLRegion *region = nil;
    NSString *region_name = nil;
    CLLocationDegrees region_latitude;
    CLLocationDegrees region_longitude;
    CLLocationDistance region_radius;
    
    // process data
    for (index_of_row = 0; index_of_row < _query_results.count; index_of_row++)
    {
        region_name = [NSString stringWithString:(NSString *)[(NSArray *)[_query_results objectAtIndex:index_of_row] objectAtIndex:index_of_landmark]];
        region_latitude = (CLLocationDegrees)[(NSString *)[(NSArray *)[_query_results objectAtIndex:index_of_row] objectAtIndex:index_of_latitude] doubleValue];
        region_longitude = (CLLocationDegrees)[(NSString *)[(NSArray *)[_query_results objectAtIndex:index_of_row] objectAtIndex:index_of_longitude] doubleValue];
        region_radius = (CLLocationDistance)[(NSString *)[(NSArray *)[_query_results objectAtIndex:index_of_row] objectAtIndex:index_of_radius] doubleValue];
        
        region = [self createRegionWithName:region_name Latitude:region_latitude Longitude:region_longitude andRadius:region_radius];
        
        [_location_manager startMonitoringForRegion:region];
        
        region = nil;
        region_name = nil;
    }
    
    // update label info
    _region_landmarks = _query_results.count;
    
    // clear memory
    _query = nil;
    _query_results = nil;
}
/*  */
-(void)addMapIconToRegion:(CLRegion *)region
{
    Landmark *landmark = [[Landmark alloc] initWithName:[(CLCircularRegion *)region identifier] Coordinate:[(CLCircularRegion *)region center]];
    [_map_view addAnnotation:landmark];
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
    if (error.code != 0) {
        NSLog(@"didFailWithError %@", error.localizedDescription);
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
    _found_landmarks = _found_landmarks + 1;
    [self updateLabelInfo];
}
/* Tells the delegate about the state of the specified region */
- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    switch (state) {
        case CLRegionStateInside:
            NSLog(@"Region state inside");
            _found_landmarks = _found_landmarks + 1;
            [self updateLabelInfo];
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
    [self addMapIconToRegion:region];
}

// ====================================================================================== //
// CLLocationManagerDelegate notifications handlers
// ====================================================================================== //
/* Returns the view associated with the specified annotation object */
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    if([annotation isKindOfClass:[Landmark class]])
    {
        Landmark *landmark = (Landmark *)annotation;
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:@"Landmark"];
        if(annotationView == nil)
        {
            annotationView = landmark.annotationView;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    else
    {
        return nil;
    }
}

// ====================================================================================== //
// Others
// ====================================================================================== //
/* Generates a new text for the info labels */
- (void)updateLabelInfo
{
    NSString *landmark_info = [NSString stringWithFormat:@"%lu / %lu", _found_landmarks, _region_landmarks];
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
    [_map_view setMapType:MKMapTypeStandard];
}
/* Changes map to a satalite view */
- (IBAction)btnSatelliteTapped:(id)sender
{
    [_btnStandard setBackgroundColor:[UIColor clearColor]];
    [_btnSatellite setBackgroundColor:[UIColor greenColor]];
    [_btnHybrid setBackgroundColor:[UIColor clearColor]];
    [_map_view setMapType:MKMapTypeSatellite];
}
/* Changes map to a satalite view with roads */
- (IBAction)btnHybridTapped:(id)sender
{
    [_btnStandard setBackgroundColor:[UIColor clearColor]];
    [_btnSatellite setBackgroundColor:[UIColor clearColor]];
    [_btnHybrid setBackgroundColor:[UIColor greenColor]];
    [_map_view setMapType:MKMapTypeHybrid];
}

@end

