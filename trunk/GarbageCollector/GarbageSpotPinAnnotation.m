//
//  PinAnnotation.m
//  ClubPoints
//
//  Created by Student06 on 1/21/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "GarbageSpotPinAnnotation.h"


@implementation GarbageSpotPinAnnotation
@synthesize garbageSpot;

-(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake([self.garbageSpot.latitude doubleValue], [self.garbageSpot.longitude doubleValue]);
}

-(NSString *)title
{
    return self.garbageSpot.address;
}

-(NSString *)subtitle
{
    return [NSString stringWithFormat: @"Reported by: %@", self.garbageSpot.reporter.fbName];
}

@end
