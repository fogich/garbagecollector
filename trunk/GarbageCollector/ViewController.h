//
//  ViewController.h
//  GarbageCollector
//
//  Created by Student06 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *activityIndicatorText;
@property (weak, nonatomic) IBOutlet UIButton *tableViewButton;
@property (weak, nonatomic) IBOutlet UIButton *mapViewButton;
@property (weak, nonatomic) IBOutlet UIButton *statisticsButton;
-(IBAction) switchToTableScreen:(id)sender;
-(IBAction) switchToMapScreen:(id)sender;
-(void) switchToMapScreen;
-(void) switchToTableScreen;
@end
