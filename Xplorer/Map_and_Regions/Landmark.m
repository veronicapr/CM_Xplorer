//
//  Landmark.m
//  Xplorer
//
//  Created by Miguel Ferreira on 15/06/2017.
//  Copyright © 2017 something. All rights reserved.
//

#import "Landmark.h"


@implementation Landmark

@synthesize name = _name;
@synthesize coordinate = _coordinate;

/* init object with values */
-(id)initWithName:(NSString *)name Coordinate:(CLLocationCoordinate2D)coordinate
{
    self = [super init];
    if(self)
    {
        _name = name;
        _coordinate = coordinate;
    }
    return self;
}
/* return custom annotation view */
-(MKAnnotationView *)annotationView
{
    MKAnnotationView *annotationView = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"Landmark"];
    annotationView.enabled = YES;
    annotationView.canShowCallout = YES;
    annotationView.image = [UIImage imageNamed:@"Obelisk-2x.png"];
    annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return annotationView;
}

@end
