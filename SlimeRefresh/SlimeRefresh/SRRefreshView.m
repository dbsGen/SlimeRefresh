//
//  SRRefreshView.m
//  SlimeRefresh
//
//  Created by zrz on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import "SRRefreshView.h"
#import "SRSlimeView.h"
#import "SRDefine.h"
#import <QuartzCore/QuartzCore.h>

@interface SRRefreshView()

@property (nonatomic, assign)   BOOL    broken;
@property (nonatomic, strong)   UIScrollView    *scrollView;

@end

@implementation SRRefreshView {
    UIActivityIndicatorView *_activityIndicatorView;
    CGFloat     _oldLength;
    BOOL        _unmissSlime;
    CGFloat     _dragingHeight;
}

@synthesize delegate = _delegate, broken = _broken;
@synthesize loading = _loading, scrollView = _scrollView;
@synthesize slime = _slime, refreshView = _refreshView;
@synthesize block = _block, upInset = _upInset;
@synthesize slimeMissWhenGoingBack = _slimeMissWhenGoingBack;
@synthesize activityIndicationView = _activityIndicatorView;


- (void)dealloc
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithHeight:32];
    return self;
}

- (id)initWithHeight:(CGFloat)height
{
    CGRect frame = CGRectMake(0, 0, 320, height);
    self = [super initWithFrame:frame];
    if (self) {
        _slime = [[SRSlimeView alloc] initWithFrame:
                  CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        _slime.startPoint = CGPointMake(frame.size.width / 2, height / 2);
        
        [self addSubview:_slime];
        
        _refreshView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sr_refresh"]];
        _refreshView.center = _slime.startPoint;
        _refreshView.bounds = CGRectMake(0.0f, 0.0f, kRefreshImageWidth, kRefreshImageWidth);
        [self addSubview:_refreshView];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc]
                                  initWithActivityIndicatorStyle:
                                  UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView stopAnimating];
        _activityIndicatorView.center = _slime.startPoint;
        [self addSubview:_activityIndicatorView];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [_slime setPullApartTarget:self
                            action:@selector(pullApart:)];
        _dragingHeight = height;
        _upInset = 44;
    }
    return self;
}

#pragma mark - setters

- (void)setUpInset:(CGFloat)upInset{}
- (CGFloat)upInset{return _upInset;}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _refreshView.layer.transform = CATransform3DIdentity;
    _slime.toPoint = _slime.startPoint = CGPointMake(frame.size.width / 2, frame.size.height - _dragingHeight / 2);
    if (_scrollView) {
        [self scroll];
    }
}

- (void)setSlimeMissWhenGoingBack:(BOOL)slimeMissWhenGoingBack
{
    _slimeMissWhenGoingBack = slimeMissWhenGoingBack;
    if (!slimeMissWhenGoingBack) {
        _slime.alpha = 1;
    }else {
        CGPoint p = _scrollView.contentOffset;
        self.alpha = -(p.y + _upInset) / _dragingHeight;
    }
}

