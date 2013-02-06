//
//  ShowDepoViewController.m
//  GarbageCollector
//
//  Created by Student06 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "ShowDepoViewController.h"
#import "PinAnnotation.h"
#import "GoogleDirectionsService.h"
#import "GarbageDepoService.h"

@interface ShowDepoViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, retain) MKPolyline* polyline;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *depoDescriptionTextView;


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
    
    [self.activityIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CLLocationCoordinate2D startLocationCoordinate = CLLocationCoordinate2DMake([self.spotDetail.latitude doubleValue], [self.spotDetail.longitude doubleValue]);
        GarbageDepo* nearestDepo = [[[GarbageDepoService alloc] init] getNearestGarbageDepoFromPoint:startLocationCoordinate];
        CLLocationCoordinate2D endLocationCoordinate = CLLocationCoordinate2DMake(nearestDepo.latitude, nearestDepo.longitude);
        MKPolyline* polyline = [[[GoogleDirectionsService alloc] init] getKeyLocationsBetweenPointA: startLocationCoordinate pointB: endLocationCoordinate];
        
        dispatch_async(dispatch_get_main_queue(),^{
            self.depoDescriptionTextView.text = nearestDepo.aDescription;
            self.phoneLabel.text = [NSString stringWithFormat:@"  Phone: %@", nearestDepo.phone];
            
            NSMutableArray* annots = [NSMutableArray array];
            PinAnnotation* p = [[PinAnnotation alloc] init];
            p.name = self.spotDetail.address;
            p.subName = @"some more";
            p.x = [self.spotDetail.latitude floatValue];
            p.y = [self.spotDetail.longitude floatValue];
            [annots addObject: p];
            
            PinAnnotation* p1 = [[PinAnnotation alloc] init];
            p1.name = @"Depo 1";
            p1.subName = @"Depo 1 phone number";
            p1.x = endLocationCoordinate.latitude;
            p1.y = endLocationCoordinate.longitude;
            [annots addObject: p1];
            
            self.map.delegate = self;
            [self.map addAnnotations: annots];
            
            self.polyline = polyline;
            [self.map addOverlay:self.polyline];
            
            MKCoordinateSpan span = [self findGeographicalRect:self.polyline];
            self.map.region = MKCoordinateRegionMake(self.polyline.coordinate, span);
            
            [self.activityIndicator stopAnimating];
            self.activityIndicator.hidden = TRUE;
        });
    });
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.activityIndicator startAnimating];
}

-(MKCoordinateSpan)findGeographicalRect: (MKPolyline*) polyline
{
    NSRange range;
    range.location = 0;
    range.length = polyline.pointCount;
    CLLocationCoordinate2D coordinates[polyline.pointCount];
    [polyline getCoordinates:coordinates range:range];
    
    double minLeft = 180;
    double maxTop = -90;
    double maxRight = -180;
    double minBottom = 90;
    
    for(int i = 0; i < polyline.pointCount; i++)
    {
        if(coordinates[i].latitude < minLeft)
        {
            minLeft = coordinates[i].latitude;
        }
        
        if(coordinates[i].latitude > maxRight)
        {
            maxRight = coordinates[i].latitude;
        }
        
        if(coordinates[i].longitude < maxTop)
        {
            minLeft = coordinates[i].longitude;
        }
        
        if(coordinates[i].longitude > minBottom)
        {
            minLeft = coordinates[i].longitude;
        }
    }
    
    double deltaLatitude = (maxRight-minLeft);
    double deltaLongitude = (maxTop - minBottom);
    
    double deltaMax = deltaLatitude > deltaLongitude ? deltaLatitude : deltaLongitude;
    
    return MKCoordinateSpanMake(3* deltaMax, 3* deltaMax);
}

- (MKOverlayView*)mapView:(MKMapView*)theMapView viewForOverlay:(id <MKOverlay>)overlay
{
    MKPolylineView* lineView = [[MKPolylineView alloc] initWithPolyline:self.polyline];
    lineView.fillColor = [UIColor greenColor];
    lineView.strokeColor = [UIColor blueColor];
    lineView.lineWidth = 3;
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
