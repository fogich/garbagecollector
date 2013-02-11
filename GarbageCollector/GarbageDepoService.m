//
//  GarbageDepoService.m
//  GarbageCollector
//
//  Created by Student06 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "GarbageDepoService.h"

@interface GarbageDepoService ()

@property (strong, nonatomic) NSURLConnection* connection;
@property (strong, nonatomic) NSMutableData* data;

@end

@implementation GarbageDepoService

-(void)getNearestGarbageDepoFromPoint:(CLLocationCoordinate2D)point
{
    self.data = [NSMutableData data];
    
    NSString* depoServiceCall = [NSString stringWithFormat:@"http://www.garbagebg.net/Default.aspx?lat=%f&lng=%f", point.latitude, point.longitude];
    
    NSURL* url = [NSURL URLWithString:depoServiceCall];
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
    GarbageDepo* depo = [[[JSONParser alloc] init] getDepoLocationFromData:self.data];
    //notify subscribers
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    NSDictionary* dictionary = [NSDictionary dictionaryWithObject:depo forKey:@"depo"];
    [center postNotificationName:@"GarbageDepoReady" object:self userInfo:dictionary];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.data appendData:data]; 
}

@end
