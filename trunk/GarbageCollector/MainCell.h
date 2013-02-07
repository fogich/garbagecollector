//
//  MainCell.h
//  GarbageCollector
//
//  Created by Student09 on 2/5/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellPicture;
@property (weak, nonatomic) IBOutlet UILabel *cellText;
@property (weak, nonatomic) IBOutlet UIImageView *checkMarkImage;

@end
