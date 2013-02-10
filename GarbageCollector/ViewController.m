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
#import "AppDelegate.h"
#import "DataGenerator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    DataGenerator* gen = [[DataGenerator alloc] init];
//    [gen generate];
    
	// Do any additional setup after loading the view, typically from a nib.
   
//Moved to updateUI
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 30)];
//    //set some custom font for the label
//	[label setFont:[UIFont fontWithName:@"Helvetica" size:18]];
//	[label setBackgroundColor:[UIColor clearColor]];
//	[label setTextColor:[UIColor blackColor]];
//	[label setText:[(AppDelegate *)[[UIApplication sharedApplication] delegate] userName]];
//	[self.navigationController.navigationBar.topItem setTitleView:label];
    
    
    
    
//Moved to updateUI
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[(AppDelegate *)[[UIApplication sharedApplication] delegate] profilePicture] style:UIBarButtonItemStylePlain target:self action:nil];
    [self.activityIndicator startAnimating];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI:) name:@"pictureDownloaded" object:nil];
    
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

-(void)updateUI: (NSNotification *) not{
  
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
    [self.activityIndicator stopAnimating];
    [self.activityIndicator setHidden:YES];
    [self.activityIndicatorText setHidden:YES];
    self.tableViewButton.enabled=YES;
    self.mapViewButton.enabled=YES;
    self.statisticsButton.enabled=YES;
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

//-(void)getProfileInfo{
//    
//    ACAccountStore *acc = [ACAccountStore new];
//    ACAccountType *accType = [acc accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
//    
//    
//    [acc requestAccessToAccountsWithType:accType options:nil completion:^(BOOL granted, NSError *err){
//        
//        if (granted == YES) {
//            NSArray *accArray = [acc accountsWithAccountType:accType];
//            ACAccount *twAcc = [accArray lastObject];
//            
//            NSString *userID = [[twAcc valueForKey:@"properties"] valueForKey:@"user_id"];
//            
//            //NSLog(@"USER_ID: %@",userID);
//            
//            NSURL *reqURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
//            
//            NSDictionary  *params = @{@"user_id":userID};
//            
//            SLRequest *userInfoReq = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:reqURL parameters:params];
//            
//            userInfoReq.account = twAcc;
//            [userInfoReq performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *err){
//                
//                //NSLog(@"Posting done!");
//                //NSLog(@"Response: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
//                //NSLog(@"urlResponse %d: %@",[urlResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[urlResponse statusCode]]);
//                //NSLog(@"NSdata: %@", NSHTTPURLResponse);
//                
//                //NSError *err = nil;
//                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error: &err];
//                
//                self.userName = twAcc.username;
//                self.profilePicture = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:jsonObject[@"profile_image_url"]]]];
//                NSLog(@"User info - done!");
//                
//            }];
//        }
//        
//        
//    }];
//    
//}

- (IBAction)switchToMapScreen:(id)sender {
    [self performSegueWithIdentifier:@"gotoMapScreen" sender:self];
}
- (IBAction)switchToTableScreen:(id)sender {
    [self performSegueWithIdentifier:@"gotoTableScreen" sender:self];
}
@end
