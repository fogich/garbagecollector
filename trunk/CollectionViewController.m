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
#import "InfoViewController.h"
#import "ViewController.h"
#import "AppDelegate.h"
@interface CollectionViewController ()<InfoModalDelegate>
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
    self.garbageArray=[NSMutableArray arrayWithArray: [[GarbageStorage instance] allGarbageSpots]];
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) addItem
{
    [self performSegueWithIdentifier:@"newGarbageSpot" sender:self];
}
-(void) switchScreen
{
    ViewController* mvc = self.navigationController.viewControllers[0];
    [self.navigationController popToRootViewControllerAnimated:NO];
    [mvc switchToMapScreen];
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"fullInfo" sender:indexPath];
}
- (void) cleanObject:(GarbageSpot*) garbageSpot;
{
    garbageSpot.dateCleaned=[NSDate dateWithTimeIntervalSinceNow:0];
    // self.tableArray=[NSMutableArray arrayWithArray: [[GarbageStorage instance] allGarbageSpots]];
    [self.collectionView reloadData];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{   if([segue.identifier isEqualToString:@"fullInfo"])
    {
        NSIndexPath* indexPath=(NSIndexPath*) sender;
        InfoViewController* mvc = segue.destinationViewController;
        mvc.garbageSpot=[self.garbageArray objectAtIndex:indexPath.row];
        mvc.delegate = self;
    }
}
-(void) viewDidAppear:(BOOL)animated
{
    self.garbageArray=[NSMutableArray arrayWithArray: [[GarbageStorage instance] allGarbageSpots]];
    [self.collectionView reloadData];
}
@end
