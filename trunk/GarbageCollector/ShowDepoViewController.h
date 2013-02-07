//
//  ShowDepoViewController.h
//  GarbageCollector
//
//  Created by Student06 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "GarbageSpot.h"
#import <MessageUI/MessageUI.h>

@interface ShowDepoViewController : UIViewController<MKMapViewDelegate, MFMailComposeViewControllerDelegate>

@property (nonatomic, retain) GarbageSpot* spotDetail;

@end
