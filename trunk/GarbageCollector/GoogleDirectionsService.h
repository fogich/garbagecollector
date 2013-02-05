//
//  GoogleDirectionsService.h
//  GarbageCollector
//
//  Created by Student06 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GoogleDirectionsService : NSObject

-(MKPolyline*) getKeyLocationsBetweenPointA: (CLLocationCoordinate2D) locationA pointB: (CLLocationCoordinate2D) locationB;

@end
