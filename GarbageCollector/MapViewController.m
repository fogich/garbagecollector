//
//  MapViewController.m
//  GarbageCollector
//
//  Created by Student09 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "MapViewController.h"
#import "GarbageSpotPinAnnotation.h"
#import "ViewController.h"
#import "GarbageStorage.h"
#import "InfoViewController.h"
#import "AppDelegate.h"

@interface MapViewController ()

@property BOOL firstLoad;
@property id<MKAnnotation> selectedAnnotation;
@property NSArray* garbages;
@end

@implementation MapViewController
@synthesize map;
@synthesize firstLoad;
@synthesize garbages;
@synthesize selectedAnnotation;

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
    UIBarButtonItem* butt= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    UIBarButtonItem* butt1= [[UIBarButtonItem alloc] initWithTitle:@"Table" style:UIBarButtonItemStyleBordered target:self action:@selector(switchScreen)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:butt,butt1 ,nil];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(returnToPreviousScreen)];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:backButton];
    self.navigationItem.hidesBackButton=YES;
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
    self.navigationItem.titleView = myView;
    
	// Do any additional setup after loading the view.
    
    self.map.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //initializing map annotations
    self.firstLoad = YES;
    self.garbages = [[GarbageStorage instance] allGarbageSpots];
    NSMutableArray* annots = [NSMutableArray array];
    
    for(int i = 0; i < garbages.count; i++)
    {
        GarbageSpotPinAnnotation* p = [[GarbageSpotPinAnnotation alloc] init];
        p.garbageSpot = [self.garbages objectAtIndex:i];
        [annots addObject: p];
    }
    
    if (self.map.annotations.count > 0)
    {
        [self.map removeAnnotations:self.map.annotations];
    }

    [self.map addAnnotations: annots];
}

-(void) returnToPreviousScreen
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

-(void) addItem
{
    [self performSegueWithIdentifier:@"newGarbageSpot" sender:self];
}

-(void) switchScreen
{
    ViewController* mvc = self.navigationController.viewControllers[0];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [mvc switchToTableScreen];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"pinView"];
    if (!pinView) {
        pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pinView"];
        pinView.canShowCallout = YES;
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = button;
    }
    else
    {
        GarbageSpotPinAnnotation* pA = (GarbageSpotPinAnnotation*)annotation;
        pinView.annotation = pA;
    }
    
    GarbageSpotPinAnnotation* spotPinAnnotation = pinView.annotation;
    if(spotPinAnnotation.garbageSpot.dateCleaned)
    {
        pinView.pinColor = MKPinAnnotationColorGreen;
    }
    else
    {
        pinView.pinColor = MKPinAnnotationColorRed;
    }
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    self.selectedAnnotation = view.annotation;
    [self performSegueWithIdentifier:@"fullInfo" sender:self];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"fullInfo"])
    {
        InfoViewController* infoViewController = segue.destinationViewController;
        GarbageSpotPinAnnotation* selectedPin = self.selectedAnnotation;
        infoViewController.garbageSpot = selectedPin.garbageSpot;
    }
}

-(void)mapViewDidFinishLoadingMap:(MKMapView *)mapView
{
    if(self.firstLoad)
    {
        MKCoordinateRegion region;
        //center on the first spot
        if(self.garbages && self.garbages.count > 0)
        {
            GarbageSpot* spot = [self.garbages objectAtIndex:0];
            region  = MKCoordinateRegionMake(CLLocationCoordinate2DMake([spot.location.latitude doubleValue], [spot.location.longitude doubleValue]), MKCoordinateSpanMake(0.1, 0.1));
        }
        else
        {
           region  = MKCoordinateRegionMake(CLLocationCoordinate2DMake(42.691126,23.319875), MKCoordinateSpanMake(0.1, 0.1));
        }
        
        self.map.region = [self.map regionThatFits:region];
        self.firstLoad = NO;
    }
}

@end
