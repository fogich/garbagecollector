//
//  DepoPinAnnotation.h
//  GarbageCollector
//
//  Created by Student06 on 2/6/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GarbageDepo.h"

@interface DepoPinAnnotation : NSObject<MKAnnotation>

@property GarbageDepo* garbageDepo;

@end
