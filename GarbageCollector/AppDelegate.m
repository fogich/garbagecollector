//
//  AppDelegate.m
//  GarbageCollector
//
//  Created by Student06 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "AppDelegate.h"
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@implementation AppDelegate
@synthesize userName, profilePicture;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self getProfileInfo];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)getProfileInfo{
    
    ACAccountStore *acc = [ACAccountStore new];
    ACAccountType *accType = [acc accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    [acc requestAccessToAccountsWithType:accType options:nil completion:^(BOOL granted, NSError *err){
        
        if (granted == YES) {
            NSArray *accArray = [acc accountsWithAccountType:accType];
            ACAccount *twAcc = [accArray lastObject];
            
            NSString *userID = [[twAcc valueForKey:@"properties"] valueForKey:@"user_id"];
            
            //NSLog(@"USER_ID: %@",userID);
            
            NSURL *reqURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
            
            NSDictionary  *params = @{@"user_id":userID};
            
            SLRequest *userInfoReq = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:reqURL parameters:params];
            
            userInfoReq.account = twAcc;
            [userInfoReq performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *err){
                
                //NSLog(@"Posting done!");
                //NSLog(@"Response: %@", [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
                //NSLog(@"urlResponse %d: %@",[urlResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[urlResponse statusCode]]);
                //NSLog(@"NSdata: %@", NSHTTPURLResponse);
                
                //NSError *err = nil;
                NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error: &err];
                
                self.userName = twAcc.username;
                self.profilePicture = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:jsonObject[@"profile_image_url"]]]];
                
                dispatch_async(dispatch_get_main_queue(), ^(void){
                    //Update UI here
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pictureDownloaded" object:self userInfo:nil];
                });
                NSLog(@"User info - done!");
                
            }];
        }
        
        
    }];
    
}


@end
