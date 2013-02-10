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
#import "AppDelegate.h"

@interface ImagePickerViewController ()<UIAlertViewDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) GarbageSpot* garbageSpot;
@property (nonatomic)  UIPopoverController* popOver;
@property (strong, nonatomic) CLPlacemark* placemark;

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
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(returnToPreviousScreen)];
    self.navigationBarItems.leftBarButtonItems = [NSArray arrayWithObject:backButton];
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.window.bounds.size.width, 30)];
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake((self.view.window.bounds.size.width/2)-40, 0, 160, 30)];
    
    title.text = [(AppDelegate *)[[UIApplication sharedApplication] delegate] userName];
    [title setTextColor:[UIColor blackColor]];
    [title setFont:[UIFont boldSystemFontOfSize:16.0]];
    
    [title setBackgroundColor:[UIColor clearColor]];
    UIImage *image = [(AppDelegate *)[[UIApplication sharedApplication] delegate] profilePicture];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:image];
    myImageView.frame = CGRectMake((self.view.window.bounds.size.width/2)-80, 0, 30, 30);
    [myView addSubview:title];
    [myView setBackgroundColor:[UIColor  clearColor]];
    [myView addSubview:myImageView];
    self.navigationBarItems.titleView = myView;
    
    [self.locationManager startUpdatingLocation];
}

-(void) returnToPreviousScreen
{
    [self.locationManager stopUpdatingLocation];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    [manager stopUpdatingLocation];
    
    CLLocation *location = [locations objectAtIndex:0];
    CLGeocoder* geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray* placemarkers, NSError* error)
    {
        //error handling
        CLPlacemark* placemark = [placemarkers objectAtIndex:0];
        
        //update the current garbage address and location
        [self performSelectorOnMainThread:@selector(updateLocation:) withObject:placemark waitUntilDone:NO];
    }];
    
}

-(void)updateLocation: (CLPlacemark*) placemark
{
    self.placemark = placemark;
    NSString* address = [NSString stringWithFormat:@"%@, %@, %@", placemark.locality, placemark.thoroughfare, placemark.subThoroughfare];
    self.descriptionTextView.text = [NSString stringWithFormat: @"I have found a new garbage spot at %@.", address];
}

-(void)createSpot
{
    self.garbageSpot = [[GarbageStorage instance] createGarbageSpot];
    self.garbageSpot.dateCreated = [NSDate date];
    
    NSString* address = [NSString stringWithFormat:@"%@, %@, %@", self.placemark.locality, self.placemark.thoroughfare, self.placemark.subThoroughfare];
    Location* location = [[GarbageStorage instance] createLocationWithLatitude:self.placemark.location.coordinate.latitude Longitude:self.placemark.location.coordinate.longitude Address:address Region: self.placemark.subLocality];
    
    self.garbageSpot.location = location;
    self.garbageSpot.pictureFilename = [self saveImageToDocuments];
    self.garbageSpot.pictureDescription = self.descriptionTextView.text;
    
    //start facebook post dialog
    //[self postToFacebook];
    
    //save context
    [[GarbageStorage instance] addGarbageSpot:self.garbageSpot];
}

- (void)postToFacebook{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]){
        
        NSLog(@"Connected");
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        
        SLComposeViewControllerCompletionHandler fbBlock = ^(SLComposeViewControllerResult result){
            
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Canceled");
                
            }else{
                
                NSLog(@"Done posting!");
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Update UI here
                [self returnToPreviousScreen];
            });
        };
        
        [controller setInitialText:self.descriptionTextView.text];
        [controller addImage:self.imageView.image];
        controller.completionHandler = fbBlock;
        
        [self presentViewController:controller animated:YES completion:nil];
        
    }else{
        
        NSLog(@"NOT connected");
    }
    
}

- (void)postToTwitter{
    
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]){
        
        NSLog(@"Connected");
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler fbBlock = ^(SLComposeViewControllerResult result){
            
            if (result == SLComposeViewControllerResultCancelled) {
                NSLog(@"Canceled");
            }else{
                
                NSLog(@"Done posting!");
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Update UI here
                [self returnToPreviousScreen];
            });
        };
        
        [controller setInitialText:self.descriptionTextView.text];
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
    self.addGarbageSpotButton.enabled=YES;
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
    [self createSpot];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"Pick action" message:@"Pick how you want your garbage spot to be posted" delegate:self cancelButtonTitle:@"Dont post" otherButtonTitles:@"Facebook" ,@"Twitter"  , nil];
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self postToFacebook];

    }
    else if (buttonIndex == 2) {
        [self postToTwitter];
        [self returnToPreviousScreen];

    }
    else
        [self returnToPreviousScreen];
}
@end
