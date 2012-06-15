//
//  SRAnimationView.m
//  SlimeRefresh
//
//  Created by zrz on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import "SRAnimationView.h"

#define kStartTo    0.7
#define kEndTo      0.15
#define kAngle      M_PI / 3


NS_INLINE CGFloat distansBetween(CGPoint p1 , CGPoint p2) {
    return sqrtf((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y));
}

NS_INLINE CGPoint tampLineToArc(CGPoint center, CGPoint p2, float angle, CGFloat radius) {
    float angleS = atan2f(p2.y - center.y, p2.x - center.x);
    float angleT = angleS + angle;
    float x = radius * cosf(angleT);
    float y = radius * sinf(angleT);
    return CGPointMake(x + center.x, y + center.y);
}

@implementation SRAnimationView

@synthesize viscous = _viscous, toPoint = _toPoint;
@synthesize startPoint = _startPoint;
@synthesize bodyColor = _bodyColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        _toPoint = _startPoint = CGPointMake(frame.size.width / 2,
                                             frame.size.height / 2);
        _viscous = 35;
        _radius = 13;
        _bodyColor = [UIColor grayColor];
    }
    return self;
}

- (void)setStartPoint:(CGPoint)startPoint
{
    _startPoint = startPoint;
    [self setNeedsDisplay];
}

- (UIBezierPath*)middlePath:(CGFloat)startRadius end:(CGFloat)endRadius
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    return path;
}

- (void)drawRect:(CGRect)rect
{
    float progress = 1 - distansBetween(_startPoint , _toPoint) / _viscous;
    if (progress > 0) {
        CGFloat startRadius = _radius * (kStartTo + (1-kStartTo)*progress);
        [_bodyColor setFill];
        CGContextRef context = UIGraphicsGetCurrentContext();
        //draw big cercle
        CGContextAddArc(context, _startPoint.x,
                        _startPoint.y, startRadius,
                        0, 2*M_PI, 1);
        CGContextDrawPath(context, kCGPathFill);
        
        CGFloat endRadius = _radius * (kEndTo + (1-kEndTo)*progress);
        //draw small cercle
        CGContextAddArc(context, _toPoint.x,
                        _toPoint.y, endRadius,
                        0, 2*M_PI, 1);
        CGContextDrawPath(context, kCGPathFill);
            
        CGPoint p = tampLineToArc(_startPoint, _toPoint, kAngle, startRadius);
        
        [[UIColor blackColor] setFill];
        CGContextAddRect(context, CGRectMake(p.x, p.y, 1, 1));
        CGContextDrawPath(context, kCGPathFill);
    }
    
}

- (void)setToPoint:(CGPoint)toPoint
{
    _toPoint = toPoint;
    [self setNeedsDisplay];
}

@end
