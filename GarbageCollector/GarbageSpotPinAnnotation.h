//
//  PinAnnotation.h
//  ClubPoints
//
//  Created by Student06 on 1/21/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GarbageSpotPinAnnotation : NSObject<MKAnnotation>

@property float x;
@property float y;
@property NSString* name;
@property NSString* subName;


@end
