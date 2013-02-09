//
//  GarbageSpot.h
//  GarbageCollector
//
//  Created by Student06 on 2/9/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface GarbageSpot : NSManagedObject

@property (nonatomic, retain) NSDate * dateCleaned;
@property (nonatomic, retain) NSDate * dateCreated;
@property (nonatomic, retain) NSString * pictureDescription;
@property (nonatomic, retain) NSString * pictureFilename;
@property (nonatomic, retain) Location *location;

@end
