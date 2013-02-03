//
//  DrawView.m
//  DrawDemo
//
//  Created by Ognian.Chirkov on 17/1/13.
//  Copyright (c) 2013 MMAcademy. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView

//what part of the circle has been drawn so far
//coordinates of the last point in the last drawn arc
CGPoint currentPointInArc;

//coordinates of the midle point in the last drawn arc
//where the label should be drawn
CGPoint currentLabelPoint;

//coords of the center of the circle
CGPoint circleCenter;

//radius of the circle
char radius = 120;

//offset from upper and left border of the screen
char borderOffset = 40;

//what part of the circle has been drawn so far
//angle in RAD
//Starting from North position, therefore we need to initialize with -M_PI/2
CGFloat currentAngle = -M_PI/2;

//fill color of the curent piece
UIColor *pieceColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)drawRect: (CGRect) rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //width in pts; 1pt=2px
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    
    //positioning the pie chart
    circleCenter = CGPointMake(borderOffset+radius, borderOffset+radius);
    
    //starting to draw from circle center towards North
    //Y coord is inverted, therefore we don't add, but substract radius
    currentPointInArc = CGPointMake(circleCenter.x, circleCenter.y-radius);

    //temporary array of values; should be recieved as parameter
    char array[]={3,4,1,5,8,7,4};
    
    //positions of the lables
    CGPoint labelPoints[7];
    //NSLog(@"sizeof(array): %ld",sizeof(array));
    
    //temporary labels array; should be recieved as parameter
    NSArray *labels = @[@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"];
    
    //random array - debug/test/fun feature ;)
    for (int i=0; i<sizeof(array)-1; i++) {
        array[i]= arc4random() % 10;
        //NSLog(@"array[%d]=%d",i,array[i]);
    }
    
    //good example of problematic array with narrow pieces where similar colors merge
    //array[] = {6,4,1,4,9,5,3};

    
    //NSLog(@"Size of array: %ld", sizeof(array));
    
    //getting the total sum of all array elements
    unsigned int arraySum = 0;
    for (int i=0; i<sizeof(array)-1; i++) {
        arraySum+=array[i];
    }
    
    //start drawing the pie chart piece by piece
    for (int i=0; i<sizeof(array)-1; i++) {
        
        //how many % is the current piece? In fraction of 1.0
        float fraction = (float)array[i]/(float)arraySum;
        //NSLog(@"fraction: %f", fraction);

        //dividing the rainbow in N equal pieces, N=sizeOfArray
        //setting the current piece its respective color
        CGFloat hue = 1.0/sizeof(array)*i;
        
        //MAGIC!!! Can't touch this! :)
        //basically alternating brighter and darker settings for the...
        //...adjacent pieces, so we could get more contrast
        float saturation = 0.9+0.2*powf(-1.0, i);
        float brightness = 0.8+0.1*powf(-1.0, i+1);

        //NSLog(@"Hue:        %f",hue);
        //NSLog(@"Sat:        %f",saturation);
        //NSLog(@"Brightness: %f",saturation);
        
        //actually initalizing the PERFECT color for our current piece
        //converting from UIColor to CGColor, cause the later doesn't have HSB color space
        pieceColor = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0];

        CGContextSetFillColorWithColor(context, pieceColor.CGColor);
        
        
        
        //actually drawing the current piece, see method for details
        drawPiece(context, circleCenter, radius, currentAngle, M_PI*2*fraction+currentAngle, 0);
        
        //saving lable points for later use
        labelPoints[i]=currentLabelPoint;
        //NSLog(@"sizeof(labelPoints): %ld",sizeof(<#expression-or-type#>));
        
        //updateing the current angle
        currentAngle = M_PI*2*fraction+currentAngle;
        
    }
    
    for (int i=0; i<sizeof(labelPoints)/8; i++) {
        //how many % is the current piece? In fraction of 1.0
        float percentage = 100.0*(float)array[i]/(float)arraySum;
        //NSLog(@"fraction: %f", fraction);
        
        //set black color for text
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        
        NSString *label = [NSString stringWithFormat:@"%@ - %.2f %%", [labels objectAtIndex:i], percentage];
        
        [label drawAtPoint:labelPoints[i] withFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
        
    }
    
    // smiley
//    drawCircle(context, 140, 140, 120, 0, M_PI*2, 1);
//    drawCircle(context, 100, 100, 20, 0, M_PI*2, 1);
//    drawCircle(context, 180, 100, 20, 0, M_PI*2, 1);
//    drawCircle(context, 140, 140, 90, 0, M_PI, 0);
    
}

void  drawPiece(CGContextRef c, CGPoint center, CGFloat r, CGFloat sa, CGFloat ea, int cl){
    
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, circleCenter.x, circleCenter.y);
    CGContextAddLineToPoint(c, currentPointInArc.x, currentPointInArc.y);
    CGContextAddArc(c, center.x, center.y, r, sa, sa+fabsf((sa-ea)/2), cl);
    
    //NSLog(@"\nsa: %f sa+fabsf((sa-ea)/2):%f ea: %f",sa,sa+fabsf((sa-ea)/2),ea);
    
    currentLabelPoint = CGContextGetPathCurrentPoint(c);
    //NSLog(@"labelPoint: %f %f",currentLabelPoint.x, currentLabelPoint.y);
    
    //set black color for text
    //CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    //[@"label" drawAtPoint:currentPointInArc withFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    
    //get back to pieceColor
    //CGContextSetFillColorWithColor(c, pieceColor.CGColor);
    
    CGContextAddArc(c, center.x, center.y, r, sa+fabsf((sa-ea)/2), ea, cl);
    currentPointInArc = CGContextGetPathCurrentPoint(c);
    CGContextAddLineToPoint(c, circleCenter.x, circleCenter.y);
    CGContextDrawPath(c, kCGPathFillStroke);
}


void  drawLabel(CGContextRef c, CGPoint center, CGFloat r, CGFloat sa, CGFloat ea, int cl){
    
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, circleCenter.x, circleCenter.y);
    CGContextAddLineToPoint(c, currentPointInArc.x, currentPointInArc.y);
    CGContextAddArc(c, center.x, center.y, r, sa, sa+fabsf((sa-ea)/2), cl);
    
    NSLog(@"\nsa: %f sa+fabsf((sa-ea)/2):%f ea: %f",sa,sa+fabsf((sa-ea)/2),ea);
    
    currentPointInArc = CGContextGetPathCurrentPoint(c);
    
    //set black color for text
    CGContextSetFillColorWithColor(c, [UIColor blackColor].CGColor);
    [@"label" drawAtPoint:currentPointInArc withFont:[UIFont fontWithName:@"Helvetica" size:12.0]];
    
    //get back to pieceColor
    CGContextSetFillColorWithColor(c, pieceColor.CGColor);
    
    CGContextAddArc(c, center.x, center.y, r, sa+fabsf((sa-ea)/2), ea, cl);
    currentPointInArc = CGContextGetPathCurrentPoint(c);
    CGContextAddLineToPoint(c, circleCenter.x, circleCenter.y);
    CGContextDrawPath(c, kCGPathFillStroke);
}




//void  drawCircle(CGContextRef c, CGFloat x, CGFloat y, CGFloat r, CGFloat sa, CGFloat ea, int cl){
//
//    CGContextBeginPath(c);
//    CGContextAddArc(c, x, y, r, sa, ea, cl);
//    CGContextDrawPath(c, kCGPathStroke);
//}

@end
