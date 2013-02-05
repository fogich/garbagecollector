//
//  GoogleDirectionsService.m
//  GarbageCollector
//
//  Created by Student06 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "GoogleDirectionsService.h"
#import "JSONParser.h"

@interface GoogleDirectionsService ()

@end

@implementation GoogleDirectionsService

-(MKPolyline*)getKeyLocationsBetweenPointA:(CLLocationCoordinate2D)locationA pointB:(CLLocationCoordinate2D)locationB
{
    NSString* googleDirectionsAPICall = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=walking", locationA.latitude, locationA.longitude, locationB.latitude, locationB.longitude];
    
    NSURL* url = [NSURL URLWithString:googleDirectionsAPICall];
    NSData* routeData = [NSData dataWithContentsOfURL:url];
    
    MKPolyline* polyline = [[[JSONParser alloc] init] getKeyLocationsFromData:routeData];
    return polyline;
}
@end
