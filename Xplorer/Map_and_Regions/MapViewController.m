//
//  MapViewController.m
//  Xplorer
//
//  Created by Verónica Rocha on 18/05/17.
//  Copyright © 2017 something. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MapViewController.h"

@implementation MapViewController

@synthesize location_manager = _location_manager;

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    switch (state) {
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

@end
