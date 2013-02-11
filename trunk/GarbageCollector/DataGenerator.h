//
//  DataGenerator.h
//  GarbageCollector
//
//  Created by Student06 on 2/10/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define LAT_D_MAX 99903
#define LNG_D_MAX 183334
#define DATA_LENGTH 40
#define PAST_DAYS_MAX 31
#define GENERATE_CLEANED_SEED 7

@interface DataGenerator : NSObject<CLLocationManagerDelegate>

-(void)generate;

@end
