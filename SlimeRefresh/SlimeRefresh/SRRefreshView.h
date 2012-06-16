//
//  SRRefreshView.h
//  SlimeRefresh
//
//  Created by apple on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SRSlimeView.h"

@protocol SRRefreshDelegate;

@interface SRRefreshView : UIView{
    UIImageView     *_refleshView;
    SRSlimeView     *_slime;
}

@property (nonatomic, assign)   id<SRRefreshDelegate>   delegate;
@property (nonatomic, assign)   BOOL    loading;
@property (nonatomic, assign)   UIScrollView    *scrollView;
@property (nonatomic, strong, readonly) SRSlimeView *slime;
@property (nonatomic, strong, readonly) UIImageView *refleshView;

- (void)scrollViewDidScroll;
- (void)scrollViewDidEndDraging;
- (void)endRefresh;

@end

@protocol SRRefreshDelegate <NSObject>

- (void)slimeRefreshStartRefresh:(SRRefreshView*)refreshView;

@end