//
//  PGShutterView.m
//  PGBiasViewDemo
//
//  Created by PinGuo on 15/5/9.
//  Copyright (c) 2015年 PinGuo. All rights reserved.
//

#import "PGShutterView.h"

#define kViewSize 70
#define kOuterCircleWidth 3
#define kOuterCircleRadius (kViewSize/2 - kOuterCircleWidth/2 - 1)
#define kInnerClipCircleRadius (kViewSize/2 - kOuterCircleWidth - 3)

CGPoint points[12];

CGPoint theInsertPoint(CGPoint p1, CGPoint p2, CGFloat s)
{
    CGFloat p = s/(kViewSize/2);
    return CGPointMake((p2.x-p1.x)/p + p1.x, (p2.y-p1.y)/p + p1.y);
}

void setAllPoints(CGPoint center, CGFloat s)
{
    CGPoint a[6], b[6];
    int i;
    for (i = 0; i < 6; i++)
    {
        a[i] = CGPointMake(center.x + s * cos(M_PI/3 * i), center.y + s * sin(M_PI/3 * i));
    }
    for (i = 0; i < 6; i++)
    {
        if (i != 5)
        {
            b[i] = theInsertPoint(a[i], a[i+1], s);
        }
        else
        {
            b[i] = theInsertPoint(a[i], a[0], s);
        }

    }
    for (i = 0; i < 12; i++)
    {
        if (i%2) {
            points[i] = b[i/2];
        }
        else
        {
            points[i] = a[i/2];
        }
    }
}

@implementation PGShutterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.frame = CGRectMake(0, 0, kViewSize, kViewSize);
        self.hideTheDoor = YES;
        self.value = 0.5;
    }
    return self;
}

- (void)setValue:(CGFloat)value
{
    value = MAX(value, 0.000001);
    value = MIN(value, 0.92);
    _value = value;
    [self setNeedsDisplay];
}

- (void)setHideTheDoor:(BOOL)hideTheDoor
{
    _hideTheDoor = hideTheDoor;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint centerPoint = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
    //draw outer circle
    CGContextSetLineWidth(context, kOuterCircleWidth);
    [[UIColor whiteColor] setStroke];
    CGContextAddArc(context, centerPoint.x, centerPoint.y, kOuterCircleRadius, 0, M_PI * 2, 0);
    CGContextStrokePath(context);

    if (!self.hideTheDoor)
    {
        CGContextAddArc(context, centerPoint.x, centerPoint.y, kInnerClipCircleRadius, 0, M_PI * 2, 0);
        [[[UIColor whiteColor] colorWithAlphaComponent:0.5] setFill];
        CGContextFillPath(context);

        setAllPoints(centerPoint, self.value * kInnerClipCircleRadius);
        CGContextSetBlendMode(context, kCGBlendModeClear);
        CGContextAddArc(context, centerPoint.x, centerPoint.y, kInnerClipCircleRadius, 0, M_PI * 2, 0);
        CGContextClip(context);
        CGContextSetLineWidth(context, 1.3);
        CGContextAddLines(context, points, 12);
        CGContextDrawPath(context, kCGPathFillStroke);
    }
}

@end
