//
//  GarbageSpot.h
//  GarbageCollector
//
//  Created by Student06 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface GarbageSpot : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSDate * dateCleaned;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * fbid;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * pictureDescription;
@property (nonatomic, retain) NSString * pictureFilename;
@property (nonatomic, retain) NSSet *comments;
@property (nonatomic, retain) NSManagedObject *reporter;
@end

@interface GarbageSpot (CoreDataGeneratedAccessors)

- (void)addCommentsObject:(NSManagedObject *)value;
- (void)removeCommentsObject:(NSManagedObject *)value;
- (void)addComments:(NSSet *)values;
- (void)removeComments:(NSSet *)values;

@end
