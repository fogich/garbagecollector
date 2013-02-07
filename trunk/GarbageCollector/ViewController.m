//
//  ViewController.m
//  GarbageCollector
//
//  Created by Student06 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewController.h"
#import "GarbageStorage.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    //set some custom font for the label
	[label setFont:[UIFont fontWithName:@"Helvetica" size:18]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor blackColor]];
	[label setText:@"Facebook Profile"];
	[self.navigationController.navigationBar.topItem setTitleView:label];
    UIBarButtonItem* butt= [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToMapScreen)];
    UIBarButtonItem* butt1= [[UIBarButtonItem alloc] initWithTitle:@"Table" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToTableScreen)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:butt,butt1 ,nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"image.jpg"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    
    
    //test
    //[[GarbageStorage instance] allGarbageSpots];
//    GarbageStorage* storage = [GarbageStorage instance];
//    NSArray* garbageSpots = [storage allGarbageSpots];
//
//    for(int i = 0; i < garbageSpots.count; i++)
//    {
//        GarbageSpot* spot = [garbageSpots objectAtIndex:i];
//        NSLog(@"%@", spot.address);
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) switchToMapScreen
{
    [self performSegueWithIdentifier:@"gotoMapScreen" sender:self];
}
-(void) switchToTableScreen
{
    [self performSegueWithIdentifier:@"gotoTableScreen" sender:self];
}

@end
