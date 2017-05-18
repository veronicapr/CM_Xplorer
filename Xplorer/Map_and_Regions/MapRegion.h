//
//  MapRegion.h
//  Xplorer
//
//  Created by Verónica Rocha on 18/05/17.
//  Copyright © 2017 something. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface MapRegion : NSObject

@property (strong) CLCircularRegion *region;
@property (strong) NSString *name;

- (id) initRegionWithIdentifier:(NSString*) IDName
                           Name:(NSString*) name
              LatitudeInDegrees:(double) latitude
             LongitudeInDegrees:(double) longitude
                 RadiusInMeters:(double) radius;

- (void) addRegionToLocationManager:(CLLocationManager*) location_manager;
- (void) requestRegionState:(CLLocationManager*) location_manager;

@end
