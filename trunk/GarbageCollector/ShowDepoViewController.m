//
//  ShowDepoViewController.m
//  GarbageCollector
//
//  Created by Student06 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "ShowDepoViewController.h"
#import "PinAnnotation.h"


@interface ShowDepoViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, retain) MKPolyline* polyline;


@end

@implementation ShowDepoViewController

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
    
    NSString* googleDirectionsAPICall = @"https://maps.googleapis.com/maps/api/directions/json?origin=42.691126,23.319875&destination=42.694442,23.322512&sensor=false&mode=walking";
    
    NSURL* url = [NSURL URLWithString:googleDirectionsAPICall];
    NSData* routeData = [NSData dataWithContentsOfURL:url];
    
    NSDictionary* rootDictionary = [NSJSONSerialization JSONObjectWithData:routeData options:NSJSONReadingAllowFragments error:nil];
    NSDictionary* firstRoot = [[rootDictionary objectForKey:@"routes"] objectAtIndex:0];
    
    NSDictionary* startLocation = [[[firstRoot objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"start_location"];
    
    NSNumber* startLat = [startLocation objectForKey:@"lat"];
    NSNumber* startLng = [startLocation objectForKey:@"lng"];
    
    CLLocationCoordinate2D startCoordinate = CLLocationCoordinate2DMake([startLat doubleValue], [startLng doubleValue]);
    NSArray* steps = [[[firstRoot objectForKey:@"legs"] objectAtIndex:0] objectForKey:@"steps"];
    
    CLLocationCoordinate2D arrayofCoordinates[steps.count + 1];
    arrayofCoordinates[0] = startCoordinate;
    
    for(int i = 0; i < steps.count; i++)
    {
        NSDictionary* step = [steps objectAtIndex:i];
        
        NSDictionary* endLocation = [step objectForKey:@"end_location"];
        NSNumber* endLat = [endLocation objectForKey:@"lat"];
        NSNumber* endLng = [endLocation objectForKey:@"lng"];
        
        CLLocationCoordinate2D endCoordinate = CLLocationCoordinate2DMake([endLat doubleValue], [endLng doubleValue]);
        
        arrayofCoordinates[i+1] = endCoordinate;
    }
    
    NSLog(@"%f", arrayofCoordinates[0].latitude);
    NSLog(@"%f", arrayofCoordinates[1].latitude);
    NSLog(@"%f", arrayofCoordinates[2].latitude);
    NSLog(@"%f", arrayofCoordinates[3].latitude);
    
    self.polyline = [MKPolyline polylineWithCoordinates:arrayofCoordinates count:4];
    
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
    [self.map addOverlay:self.polyline];
    [self.map addAnnotations: annots];
}

- (MKOverlayView*)mapView:(MKMapView*)theMapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView* lineView = [[MKPolylineView alloc] initWithPolyline:self.polyline];
    lineView.fillColor = [UIColor greenColor];
    lineView.strokeColor = [UIColor blueColor];
    lineView.lineWidth = 4;
    return lineView;
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
        PinAnnotation* pA = (PinAnnotation*)annotation;
        pinView.annotation = pA;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
