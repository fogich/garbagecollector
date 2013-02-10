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
    NSCalendar* gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [gregorian components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit fromDate:self.garbageSpot.dateCreated];
    
    int year = [comps year];
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int min = [comps minute];
    int sec = [comps second];
    
    NSString* dateString = [NSString stringWithFormat:@"%d-%d-%d %d:%d:%d", year, month, day, hour, min, sec];
    
    return [NSString stringWithFormat: @"Since: %@", dateString];
}

@end
