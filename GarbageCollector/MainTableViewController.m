//
//  MainTableViewController.m
//  GarbageCollector
//
//  Created by Student09 on 2/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "MainTableViewController.h"
#import "MainCell.h"
#import "ViewController.h"
#import "GarbageStorage.h"
#import "InfoViewController.h"
#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface MainTableViewController ()<InfoModalDelegate>
@property(nonatomic) AVAudioPlayer *audioPlayer;
@property(nonatomic) NSMutableArray* tableArray;
@end

@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    //set some custom font for the label

    UIBarButtonItem* butt= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addItem)];
    UIBarButtonItem* butt1= [[UIBarButtonItem alloc] initWithTitle:@"Map" style:UIBarButtonItemStyleBordered target:self action:@selector(switchScreen)];
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:butt,butt1 ,nil];
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemReply target:self action:@selector(returnToPreviousScreen)];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:backButton];
    self.navigationItem.hidesBackButton=YES;
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
    self.tableArray=[NSMutableArray arrayWithArray: [[GarbageStorage instance] allGarbageSpots]];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void) returnToPreviousScreen
{
    [self.navigationController popToRootViewControllerAnimated:NO];
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
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MainCell";
    MainCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    GarbageSpot* currentSpot = [self.tableArray objectAtIndex:indexPath.row];
    //cell.cellPicture.image=[UIImage imageNamed:currentSpot.pictureFilename];
    cell.cellText.text=currentSpot.pictureDescription;
    cell.cellPicture.image=[UIImage imageWithContentsOfFile:currentSpot.pictureFilename];
    if(currentSpot.dateCleaned!=nil)
        cell.checkMarkImage.alpha=1;
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(void) buttonClicked
{
    [self performSegueWithIdentifier:@"seeStats" sender:self];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:@"fullInfo" sender:indexPath];
}
- (void) cleanObject:(GarbageSpot*) garbageSpot;
{
    self.tableArray=[NSMutableArray arrayWithArray: [[GarbageStorage instance] allGarbageSpots]];
    [self.tableView reloadData];
    NSURL *url= [[NSBundle mainBundle] URLForResource:@"empty_trash" withExtension:@"aif"];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if(error)
        NSLog(@"Error in audio play");
    self.audioPlayer.numberOfLoops = 0;
    [self.audioPlayer play];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{   if([segue.identifier isEqualToString:@"fullInfo"])
    {
        NSIndexPath* indexPath=(NSIndexPath*) sender;
        InfoViewController* mvc = segue.destinationViewController;
        mvc.garbageSpot=[self.tableArray objectAtIndex:indexPath.row];
        mvc.delegate = self;
    }
}
-(void) viewWillAppear:(BOOL)animated
{
    self.tableArray=[NSMutableArray arrayWithArray: [[GarbageStorage instance] allGarbageSpots]];
    [self.tableView reloadData];
}
@end
