//
//  DataGenerator.m
//  GarbageCollector
//
//  Created by Student06 on 2/10/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "DataGenerator.h"
#import "Location.h"
#import "GarbageSpot.h"
#import "GarbageStorage.h"

@interface DataGenerator ()

@property (strong, nonatomic) GarbageSpot* garbageSpot;
@property (strong, nonatomic) CLPlacemark* placemark;
@property int counter;

@end

@implementation DataGenerator

-(void)generate
{
    self.counter = 0;
    [self start];
}

-(void)start
{
    double lat_d = (double)(arc4random() % LAT_D_MAX) / 1000000;
    double lng_d = (double)(arc4random() % LNG_D_MAX) / 1000000;
    double lat = 42.657697 + lat_d;
    double lng = 23.236771 + lng_d;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarkers, NSError* error)
    {
         CLPlacemark* placemark = [placemarkers objectAtIndex:0];
         
         //update the current garbage address and location
         [self performSelectorOnMainThread:@selector(updateLocation:) withObject:placemark waitUntilDone:NO];
    }];
}

-(void)updateLocation: (CLPlacemark*) placemark
{
    self.placemark = placemark;
    [self createSpot];
}

-(void)createSpot
{
    self.garbageSpot = [[GarbageStorage instance] createGarbageSpot];
    self.garbageSpot.dateCreated = [NSDate date];
    
    NSString* address = [NSString stringWithFormat:@"%@, %@, %@", self.placemark.locality, self.placemark.thoroughfare, self.placemark.subThoroughfare];
    Location* location = [[GarbageStorage instance] createLocationWithLatitude:self.placemark.location.coordinate.latitude Longitude:self.placemark.location.coordinate.longitude Address:address Region: self.placemark.subLocality];
    
    self.garbageSpot.location = location;
    self.garbageSpot.pictureFilename = [self saveImageToDocuments];
    self.garbageSpot.pictureDescription = [NSString stringWithFormat:@"description %d", self.counter];
    
    [[GarbageStorage instance] addGarbageSpot:self.garbageSpot];
    
    self.counter++;
    if(self.counter < DATA_LENGTH)
    {
        [self start];
    }
}


-(NSString*)saveImageToDocuments
{
    //copy the image into documents
    //and get its new filename
    //self.imageView.image;
    
    //set filename with timestamp
    NSDate* date = [NSDate date];
    NSCalendar* gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents* comps = [gregorian components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit|NSSecondCalendarUnit fromDate:date];
    
    int year = [comps year];
    int month = [comps month];
    int day = [comps day];
    int hour = [comps hour];
    int min = [comps minute];
    int sec = [comps second];
    //randomize date
    NSString* dateString = [NSString stringWithFormat:@"%d_%d_%d_%d_%d_%d", year, month, day, hour, min, sec];
    
    NSString *toPath = [self destinationPathForFile:dateString filetype:@"jpg" directory:NSDocumentDirectory];
    

    
    UIImage* image = [UIImage imageNamed:@""];
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:toPath atomically:YES];
    
    return toPath;
}

-(NSString*)destinationPathForFile: (NSString*)filename
                          filetype: (NSString*)filetype
                         directory: (NSSearchPathDirectory)directory
{
    NSString *dirPath = [NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString* resultPath = [NSString stringWithFormat: @"%@.%@", [NSString pathWithComponents: [NSArray arrayWithObjects:dirPath, filename, nil]], filetype];
    return resultPath;
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    //cannot add location
}

@end

@end
