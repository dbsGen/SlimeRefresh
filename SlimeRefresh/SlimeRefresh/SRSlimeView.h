//
//  SRAnimationView.h
//  SlimeRefresh
//
//  Created by zrz on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    SRSlimeTypeNormal,
    SRSlimeTypeShortening,
    SRSlimeTypeMiss
} SRSlimeType;

@class SRSlimeView;

@interface SRSlimeView : UIView

@property (nonatomic, assign)   CGPoint startPoint, toPoint;
@property (nonatomic, assign)   CGFloat viscous;    //default 55
@property (nonatomic, assign)   CGFloat radius;     //default 13
@property (nonatomic, retain)   UIColor *bodyColor,
                                        *skinColor;

@property (nonatomic, assign)   BOOL    missWhenApart;
@property (nonatomic, assign)   SRSlimeType type;

- (void)setPullApartTarget:(id)target action:(SEL)action;

@end
