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
#import <CoreGraphics/CoreGraphics.h>
#import <QuartzCore/QuartzCore.h>

@interface ShowDepoViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *map;
@property (nonatomic, retain) MKPolyline* polyline;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UITextView *depoDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIView *mapCoverLayer;
@property GarbageDepo* depo;

- (IBAction)closeScreen:(id)sender;
- (IBAction)sendMail:(id)sender;


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
    self.map.delegate = self;
    self.mapCoverLayer.hidden = FALSE;
    [self.activityIndicator startAnimating];
    
    GarbageSpotPinAnnotation* p = [[GarbageSpotPinAnnotation alloc] init];
    p.garbageSpot = self.spotDetail;
    [self.map addAnnotation: p];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector: @selector(garbageDepoReadyNotification:) name: @"GarbageDepoReady" object:nil];
    [center addObserver:self selector: @selector(polylineReadyNotification:) name: @"PolylineReady" object:nil];
    
    CLLocationCoordinate2D startLocationCoordinate = CLLocationCoordinate2DMake([self.spotDetail.location.latitude doubleValue], [self.spotDetail.location.longitude doubleValue]);
    [[[GarbageDepoService alloc] init] getNearestGarbageDepoFromPoint:startLocationCoordinate];
}

-(void)garbageDepoReadyNotification:(NSNotification *) notification
{
    GarbageDepo* nearestDepo = [notification.userInfo objectForKey:@"depo"];
    self.depo = nearestDepo;
    self.depoDescriptionTextView.text = nearestDepo.aDescription;
    self.phoneLabel.text = [NSString stringWithFormat:@"  Phone: %@", nearestDepo.phone];
    
    CLLocationCoordinate2D startLocationCoordinate = CLLocationCoordinate2DMake([self.spotDetail.location.latitude doubleValue], [self.spotDetail.location.longitude doubleValue]);
    CLLocationCoordinate2D endLocationCoordinate = CLLocationCoordinate2DMake(nearestDepo.latitude, nearestDepo.longitude);
    [[[GoogleDirectionsService alloc] init] getKeyLocationsBetweenPointA: startLocationCoordinate pointB: endLocationCoordinate];
    
    DepoPinAnnotation* p1 = [[DepoPinAnnotation alloc] init];
    p1.garbageDepo = nearestDepo;
    [self.map addAnnotation: p1];
}

-(void)polylineReadyNotification:(NSNotification *) notification
{
    self.polyline = [notification.userInfo objectForKey:@"polyline"];
    [self.map addOverlay:self.polyline];
    
    MKCoordinateSpan span = [self findGeographicalRect:self.polyline];
    self.map.region = MKCoordinateRegionMake(self.polyline.coordinate, span);
    
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = TRUE;
    self.mapCoverLayer.hidden = TRUE;
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
    
    return MKCoordinateSpanMake(2* deltaMax, 2* deltaMax);
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
            pinView.pinColor=MKPinAnnotationColorPurple;
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

- (IBAction)closeScreen:(id)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)sendMail:(id)sender {
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"garbage report"];
        NSArray *toRecipients = [NSArray arrayWithObject:self.depo.email];
        [mailer setToRecipients:toRecipients];
        
        //take a screenshot of the map view
        UIGraphicsBeginImageContext(CGSizeMake(self.map.bounds.size.width,self.map.bounds.size.height));
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.map.layer renderInContext:context];
        UIImage *screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        NSData *imageData = UIImagePNGRepresentation(screenShot);
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"location"];
        
        NSString *emailBody = [NSString stringWithFormat: @"<div>We have found and packed some garbage. It is located at <b>%@</b>. Please come to pick it up.<div>", self.spotDetail.location.address];
        [mailer setMessageBody:emailBody isHTML:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [controller dismissViewControllerAnimated:NO completion:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver: self];
}

@end
