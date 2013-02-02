//
//  ViewController.m
//  GarbageCollector
//
//  Created by Student06 on 1/31/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"Facebook";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"someShittyImageYouMustDownloadFromFacebok"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem* butt= [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToMapScreen)];
    UIBarButtonItem* butt1= [[UIBarButtonItem alloc] initWithTitle:@"Table" style:UIBarButtonItemStyleBordered target:self action:@selector(switchToTableScreen)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
    //set some custom font for the label
	[label setFont:[UIFont fontWithName:@"Helvetica" size:18]];
	[label setBackgroundColor:[UIColor clearColor]];
	[label setTextColor:[UIColor blackColor]];
	[label setText:@"Facebook Profile"];
	[self.navigationController.navigationBar.topItem setTitleView:label];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:butt,butt1 ,nil];
	// Do any additional setup after loading the view, typically from a nib.
    
    //some new comments
    
    //one more comment
    
    //Некви коментариииииииииии......
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}
-(void) switchToTableScreen
{

    
}
-(void) switchToMapScreen
{
    
}
@end
