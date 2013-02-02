//
//  ImagePickerViewController.h
//  GarbageCollector
//
//  Created by Student09 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagePickerViewController : UIViewController< UIImagePickerControllerDelegate , UINavigationControllerDelegate>
{

}
@property(nonatomic) IBOutlet UIImageView *imageView;
@property(nonatomic) IBOutlet UIButton *takePictureButton;
@property(nonatomic) IBOutlet UIButton *selectFromCameraRollButton;
-(IBAction)getCameraPicture:(id)sender;
-(IBAction)selectExitingPicture;
@end
