//
//  PinAnnotation.h
//  ClubPoints
//
//  Created by Student06 on 1/21/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "GarbageSpot.h"
#import "User.h"

@interface GarbageSpotPinAnnotation : NSObject<MKAnnotation>

@property GarbageSpot* garbageSpot;

@end
