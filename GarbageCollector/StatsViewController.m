//
//  StatsViewController.m
//  GarbageCollector
//
//  Created by Student06 on 2/11/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "StatsViewController.h"
#import "DrawView.h"
#import "AppDelegate.h"
#import "GraphView.h"

@interface StatsViewController ()
@property (weak, nonatomic) IBOutlet UIView *graphicsView;
- (IBAction)monthClick:(id)sender;
- (IBAction)weekClick:(id)sender;
- (IBAction)topClick:(id)sender;

@property (strong, nonatomic) NSTimer *aTimer;
@property (strong, nonatomic) NSMutableDictionary *finalData;
@property (strong, nonatomic) NSMutableDictionary *currentData;

@end

@implementation StatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
//        self.finalData = [NSMutableDictionary new];
//        self.currentData = [NSMutableDictionary new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
    

}

-(void)viewDidAppear:(BOOL)animated{

    //
    self.finalData = [NSMutableDictionary new];
    self.currentData = [NSMutableDictionary new];
    [self defaultStat];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//NSTimer *aTimer = [NSTimer scheduledTimerWithTimeInterval: 2.0
//                                                   target: self
//                                                 selector:@selector(onTick:)
//                                                 userInfo: nil repeats:YES];
//




-(void)defaultStat{

    [self weekClick:nil];
    //[self animate];

}
- (IBAction)animate:(id)sender {


    self.aTimer = [NSTimer scheduledTimerWithTimeInterval: 0.01 target: self selector:@selector(onTick:) userInfo: nil repeats:YES];

    NSArray *labels = @[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"];
    
    for (NSString *str in labels) {
        
        [self.finalData setValue:@(arc4random() % 10) forKey:str];
        [self.currentData setValue:@0 forKey:str];

    }


}

-(void)onTick:(NSTimer *)timer {
    //This is where you need to set your stuff
    
    CGRect frame = CGRectMake(0, 0, self.graphicsView.frame.size.width, self.graphicsView.frame.size.height);
    
    GraphView *monthlyView = [[GraphView alloc] initWithFrame:frame];


    for (NSString *str in [self.finalData allKeys]) {
        
        NSLog(@"Str: %@ Current: %@  =? Final: %@", str,[self.currentData valueForKey:str] , [self.finalData valueForKey:str]);
        
        if ([[self.currentData valueForKey:str] intValue] < [[self.finalData valueForKey:str] intValue]) {
            NSNumber *val = [NSNumber numberWithInt:[[self.currentData valueForKey:str] intValue]+1];
            [self.currentData setValue:val forKey:str];
        }
        
    }
    
    
    monthlyView.data = self.currentData;
    monthlyView.backgroundColor = [UIColor whiteColor];
    
    if ([self.graphicsView.subviews count] > 0) {
        [[self.graphicsView.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    [self.graphicsView addSubview: monthlyView];
    [monthlyView setNeedsDisplay];
    
    NSLog(@"Current data(onTick): %@", self.currentData);
    NSLog(@"Final data(onTick): %@", self.finalData);
    
    if ([self.currentData isEqualToDictionary:self.finalData]) {
        [timer invalidate];
    }
    
}

-(void) returnToPreviousScreen
{
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)monthClick:(id)sender {
    
    CGRect frame = CGRectMake(0, 0, self.graphicsView.frame.size.width, self.graphicsView.frame.size.height);
    
    GraphView *monthlyView = [[GraphView alloc] initWithFrame:frame];

    NSMutableDictionary *randomData = [[NSMutableDictionary alloc] init];
    for (int i=0; i < 30; i++) {
        [randomData setValue: @(arc4random() % 30) forKey: [NSString stringWithFormat:@"%d",(arc4random() % 100)]];
    }

    monthlyView.data = randomData;
    monthlyView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@",[self.graphicsView subviews]);
    
    if ([self.graphicsView.subviews count] > 0) {
        [[self.graphicsView.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    [self.graphicsView addSubview: monthlyView];
    [monthlyView setNeedsDisplay];
    NSLog(@"Monthly");
    
    NSLog(@"%@", randomData);
    
}

- (IBAction)weekClick:(id)sender {
    
    CGRect frame = CGRectMake(0, 0, self.graphicsView.frame.size.width, self.graphicsView.frame.size.height);
    GraphView *weeklyView = [[GraphView alloc] initWithFrame:frame];
   
    
    NSArray *labels = @[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"];
    
    NSMutableDictionary *randomData = [[NSMutableDictionary alloc] init];
    for (NSString *str in labels) {
        [randomData setValue:@(arc4random() % 10) forKey:str];
    }
    
    weeklyView.data = randomData;
    weeklyView.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%@",[self.graphicsView subviews]);
    
    if ([self.graphicsView.subviews count] > 0) {
        [[self.graphicsView.subviews objectAtIndex:0] removeFromSuperview];
    }
    
    [self.graphicsView addSubview: weeklyView];
    [weeklyView setNeedsDisplay];
    
    NSLog(@"Top");
    
    NSLog(@"%@", randomData);
}

- (IBAction)topClick:(id)sender {
    
    CGRect frame = CGRectMake(0, 0, self.graphicsView.frame.size.width, self.graphicsView.frame.size.height);
    DrawView *topView = [[DrawView alloc] initWithFrame:frame];
    //temporary labels array; should be recieved as parameter
    NSArray *labels = @[@"Centar",@"Mladost",@"Liulin",@"Ovcha Kupel",@"Levski",@"Vitosha",@"Ilienci"];//[self.data allKeys];
    NSMutableDictionary *randomData = [[NSMutableDictionary alloc] init];
    for (NSString *str in labels) {
        [randomData setValue:@(arc4random() % 10) forKey:str];
    }
    
    topView.data = randomData;
    topView.backgroundColor = [UIColor whiteColor];
    NSLog(@"%@",[self.graphicsView subviews]);
    
    NSLog(@"count: %u", [self.graphicsView.subviews count]);
        
    if ([self.graphicsView.subviews count] > 0) {
         [[self.graphicsView.subviews objectAtIndex:0] removeFromSuperview];
    }
    

    
    [self.graphicsView addSubview: topView];
    //[monthlyView drawRect:nil];
    [topView setNeedsDisplay];

    NSLog(@"Top");
    
    NSLog(@"%@", randomData);
    
}
@end
