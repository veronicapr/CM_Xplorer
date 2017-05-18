//
//  MapRegion.m
//  Xplorer
//
//  Created by Verónica Rocha on 18/05/17.
//  Copyright © 2017 something. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapRegion.h"

@implementation MapRegion

@synthesize region = _region;
@synthesize name = _name;

- (id) initRegionWithIdentifier:(NSString*) IDName Name:(NSString*) name LatitudeInDegrees:(double) latitude LongitudeInDegrees:(double) longitude RadiusInMeters:(double) radius {
    if ((self = [super init])) {
        CLLocationDegrees region_latitude = latitude;
        CLLocationDegrees region_longitude = longitude;
        CLLocationCoordinate2D region_coordinates = CLLocationCoordinate2DMake(region_latitude, region_longitude);
        CLLocationDistance region_radius;
        if (radius < 50.0) {
            region_radius = 50.0;
        } else {
            region_radius = radius;
        }
        _region = [[CLCircularRegion alloc] initWithCenter:region_coordinates radius:region_radius identifier:IDName];
        _name = name;
    }
    return self;
}

- (void) addRegionToLocationManager:(CLLocationManager *) location_manager {
    [location_manager startMonitoringForRegion:_region];
}
- (void) requestRegionState:(CLLocationManager*) location_manager {
    [location_manager requestStateForRegion:_region];
}
@end
