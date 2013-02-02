//
//  MapViewController.m
//  GarbageCollector
//
//  Created by Student09 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "MapViewController.h"
#import "PinAnnotation.h"

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;

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
    
    //initializing map
    self.map.mapType = MKMapTypeStandard;
    
    NSMutableArray* annots = [NSMutableArray array];
    PinAnnotation* p = [[PinAnnotation alloc] init];
    p.name = @"Jim Beam Center";
    p.subName = @"Tel : 0878 454647";
    p.x = 42.691126;
    p.y = 23.319875;
    [annots addObject: p];
    
    PinAnnotation* p1 = [[PinAnnotation alloc] init];
    p1.name = @"Rock N Rolla";
    p1.subName = @"Tel: 0886 242020";
    p1.x = 42.694442;
    p1.y = 23.322512;
    [annots addObject: p1];
    
    PinAnnotation* p2 = [[PinAnnotation alloc] init];
    p2.name = @"Rock it";
    p2.subName = @"Tel: 09898703535";
    p2.x = 42.698692;
    p2.y = 23.328907;
    [annots addObject: p2];

    self.map.delegate = self;
    [self.map addAnnotations: annots];
}

-(void)viewWillAppear:(BOOL)animated
{
    CLLocationCoordinate2D defultLocation;
    
    defultLocation.latitude = 42.691126;
    defultLocation.longitude = 23.319875;
    
    MKCoordinateRegion defaultRegion = MKCoordinateRegionMakeWithDistance(defultLocation, 800, 800);
    [self.map setRegion:defaultRegion animated:YES];
    
//    self.map.region =
//    MKCoordinateRegionMake(CLLocationCoordinate2DMake(42.691126,23.319875), MKCoordinateSpanMake(0.05, 0.05));
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
        
        UIButton* b = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        b.tag = 1;
        pinView.leftCalloutAccessoryView = b;
        
        UIButton* b2 = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        b2.tag = 2;
        pinView.rightCalloutAccessoryView = b2;
    }
    else
    {
        //PinAnnotation* pA = (PinAnnotation*)annotation;
        //pinView.annotation = pA;
    }
    
    return pinView;
}

-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    if(control.tag == 1)
    {
        PinAnnotation* pinAnotation = (PinAnnotation*)view.annotation;
        
        NSString* message = [NSString stringWithFormat:@"%@ %@", pinAnotation.title, pinAnotation.subtitle];
        
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Table Reserved" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}



@end
