//
//  GraphView.m
//  DrawDemo
//
//  Created by Ognian.Chirkov on 10/2/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "GraphView.h"

@interface GraphView ()

@property (strong, nonatomic) NSMutableArray *arrayObject;
@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) UIFont *font;
- (void) drawLabel:(NSString *) label atPoint: (CGPoint) point inContext:(CGContextRef) context;
@end

@implementation GraphView
@synthesize arrayObject;

//width of drawing region
int width;

//height of drawing region
int height;

//Offset from borders
int xOffset;
int yOffset;

//Space for labels
int labelOffset;

//offset coeficient from boders
float offsetCo = 0.1;

//drawing rect
CGRect rect;

//line thicknes
int lineWidth=2;

//axis Arrow width
int axisAW = 3;

//axis arrow height
int axisAH = 8;

//diapason of values
int diapason;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect: (CGRect) rect {
    
    NSLog(@"GraphView INITIALIZED!");
    
    //self.data = [NSMutableDictionary dictionaryWithObjects:@[@3,@4,@1,@5,@8,@7,@4] forKeys:@[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"]];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //width in pts; 1pt=2px
    CGContextSetLineWidth(context, lineWidth);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    //our font :)
    self.font = [UIFont fontWithName:@"Helvetica" size:12.0];
    
//    width = self.frame.size.width*(1-offsetCo/2);
//    height = self.frame.size.height*(1-offsetCo/2);
//    
//    xOffset = (self.frame.size.width - width)/2;
//    yOffset = (self.frame.size.height - height)/2;
    
    
    xOffset = self.frame.size.width*(offsetCo/2);
    yOffset = self.frame.size.height*(offsetCo/2);
    
    labelOffset = yOffset;
    
    width = self.frame.size.width - xOffset*2;
    height = self.frame.size.height - labelOffset - yOffset*2;
    
    rect = CGRectMake(xOffset, yOffset, width, height);
    
    
    //temporary array of values; should be recieved as parameter
    char array[[[self.data allValues] count]];//[5+arc4random() % 25];//]={3,4,1,5,8,7,4};
    
    //positions of the lables
    CGPoint labelPoints[sizeof(array)];
    //NSLog(@"sizeof(array): %ld",sizeof(array));
    
    //temporary labels array; should be recieved as parameter
    self.labels = [self.data allKeys];//@[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"];
    
    //min value in array
    int min=99999;
    
    //max value in array
    int max=0;
    
    //random array - debug/test/fun feature ;)
    for (int i=0; i<sizeof(array); i++) {
        //array[i]= arc4random() % 30;
        array[i]= [[self.data valueForKey:[self.labels objectAtIndex:i]] intValue];
        [arrayObject addObject:[NSNumber numberWithInt:array[i]]];
        
        if (array[i] > max) {
            max = array[i];
        }
        
        if (array[i] < min) {
            min = array[i];
        }
        
        NSLog(@"array[%d]=%d",i,array[i]);

    }
    NSLog(@"min: %d max: %d",min,max);
    
    //positions of the lables
    CGPoint graphPoints[sizeof(array)];
    
    //getting the total sum of all array elements
    unsigned int arraySum = 0;
    for (int i=0; i<sizeof(array); i++) {
        arraySum+=array[i];
    }
    
    drawAxis(context, rect);
    
    
    //DEBUG
    min=0;
    
    //getting the range of values
    diapason = abs(max-min);
    NSLog(@"diapason: %d", diapason);
    
    //step incrementation on X axis
    int xStep = (rect.size.width-axisAH)/sizeof(array);
    
    //step incrementation on Y axis
    int yStep = (rect.size.height-axisAH)/diapason;
    
    NSLog(@"xStep: %d yStep: %d", xStep, yStep);
    
    for (int i=0;i<sizeof(array); i++) {

        CGPoint point = CGPointMake(xOffset+xStep*i+xStep/2 ,yOffset+lineWidth+(rect.size.height-yStep*(array[i]-min)));
        drawPoint(context, point, array[i]);
        graphPoints[i] = point;
        labelPoints[i] = CGPointMake(point.x, yOffset + lineWidth + rect.size.height);
    }
    
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    //connecting points
    for (int i=0;i<sizeof(graphPoints)/sizeof(CGPoint)-1; i++) {
    
        drawLine(context, graphPoints[i], graphPoints[i+1]);
        
    }

    //draw Labels
    for (int i=0;i<sizeof(labelPoints)/sizeof(CGPoint); i++) {
        [self drawLabel:[self.labels objectAtIndex:i % self.labels.count]atPoint:labelPoints[i] inContext:context];
    }
    
    
}


void drawAxis(CGContextRef context, CGRect rect){
    
    CGContextBeginPath(context);
    
    //draw X axis
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x, yOffset+rect.size.height);

    //draw X arrow
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x+axisAW, rect.origin.y+axisAH);
    CGContextAddLineToPoint(context, rect.origin.x-axisAW, rect.origin.y+axisAH);
    
    //draw Y axis
    CGContextMoveToPoint(context, rect.origin.x, yOffset+rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width+xOffset, yOffset+rect.size.height);
    
    //draw Y arrow
    CGContextMoveToPoint(context, rect.size.width+xOffset, yOffset+rect.size.height);
    CGContextAddLineToPoint(context, rect.size.width+xOffset-axisAH, yOffset+rect.size.height+axisAW);
    CGContextAddLineToPoint(context, rect.size.width+xOffset-axisAH, yOffset+rect.size.height-axisAW);
    
    //CGContextAddRect(context, rect);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

void drawPoint(CGContextRef context, CGPoint point, int radius){

    NSLog(@"x:%f y:%f", point.x, point.y);
    
    CGContextBeginPath(context);
    
    UIColor *pieceColor = [UIColor colorWithHue:(float)radius / diapason saturation:0.9 brightness:0.9 alpha:1.0];
    
    float hue = (float)radius/diapason;
    
    NSLog(@"%f" , hue);
    
    CGContextSetFillColorWithColor(context, pieceColor.CGColor);
    
    CGContextAddArc(context, point.x, point.y-lineWidth, lineWidth+radius/3, 0.0, 360.0, 0);
    
    CGContextDrawPath(context, kCGPathFillStroke);

}

void drawLine(CGContextRef context, CGPoint point, CGPoint nextPoint){

    CGContextSetLineWidth(context, 0.7);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, point.x, point.y-lineWidth);
    CGContextAddLineToPoint(context, nextPoint.x, nextPoint.y-lineWidth);
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextSetLineWidth(context, lineWidth);

}

- (void) drawLabel:(NSString *) label atPoint: (CGPoint) point inContext:(CGContextRef) context {
    
    CGContextBeginPath(context);
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextMoveToPoint(context, point.x, point.y-lineWidth*2);
    CGContextAddLineToPoint(context, point.x, point.y+lineWidth*2);
    
    int center = [label sizeWithFont:self.font].width/2;
    
    CGPoint labelPoint = CGPointMake(point.x-center, point.y+lineWidth*2);
    if (self.data.count <8) {
        [label drawAtPoint:labelPoint withFont:self.font];
    }

    
    CGContextDrawPath(context, kCGPathFillStroke);
    
}

- (IBAction)random:(id)sender {
    
    [self setNeedsDisplay];
}



@end
