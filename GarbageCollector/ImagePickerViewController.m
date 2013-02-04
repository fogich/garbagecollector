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

@end

@implementation ImagePickerViewController
@synthesize locationManager=_locationManager;

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
    
    GarbageSpot* newSpot = [[GarbageStorage instance] createGarbageSpot];
    newSpot.latitude = [NSNumber numberWithDouble: placemark.location.coordinate.latitude];
    newSpot.longitude = [NSNumber numberWithDouble: placemark.location.coordinate.longitude];
    newSpot.address = address;
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
