//
//  User.h
//  GarbageCollector
//
//  Created by Student06 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GarbageSpot;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * fbid;
@property (nonatomic, retain) NSString * fbName;
@property (nonatomic, retain) NSString * fbPictureFilename;
@property (nonatomic, retain) NSSet *reports;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addReportsObject:(GarbageSpot *)value;
- (void)removeReportsObject:(GarbageSpot *)value;
- (void)addReports:(NSSet *)values;
- (void)removeReports:(NSSet *)values;

@end
