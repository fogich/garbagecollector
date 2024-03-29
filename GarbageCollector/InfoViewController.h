//
//  InfoViewController.h
//  GarbageCollector
//
//  Created by Student09 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GarbageSpot.h"
@protocol InfoModalDelegate
- (void) cleanObject:(GarbageSpot*) garbageSpot;
@end
@interface InfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *infoPicture;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarItems;
@property (nonatomic) GarbageSpot* garbageSpot;
@property (nonatomic) id<InfoModalDelegate> delegate;
@end