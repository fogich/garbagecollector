//
//  MainCollectionCell.h
//  GarbageCollector
//
//  Created by Student09 on 2/8/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellImage;
@property (weak, nonatomic) IBOutlet UILabel *cellText;
@property (weak, nonatomic) IBOutlet UIImageView *greenCheckmarkImage;
@property (weak, nonatomic) IBOutlet UILabel *cleanedTextIdentifier;

@end
