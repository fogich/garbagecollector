//
//  ImagePickerViewController.m
//  GarbageCollector
//
//  Created by Student09 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "GarbageStorage.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ImagePickerViewController ()

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) GarbageSpot* garbageSpot;
@property (nonatomic)  UIPopoverController* popOver;
- (IBAction)useImageClicked:(id)sender;
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
    self.navigationBarItems.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"images.jpg"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem* butt= [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(returnToPreviousScreen)];
    self.navigationBarItems.rightBarButtonItems = [NSArray arrayWithObjects:butt ,nil];
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:16];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    titleView.text=@"Facebook Profile";
    self.navigationBarItems.titleView = titleView;
    [titleView sizeToFit];
    self.navigationBarItems.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"images.jpg"] style:UIBarButtonItemStylePlain target:self action:nil];
}
-(void) returnToPreviousScreen
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    self.garbageSpot.fbid = @"test_facebook_id";
    
    self.garbageSpot.latitude = [NSNumber numberWithDouble: placemark.location.coordinate.latitude];
    self.garbageSpot.longitude = [NSNumber numberWithDouble: placemark.location.coordinate.longitude];
    self.garbageSpot.address = address;
    self.garbageSpot.pictureFilename = [self saveImageToDocuments];
    
    //start facebook post dialog
    //[self postToFacebook];
    
    //get fbid from facebook... naahh, maybe not :)
    
    //save context
    [[GarbageStorage instance] addGarbageSpot:self.garbageSpot];
    [self dismissViewControllerAnimated:YES completion:nil];
}


//getting username from the accounts framework requires Facebook developers account to generate facebook app ID
//-(void)getUsername{
//    
//    ACAccountStore *accStore = [ACAccountStore new];
//    ACAccountType *accType = [accStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
//    
//    NSDictionary *options = @{@"ACFacebookAppIdKey" : @""};
//    
//    [accStore requestAccessToAccountsWithType:accType options:options completion:^(BOOL granted, NSError *err){
//        
//        if (granted == YES) {
//            NSLog(@"Granted");
//            NSArray *accArray = [accStore accountsWithAccountType:accType];
//            ACAccount *fbAcc = [accArray lastObject];
//            
//            NSLog(@"Account desc: %@ UserName: %@ Identifier: %@", fbAcc.description, fbAcc.username, fbAcc.identifier);
//        }
//                    NSLog(@"Something else!");
//        
//    }];
//    
//}

- (void)postToFacebook{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        
        NSLog(@"Connected");
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler fbBlock = ^(SLComposeViewControllerResult result){
            
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Canceld");
            }else{
                
                NSLog(@"Done posting!");
            }
            
            
        };
        
        [controller setInitialText:[NSString stringWithFormat:@"I have found a new garbage spot at %@", self.garbageSpot.address]];
        [controller addImage:self.imageView.image];
        controller.completionHandler = fbBlock;
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        
        NSLog(@"NOT connected");
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
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIPopoverController *tempPopOver = [[UIPopoverController alloc] initWithContentViewController:picker];
        [tempPopOver presentPopoverFromRect:[[self takePictureButton] frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        [self setPopOver:tempPopOver];
    }
    else
    {
        [self presentViewController:picker animated:YES completion:nil];

    }

}

-(IBAction)selectExitingPicture
{    
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            
            UIPopoverController *tempPopOver = [[UIPopoverController alloc] initWithContentViewController:picker];
            [tempPopOver presentPopoverFromRect:[[self selectFromCameraRollButton] frame] inView:[self view] permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
            [self setPopOver:tempPopOver];
            
        }
        else {
            [self presentViewController:picker animated:YES completion:nil];
        }
        
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    self.imageView.image = image;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [[self popOver] dismissPopoverAnimated:YES];
    }
    else
    {
        [picker dismissModalViewControllerAnimated:YES];
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)useImageClicked:(id)sender
{
    [self.locationManager startUpdatingLocation];
}
@end
