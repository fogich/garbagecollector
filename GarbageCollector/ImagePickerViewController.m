//
//  ImagePickerViewController.m
//  GarbageCollector
//
//  Created by Student09 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "GarbageStorage.h"

@interface ImagePickerViewController ()

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) GarbageSpot* garbageSpot;

@end

@implementation ImagePickerViewController
@synthesize locationManager=_locationManager;
@synthesize garbageSpot=_garbageSpot;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

-(void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations objectAtIndex:0];
//  CLLocation *location = [[CLLocation alloc] initWithLatitude:42.691126 longitude:23.319875];
    
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarkers, NSError* error)
    {
        //error handling
        [manager stopUpdatingLocation];
        CLPlacemark* placemark = [placemarkers objectAtIndex:0];
        
        //update the current garbage address
        //and location
        [self performSelectorOnMainThread:@selector(addNewGarbageSpotWithPlaceMark:) withObject:placemark waitUntilDone:NO];
    }];
    
}

-(void)addNewGarbageSpotWithPlaceMark: (CLPlacemark*) placemark
{
    NSString* address = [NSString stringWithFormat:@"%@, %@, %@, %@, %@", placemark.country, placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.subThoroughfare];
    
    self.garbageSpot = [[GarbageStorage instance] createGarbageSpot];
    self.garbageSpot.latitude = [NSNumber numberWithDouble: placemark.location.coordinate.latitude];
    self.garbageSpot.longitude = [NSNumber numberWithDouble: placemark.location.coordinate.longitude];
    self.garbageSpot.address = address;
    self.garbageSpot.pictureFilename = [self saveImageToDocuments];
    
    //start facebook post dialog
    //get fbid from facebook
    
    //add the current user as a reporter
    //save context
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
    NSString* dateString = [NSString stringWithFormat:@"%d_%d_%d_%d_%d_%d", year, month, day, hour, min, sec];
    
    NSString *toPath = [self destinationPathForFile:dateString filetype:@"jpg" directory:NSDocumentDirectory];
    [UIImageJPEGRepresentation(self.imageView.image, 1.0) writeToFile:toPath atomically:YES];
    
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)getCameraPicture:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = (sender == self.takePictureButton) ?    UIImagePickerControllerSourceTypeCamera :
    UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self presentViewController:picker animated:YES completion:nil];
}

-(IBAction)selectExitingPicture
{    
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    self.imageView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
    
    [self.locationManager startUpdatingLocation];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
