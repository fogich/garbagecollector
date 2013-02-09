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
    return CLLocationCoordinate2DMake([self.garbageSpot.location.latitude doubleValue], [self.garbageSpot.location.longitude doubleValue]);
}

-(NSString *)title
{
    return self.garbageSpot.location.address;
}

-(NSString *)subtitle
{
    return [NSString stringWithFormat: @"Since: %@", self.garbageSpot.dateCreated];
}

@end
