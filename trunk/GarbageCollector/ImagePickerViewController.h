//
//  ImagePickerViewController.h
//  GarbageCollector
//
//  Created by Student09 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ImagePickerViewController : UIViewController< UIImagePickerControllerDelegate , UINavigationControllerDelegate, CLLocationManagerDelegate>
{

}
@property(nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic) IBOutlet UIButton *takePictureButton;
@property(nonatomic) IBOutlet UIButton *selectFromCameraRollButton;
-(IBAction)getCameraPicture:(id)sender;
-(IBAction)selectExitingPicture;
@property (weak, nonatomic) IBOutlet UINavigationItem *navigationBarItems;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *addGarbageSpotButton;

@end
