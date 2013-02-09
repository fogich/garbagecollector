//
//  CollectionViewController.m
//  GarbageCollector
//
//  Created by Student09 on 2/8/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "CollectionViewController.h"
#import "GarbageSpot.h"
#import "GarbageStorage.h"
#import "MainCollectionCell.h"
@interface CollectionViewController ()
@property (nonatomic) NSArray* garbageArray;
@end

@implementation CollectionViewController

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
    UIBarButtonItem* butt= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    UIBarButtonItem* butt1= [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(switchScreen)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:butt,butt1 ,nil];
    UILabel * titleView = [[UILabel alloc] initWithFrame:CGRectZero];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont fontWithName:@"Helvetica" size:16];
    titleView.shadowOffset = CGSizeMake(0.0f, 1.0f);
    titleView.textColor = [UIColor blackColor]; // Your color here
    titleView.text=@"Facebook Profile";
    self.navigationItem.titleView = titleView;
    [titleView sizeToFit];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"images.jpg"] style:UIBarButtonItemStylePlain target:self action:nil];
    
    self.garbageArray=[NSMutableArray arrayWithArray: [[GarbageStorage instance] allGarbageSpots]];
	// Do any additional setup after loading the view.
}
-(void) addItem
{
    [self performSegueWithIdentifier:@"newGarbageSpot" sender:self];
}
-(NSInteger)numberOfSectionsInCollectionView:
(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.garbageArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                 cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MainCollectionCell *myCell = [collectionView
                                    dequeueReusableCellWithReuseIdentifier:@"MainCollectionCell"
                                    forIndexPath:indexPath];
    
    GarbageSpot* currentSpot = [self.garbageArray objectAtIndex:indexPath.row];
    myCell.cellImage.image=[UIImage imageNamed:@"Kaci.jpg"];
    myCell.cellText.text=currentSpot.pictureDescription;
    if(currentSpot.dateCleaned!=nil)
    {
        [myCell.greenCheckmarkImage setHidden:NO];
        [myCell.cleanedTextIdentifier setHidden:NO];
    }
    
    return myCell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end