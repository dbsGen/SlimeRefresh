//
//  SRRefreshView.h
//  SlimeRefresh
//
//  Created by apple on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SRRefreshDelegate;

@interface SRRefreshView : UIView

@property (nonatomic, assign)   id<SRRefreshDelegate>   delegate;
@property (nonatomic, assign)   BOOL    loading;
@property (nonatomic, assign)   UIScrollView    *scrollView;

- (void)scrollViewDidScroll;
- (void)scrollViewDidEndDraging;
- (void)endRefresh;

@end

@protocol SRRefreshDelegate <NSObject>

- (void)slimeRefreshStartRefresh:(SRRefreshView*)refreshView;

@end