- (void)setLoading:(BOOL)loading
{
    if (_loading == loading) {
        return;
    }
    _loading = loading;
    if (_loading) {
        [_activityIndicatorView startAnimating];
        CAKeyframeAnimation *aniamtion = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        
        aniamtion.values = [NSArray arrayWithObjects:
                            [NSValue valueWithCATransform3D:
                             CATransform3DRotate(CATransform3DMakeScale(0.01, 0.01, 0.1),
                             -M_PI, 0, 0, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.6, 1.6, 1)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity],nil];
        aniamtion.keyTimes = [NSArray arrayWithObjects:
                              [NSNumber numberWithFloat:0],
                              [NSNumber numberWithFloat:0.6],
                              [NSNumber numberWithFloat:1], nil];
        aniamtion.timingFunctions = [NSArray arrayWithObjects:
                                     [CAMediaTimingFunction functionWithName:
                                      kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:
                                      kCAMediaTimingFunctionEaseInEaseOut],
                                      nil];
        aniamtion.duration = 0.7;
        _activityIndicatorView.layer.transform = CATransform3DIdentity;
        [_activityIndicatorView.layer addAnimation:aniamtion
                                            forKey:@""];
//        _slime.hidden = YES;
        _refreshView.hidden = YES;
        if (!_unmissSlime){
            _slime.state = SRSlimeStateMiss;
        }else {
            _unmissSlime = NO;
        }
    }else {
        
        [_activityIndicatorView stopAnimating];
        _refreshView.hidden = NO;
        _refreshView.layer.transform = CATransform3DIdentity;
        [UIView transitionWithView:_scrollView
                          duration:0.3f
                           options:UIViewAnimationOptionCurveEaseOut
                        animations:^{
                            UIEdgeInsets inset = _scrollView.contentInset;
                            inset.top = _upInset;
                            _scrollView.contentInset = inset;
                            if (_scrollView.contentOffset.y == -_upInset &&
                                _slimeMissWhenGoingBack) {
                                self.alpha = 0.0f;
                            }
                        } completion:^(BOOL finished) {
                            _slime.hidden = NO;
                            CGRect bounds = self.bounds;
                            _slime.frame = bounds;
                            _slime.toPoint = _slime.startPoint = CGPointMake(bounds.size.width / 2, _dragingHeight / 2);
                        }];
        
    }
}

- (void)setLoadingWithexpansion
{
    [UIView animateWithDuration:0.2 animations:^() {
        UIEdgeInsets inset = _scrollView.contentInset;
        inset.top = _upInset + _dragingHeight;
        _scrollView.contentInset = inset;
        [_scrollView setContentOffset:CGPointMake(_scrollView.contentOffset.x,
                                                  -_scrollView.contentInset.top)
                             animated:NO];
    }];
    self.loading = YES;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        self.scrollView = (id)[self superview];
        CGRect rect = self.frame;
        rect.origin.y = rect.size.height?-rect.size.height:-_dragingHeight;
        rect.size.width = _scrollView.frame.size.width;
        self.frame = rect;
        self.slime.toPoint = self.slime.startPoint;
        
        UIEdgeInsets inset = self.scrollView.contentInset;
        inset.top = _upInset;
        self.scrollView.contentInset = inset;
    }else if (!self.superview) {
        self.scrollView = nil;
    }
}

-(void)update:(CGFloat)upInset {
    if (_scrollView) {
        _upInset = upInset;
        _slime.viscous = MAX(_upInset, 32);
        CGRect frame = self.frame = CGRectMake(0, -self.frame.size.height, _scrollView.bounds.size.width, _dragingHeight);
        _slime.toPoint = CGPointMake(self.frame.size.width / 2, _dragingHeight / 2);
        _activityIndicatorView.center = CGPointMake(frame.size.width / 2, frame.size.height / 2);
        [self scrollViewDidScroll];
    }
}

#pragma mark - action

- (void)pullApart:(SRRefreshView*)refreshView
{
    //拉断了
    self.broken= YES;
    _unmissSlime = YES;
    self.loading = YES;
    if ([_delegate respondsToSelector:@selector(slimeRefreshStartRefresh:)]) {
        [(id)_delegate performSelector:@selector(slimeRefreshStartRefresh:)
                            withObject:self
                            afterDelay:0.0];
    }
    if (_block) {
        _block(self);
    }
}

- (void)fixRefresh {
    _refreshView.center = CGPointMake(_slime.toPoint.x, self.frame.size.height - _slime.toPoint.y);
}

