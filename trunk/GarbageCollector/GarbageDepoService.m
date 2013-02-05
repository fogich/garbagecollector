//
//  GarbageDepoService.m
//  GarbageCollector
//
//  Created by Student06 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "GarbageDepoService.h"


@implementation GarbageDepoService

-(GarbageDepo*)getNearestGarbageDepoFromPoint:(CLLocationCoordinate2D)point
{
    NSString* depoServiceCall = [NSString stringWithFormat:@"http://www.garbagebg.net/Default.aspx?lat=%f&lng=%f", point.latitude, point.longitude];
    
    NSURL* url = [NSURL URLWithString:depoServiceCall];
    NSData* depoData = [NSData dataWithContentsOfURL:url];
    
    GarbageDepo* depo = [[[JSONParser alloc] init] getDepoLocationFromData:depoData];
    return depo;
}

@end
