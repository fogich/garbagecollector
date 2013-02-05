//
//  JSONParser.m
//  GarbageCollector
//
//  Created by Student06 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "JSONParser.h"


@implementation JSONParser

-(MKPolyline*)getKeyLocationsFromData:(NSData *)data
{
    NSDictionary* rootDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    NSDictionary* firstRoot = [[rootDictionary objectForKey:@"routes"] objectAtIndex:0];
    
    NSDictionary* startLocation = [[[firstRoot objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"start_location"];
    
    NSNumber* startLat = [startLocation objectForKey:@"lat"];
    NSNumber* startLng = [startLocation objectForKey:@"lng"];
    
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([startLat doubleValue], [startLng doubleValue]);
    NSArray* steps = [[[firstRoot objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"];
    
    CLLocationCoordinate2D arrayofCoordinates[steps.count + 1];
    arrayofCoordinates[0] = startCoordinate;
    
    for(int i = 0; i < steps.count; i++)
    {
        NSDictionary* step = [steps objectAtIndex:i];
        
        NSDictionary* endLocation = [step objectForKey:@"end_location"];
        NSNumber* endLat = [endLocation objectForKey:@"lat"];
        NSNumber* endLng = [endLocation objectForKey:@"lng"];
        
        CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake([endLat doubleValue], [endLng doubleValue]);
        
        arrayofCoordinates[i+1] = endCoordinate;
    }
    
    return [MKPolyline polylineWithCoordinates:arrayofCoordinates count:steps.count+1];
}

-(GarbageDepo*)getDepoLocationFromData:(NSData *)data
{
    NSDictionary* rootDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    double lat = [[rootDictionary objectForKey:@"lat"] doubleValue];
    double lng = [[rootDictionary objectForKey:@"lng"] doubleValue];
    
    GarbageDepo* depo = [[GarbageDepo alloc] init];
    depo.latitude = lat;
    depo.longitude = lng;
    return depo;
}

@end