- (void)scroll {
    if (!_broken) {
        CGPoint p = _scrollView.contentOffset;
        CGRect frame = self.frame;
        _slime.frame = CGRectMake(0.0f, frame.size.height + p.y + _upInset,
                                  frame.size.width, -p.y);
        _slime.toPoint = CGPointMake(frame.size.width / 2, -p.y - _upInset - _dragingHeight / 2);
        float l = -(p.y + _dragingHeight + _upInset);
        if (l <= _oldLength) {
            l = MIN(distansBetween(_slime.startPoint, _slime.toPoint), l);
            CGPoint ssp = _slime.toPoint;
            _slime.startPoint = CGPointMake(ssp.x, ssp.y - l);
            CGFloat pf = MIN(MAX((1.0f-l/_slime.viscous) * (1.0f-kStartTo) + kStartTo, 0), 1);
            _refreshView.layer.transform = CATransform3DMakeScale(pf, pf, 1);
        }else if (self.scrollView.isDragging) {
            CGPoint ssp = _slime.toPoint;
            _slime.startPoint = CGPointMake(ssp.x, ssp.y - l);
            CGFloat pf = MIN(MAX((1.0f-l/_slime.viscous) * (1.0f-kStartTo) + kStartTo, 0), 1);
            _refreshView.layer.transform = CATransform3DMakeScale(pf, pf, 1);
        }
        _oldLength = l;
    }
}

- (void)scrollViewDidScroll
{
    CGPoint p = _scrollView.contentOffset;
    if (p.y == -_upInset) {
        CGRect bounds = self.bounds;
        _slime.frame = bounds;
        _slime.toPoint = _slime.startPoint = CGPointMake(bounds.size.width / 2, _dragingHeight / 2);
    }
    if (p.y <= - _dragingHeight - _upInset && !_broken) {
        [self scroll];
        if (self.alpha != 1.0f) self.alpha = 1.0f;
    }else if (p.y < -_upInset) {
        [_slime setNeedsDisplay];
        //if (_slimeMissWhenGoingBack)
            self.alpha = -(p.y + _upInset) / _dragingHeight;
        if (!_broken) {
            CGRect bounds = self.bounds;
            _slime.toPoint = _slime.startPoint = CGPointMake(bounds.size.width / 2, _dragingHeight / 2);
            _slime.frame = self.bounds;
        }
    }else {
        self.alpha = 0;
    }
    [self fixRefresh];
}

- (void)scrollViewDidEndDraging
{
    if (_broken) {
        if (self.loading) {
            [UIView transitionWithView:_scrollView.superview
                              duration:0.2
                               options:0
                            animations:^{
                                UIEdgeInsets inset = _scrollView.contentInset;
                                inset.top = -_scrollView.contentOffset.y;
                                _scrollView.contentInset = inset;
                            } completion:^(BOOL finished) {
                                [UIView transitionWithView:_scrollView.superview
                                                  duration:0.2
                                                   options:0
                                                animations:^{
                                                    UIEdgeInsets inset = _scrollView.contentInset;
                                                    inset.top = _upInset + _dragingHeight;
                                                    _scrollView.contentInset = inset;
                                                } completion:^(BOOL finished) {
                                                    self.broken = NO;
                                                }];
                            }];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2f];
            [UIView commitAnimations];
        }else {
            [self performSelector:@selector(setBroken:)
                       withObject:nil afterDelay:0.2];
            self.loading = NO;
        }
        
    }
}

- (void)endRefresh
{
    if (self.loading) {
        //_notSetFrame = YES;
        [self performSelector:@selector(restore)
                   withObject:nil
                   afterDelay:0];
    }
    _oldLength = 0;
}

- (void)restore
{
    _slime.hidden = YES;
    _slime.toPoint = _slime.startPoint;
    [UIView transitionWithView:_activityIndicatorView
                      duration:0.3f
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^
     {
         _activityIndicatorView.layer.transform = CATransform3DRotate(
                                                                      CATransform3DMakeScale(0.01f, 0.01f, 0.1f), -M_PI, 0, 0, 1);
     } completion:^(BOOL finished)
     {
         self.loading = NO;
         _slime.state = SRSlimeStateNormal;
     }];
}

@end
