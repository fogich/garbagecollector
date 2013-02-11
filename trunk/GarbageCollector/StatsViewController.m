//
//  StatsViewController.m
//  GarbageCollector
//
//  Created by Student06 on 2/11/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "StatsViewController.h"
#import "DrawView.h"
#import "AppDelegate.h"

@interface StatsViewController ()
@property (weak, nonatomic) IBOutlet DrawView *graphicsView;
- (IBAction)monthClick:(id)sender;
- (IBAction)weekClick:(id)sender;
- (IBAction)topClick:(id)sender;


@end

@implementation StatsViewController

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
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(returnToPreviousScreen)];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:backButton];
    self.navigationItem.hidesBackButton=YES;
    UIView *myView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.window.bounds.size.width, 30)];
    UILabel *title = [[UILabel alloc] initWithFrame: CGRectMake((self.view.window.bounds.size.width/2)-40, 0, 160, 30)];
    title.text = [(AppDelegate *)[[UIApplication sharedApplication] delegate] userName];
    [title setTextColor:[UIColor blackColor]];
    [title setFont:[UIFont boldSystemFontOfSize:16.0]];
    [title setBackgroundColor:[UIColor clearColor]];
    UIImage *image = [(AppDelegate *)[[UIApplication sharedApplication] delegate] profilePicture];
    UIImageView *myImageView = [[UIImageView alloc] initWithImage:image];
    myImageView.frame = CGRectMake((self.view.window.bounds.size.width/2)-80, 0, 30, 30);
    [myView addSubview:title];
    [myView setBackgroundColor:[UIColor  clearColor]];
    [myView addSubview:myImageView];
    self.navigationItem.titleView = myView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)monthClick:(id)sender {
}

- (IBAction)weekClick:(id)sender {
}

- (IBAction)topClick:(id)sender {
}
@end
