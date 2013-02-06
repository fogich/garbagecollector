//
//  ShowDepoViewController.m
//  GarbageCollector
//
//  Created by Student06 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "ShowDepoViewController.h"
#import "GarbageSpotPinAnnotation.h"
#import "GoogleDirectionsService.h"
#import "GarbageDepoService.h"
#import "DepoPinAnnotation.h"

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
            GarbageSpotPinAnnotation* p = [[GarbageSpotPinAnnotation alloc] init];
            p.garbageSpot = self.spotDetail;
            [annots addObject: p];
            
            DepoPinAnnotation* p1 = [[DepoPinAnnotation alloc] init];
            p1.garbageDepo = nearestDepo;
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
    MKPinAnnotationView* pinView = nil;
    
    if([annotation isKindOfClass:[GarbageSpotPinAnnotation class]])
    {
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"garbageAnnotationView"];
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"garbageAnnotationView"];
            pinView.canShowCallout = YES;
        }
        else
        {
            GarbageSpotPinAnnotation* garbageAnnotation = (GarbageSpotPinAnnotation*)annotation;
            pinView.annotation = garbageAnnotation;
        }
    }
    else //class depopinannotation
    {
        pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"depoAnnotationView"];
        if (!pinView) {
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"depoAnnotationView"];
            pinView.canShowCallout = YES;
            pinView.pinColor=MKPinAnnotationColorGreen;
        }
        else
        {
            DepoPinAnnotation* depoPinAnnotation = (DepoPinAnnotation*)annotation;
            pinView.annotation = depoPinAnnotation;
        }
    }
    
    return pinView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
