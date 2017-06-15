//
//  Landmark.h
//  Xplorer
//
//  Created by Miguel Ferreira on 15/06/2017.
//  Copyright © 2017 something. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface Landmark : NSObject <MKAnnotation>

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *name;

/* init object with values */
-(id)initWithName:(NSString *)name Coordinate:(CLLocationCoordinate2D)coordinate;
/* return custom annotation view */
-(MKAnnotationView *)annotationView;

@end
