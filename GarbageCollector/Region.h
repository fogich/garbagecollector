//
//  Region.h
//  GarbageCollector
//
//  Created by Student06 on 2/9/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *spotLocations;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addSpotLocationsObject:(Location *)value;
- (void)removeSpotLocationsObject:(Location *)value;
- (void)addSpotLocations:(NSSet *)values;
- (void)removeSpotLocations:(NSSet *)values;

@end
