//
//  GarbageDepoService.h
//  GarbageCollector
//
//  Created by Student06 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "JSONParser.h"

@interface GarbageDepoService : NSObject

-(GarbageDepo*) getNearestGarbageDepoFromPoint: (CLLocationCoordinate2D) point;

@end
