//
//  MainTableViewController.h
//  GarbageCollector
//
//  Created by Student09 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GarbageSpot.h"
@interface MainTableViewController : UITableViewController
- (void) deleteObject:(GarbageSpot*) garbageSpot;

@end
