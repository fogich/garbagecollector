//
//  PinAnnotation.m
//  ClubPoints
//
//  Created by Student06 on 1/21/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "GarbageSpotPinAnnotation.h"

@implementation GarbageSpotPinAnnotation
@synthesize x;
@synthesize y;
@synthesize name;
@synthesize subName;

-(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.x, self.y);
}

-(NSString *)title
{
    return self.name;
}

-(NSString *)subtitle
{
   return self.subName;
}

@end
