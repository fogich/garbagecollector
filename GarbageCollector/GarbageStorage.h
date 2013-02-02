//
//  GarbageStorage.h
//  GarbageCollector
//
//  Created by Student06 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GarbageSpot.h"

@interface GarbageStorage : NSObject

- (void)saveContext;
- (void)addGarbageSpot:(GarbageSpot*) garbageSpot;
-(NSArray*)allGarbageSpots;
-(GarbageSpot*)createGarbageSpot;
+(id)instance;

@end
