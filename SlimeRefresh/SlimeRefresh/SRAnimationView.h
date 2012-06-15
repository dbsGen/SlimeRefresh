//
//  SRAnimationView.h
//  SlimeRefresh
//
//  Created by zrz on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SRAnimationView : UIView

@property (nonatomic, assign)   CGPoint startPoint, toPoint;
@property (nonatomic, assign)   CGFloat viscous;    //default 35
@property (nonatomic, assign)   CGFloat radius;     //default 13
@property (nonatomic, retain)   UIColor *bodyColor;

@end
