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

@interface MapViewController ()

@property BOOL firstLoad;
@property id<MKAnnotation> selectedAnnotation;
@end

@implementation MapViewController
@synthesize map;

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
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:16];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    titleView.text=@"Facebook Profile";
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"images.jpg"] style:UIBarButtonItemStylePlain target:self action:nil];
	// Do any additional setup after loading the view.
    
    //initializing map annotations
    
    self.firstLoad = YES;
    NSArray* garbages = [[GarbageStorage instance] allGarbageSpots];
    NSMutableArray* annots = [NSMutableArray array];

    for(int i = 0; i < garbages.count; i++)
    {
        GarbageSpotPinAnnotation* p = [[GarbageSpotPinAnnotation alloc] init];
        p.garbageSpot = [garbages objectAtIndex:i];
        [annots addObject: p];
    }
    
    self.map.delegate = self;
    [self.map addAnnotations: annots];
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
        //center on the first spot
        MKCoordinateRegion region  = MKCoordinateRegionMake(CLLocationCoordinate2DMake(42.691126,23.319875), MKCoordinateSpanMake(0.01, 0.01));
        self.map.region = [self.map regionThatFits:region];
        self.firstLoad = NO;
    }
}

@end
