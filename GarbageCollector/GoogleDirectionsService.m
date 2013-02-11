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

@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSMutableData* data;

@end

@implementation GoogleDirectionsService

-(void)getKeyLocationsBetweenPointA:(CLLocationCoordinate2D)locationA pointB:(CLLocationCoordinate2D)locationB
{
    self.data = [NSMutableData data];
    
    NSString* googleDirectionsAPICall = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/directions/json?origin=%f,%f&destination=%f,%f&sensor=false&mode=walking", locationA.latitude, locationA.longitude, locationB.latitude, locationB.longitude];
    
    NSURL* url = [NSURL URLWithString:googleDirectionsAPICall];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
    [self.connection start];
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    MKPolyline* polyline = [[[JSONParser alloc] init] getKeyLocationsFromData:self.data];
    
    //notify subscribers
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:polyline forKey:@"polyline"];
    [center postNotificationName:@"PolylineReady" object:self userInfo:dictionary];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data];
}

@end