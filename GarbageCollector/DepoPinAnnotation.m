//
//  DepoPinAnnotation.m
//  GarbageCollector
//
//  Created by Student06 on 2/6/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "DepoPinAnnotation.h"

@implementation DepoPinAnnotation
@synthesize garbageDepo;

-(CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.garbageDepo.latitude, self.garbageDepo.longitude);
}

-(NSString *)title
{
    return self.garbageDepo.name;
}

-(NSString *)subtitle
{
    return [NSString stringWithFormat: @"Phone: %@", self.garbageDepo.phone];
}

@end
