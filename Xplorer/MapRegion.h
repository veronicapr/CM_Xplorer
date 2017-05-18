//
//  MapRegion.h
//  Xplorer
//
//  Created by Miguel Ferreira on 17/05/2017.
//  Copyright © 2017 Miguel Ferreira. All rights reserved.
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
