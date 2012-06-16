//
//  SRAnimationView.m
//  SlimeRefresh
//
//  Created by zrz on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import "SRSlimeView.h"
#import "SRDefine.h"
#import <QuartzCore/QuartzCore.h>

NS_INLINE CGFloat distansBetween(CGPoint p1 , CGPoint p2) {
    return sqrtf((p1.x - p2.x)*(p1.x - p2.x) + (p1.y - p2.y)*(p1.y - p2.y));
}

NS_INLINE CGPoint pointLineToArc(CGPoint center, CGPoint p2, float angle, CGFloat radius) {
    float angleS = atan2f(p2.y - center.y, p2.x - center.x);
    float angleT = angleS + angle;
    float x = radius * cosf(angleT);
    float y = radius * sinf(angleT);
    return CGPointMake(x + center.x, y + center.y);
}

@implementation SRSlimeView {
    __unsafe_unretained id  _target;
    SEL _action;
}

@synthesize viscous = _viscous, toPoint = _toPoint;
@synthesize startPoint = _startPoint, skinColor = _skinColor;
@synthesize bodyColor = _bodyColor, radius = _radius;
@synthesize missWhenApart = _missWhenApart;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        _toPoint = _startPoint = CGPointMake(frame.size.width / 2,
                                             frame.size.height / 2);
        _viscous = 55.0f;
        _radius = 13.0f;
        _bodyColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
        _skinColor = [UIColor colorWithWhite:0.8f alpha:0.9f];
        
        _missWhenApart = YES;
    }
    return self;
}

//- (void)setFrame:(CGRect)frame
//{
//    [super setFrame:frame];
//    _toPoint = _startPoint = CGPointMake(frame.size.width / 2,
//                                         frame.size.height / 2);
//    [self setNeedsDisplay];
//}

- (void)setStartPoint:(CGPoint)startPoint
{
    if (CGPointEqualToPoint(_startPoint, startPoint))return;
    _startPoint = startPoint;
    [self setNeedsDisplay];
}

- (void)setToPoint:(CGPoint)toPoint
{
    if (CGPointEqualToPoint(_toPoint, toPoint))return;
    _toPoint = toPoint;
    [self setNeedsDisplay];
}

- (UIBezierPath*)middlePath:(CGFloat)startRadius end:(CGFloat)endRadius
{
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    CGPoint sp1 = pointLineToArc(_startPoint, _toPoint,
                                 M_PI/3, startRadius),
            sp2 = pointLineToArc(_startPoint, _toPoint,
                                 -M_PI/3, startRadius),
            ep1 = pointLineToArc(_toPoint, _startPoint,
                                 M_PI/2, endRadius),
            ep2 = pointLineToArc(_toPoint, _startPoint,
                                 -M_PI/2, endRadius);
    
    CGPoint mp1 = CGPointMake((sp2.x + ep1.x)/2, (sp2.y + ep1.y)/2),
            mp2 = CGPointMake((sp1.x + ep2.x)/2, (sp1.y + ep2.y)/2),
            mm = CGPointMake((mp1.x + mp2.x)/2, (mp1.y + mp2.y)/2);
    float p = distansBetween(mp1, mp2) / 2 / endRadius;
    mp1 = CGPointMake((mp1.x - mm.x)/p + mm.x, (mp1.y - mm.y)/p + mm.y);
    mp2 = CGPointMake((mp2.x - mm.x)/p + mm.x, (mp2.y - mm.y)/p + mm.y);
    
    [path moveToPoint:sp1];
    float angleS = atan2f(_toPoint.y - _startPoint.y,
                          _toPoint.x - _startPoint.x);
    [path addArcWithCenter:_startPoint
                    radius:startRadius
                startAngle:angleS + M_PI/3
                  endAngle:angleS + M_PI*5/3 
                 clockwise:YES];
    [path addQuadCurveToPoint:ep1
                 controlPoint:mp1];
    angleS = atan2f(_startPoint.y - _toPoint.y,
                    _startPoint.x - _toPoint.x);
    [path addArcWithCenter:_toPoint
                    radius:endRadius
                startAngle:angleS + M_PI/2
                  endAngle:angleS + M_PI*3/2 
                 clockwise:YES];
    [path addQuadCurveToPoint:sp1
                 controlPoint:mp2];
    
    return path;
}

- (void)drawRect:(CGRect)rect
{
    float progress = 1 - distansBetween(_startPoint , _toPoint) / _viscous;
    if (progress == 1) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        [_bodyColor setFill];
        [_skinColor setStroke];
        CGContextSetLineWidth(context, 1);
        CGContextAddArc(context, _startPoint.x,
                        _startPoint.y, _radius,
                        0, 2*M_PI, 1);
        CGContextDrawPath(context, kCGPathFillStroke);
    }else {
        CGFloat startRadius = _radius * (kStartTo + (1-kStartTo)*progress);
        [_bodyColor setFill];
        [_skinColor setStroke];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1);
        //draw big cercle
//        CGContextAddArc(context, _startPoint.x,
//                        _startPoint.y, startRadius,
//                        0, 2*M_PI, 1);
//        CGContextDrawPath(context, kCGPathFill);
        
        CGFloat endRadius = _radius * (kEndTo + (1-kEndTo)*progress);
        //draw small cercle
//        CGContextAddArc(context, _toPoint.x,
//                        _toPoint.y, endRadius,
//                        0, 2*M_PI, 1);
//        CGContextDrawPath(context, kCGPathFill);
        
        UIBezierPath *path = [self middlePath:startRadius end:endRadius];
        CGContextAddPath(context, path.CGPath);
        CGContextDrawPath(context, kCGPathFillStroke);
        if (progress <= 0) {
            if (_missWhenApart) {
                CATransition *animation = [CATransition animation];
                self.hidden = YES;
                [self.layer addAnimation:animation forKey:@""];
            }
            [_target performSelector:_action withObject:self];
        }
    }
}

- (void)setPullApartTarget:(id)target action:(SEL)action
{
    _target = target;
    _action = action;
}

@end
