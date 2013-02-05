//
//  InfoViewController.m
//  GarbageCollector
//
//  Created by Student09 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "InfoViewController.h"
#import "GarbageStorage.h"
#import "ShowDepoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

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
    UIBarButtonItem* butt= [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(returnToPreviousScreen)];
    UIBarButtonItem* butt1= [[UIBarButtonItem alloc] initWithTitle:@"FindPath" style:UIBarButtonItemStyleBordered target:self action:@selector(findPath)];
    self.navigationBarItems.rightBarButtonItems = [NSArray arrayWithObjects:butt,butt1 ,nil];
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:16];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    titleView.text=@"Facebook Profile";
    self.navigationBarItems.titleView = titleView;
    [titleView sizeToFit];
    self.navigationBarItems.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"images.jpg"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.infoPicture.image = [UIImage imageNamed:self.garbageSpot.pictureFilename];
    self.addressLabel.text = self.garbageSpot.address;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    NSString *formattedDateString = [dateFormatter stringFromDate:self.garbageSpot.dateCreated];
    self.dateLabel.text = formattedDateString;
    self.descriptionLabel.text=self.garbageSpot.pictureDescription;
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) returnToPreviousScreen
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showDepoSegue"])
    {
        ShowDepoViewController* showDepoVC = segue.destinationViewController;
        showDepoVC.spotDetail = self.garbageSpot;
    }
}

-(void) findPath
{
    [self performSegueWithIdentifier:@"showDepoSegue" sender:self];
}

@end
