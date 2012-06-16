//
//  SRRefreshView.m
//  SlimeRefresh
//
//  Created by apple on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import "SRRefreshView.h"
#import "SRSlimeView.h"
#import "SRDefine.h"

@interface SRRefreshView()

@property (nonatomic, assign)   BOOL    broken;

@end

@implementation SRRefreshView {
    SRSlimeView     *_slime;
    UIImageView     *_refleshView;
    UIActivityIndicatorView *_activityIndicatorView;
}

@synthesize delegate = _delegate, broken = _broken;
@synthesize loading = _loading, scrollView = _scrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _slime = [[SRSlimeView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height)];
        _slime.startPoint = CGPointMake(frame.size.width / 2, 20.0f);
        
        [self addSubview:_slime];
        
        _refleshView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sr_refresh"]];
        _refleshView.center = _slime.startPoint;
        _refleshView.bounds = CGRectMake(0.0f, 0.0f, kRefreshImageWidth, kRefreshImageWidth);
        [self addSubview:_refleshView];
        
        _activityIndicatorView = [[UIActivityIndicatorView alloc] 
                                  initWithActivityIndicatorStyle:
                                  UIActivityIndicatorViewStyleGray];
        [_activityIndicatorView stopAnimating];
        _activityIndicatorView.center = _slime.startPoint;
        [self addSubview:_activityIndicatorView];
        
        [_slime setPullApartTarget:self
                            action:@selector(pullApart:)];
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    NSLog(@"%f", frame.size.height);
    _slime.frame = CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height);
    _slime.startPoint = CGPointMake(frame.size.width / 2, 16.0f);
    _refleshView.center = _slime.startPoint;
    _activityIndicatorView.center = _slime.startPoint;
}

- (void)setLoading:(BOOL)loading
{
    if (_loading == loading) {
        return;
    }
    _loading = loading;
    if (_loading) {
        [_activityIndicatorView startAnimating];
        _slime.hidden = YES;
        _refleshView.hidden = YES;
    }else {
        [_activityIndicatorView stopAnimating];
        _slime.hidden = NO;
        _refleshView.hidden = NO;
        _refleshView.bounds = CGRectMake(0.0f, 0.0f, kRefreshImageWidth,
                                         kRefreshImageWidth);
    }
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    CGRect rect = self.frame;
    rect.origin.y = -rect.size.height;
    self.frame = rect;
}

#pragma mark - action

- (void)pullApart:(SRRefreshView*)refreshView
{
    //拉断了
    self.broken = YES;
    self.loading = YES;
    if ([_delegate respondsToSelector:@selector(slimeRefreshStartRefresh:)]) {
        [_delegate slimeRefreshStartRefresh:self];
    }
}

- (void)scrollViewDidScroll
{
    CGPoint p = _scrollView.contentOffset;
    if (p.y <= - 32.0f) {
        if (!_broken) {
            CGRect rect = self.frame;
            rect.origin.y = p.y;
            if (p.y < -32.0f) rect.size.height = -p.y;
            else rect.size.height = 32.0f;
            self.frame = rect;
            float l = -(p.y + 32.0f);
            CGPoint ssp = _slime.startPoint;
            _slime.toPoint = CGPointMake(ssp.x, ssp.y + l);
            //_refleshView.layer.transform 看起来可以不用加入这个库
            CGFloat pf = (1.0f-l/_slime.viscous) * (1.0f-kStartTo) + kStartTo;
            _refleshView.bounds = CGRectMake(0.0f, 0.0f, pf * kRefreshImageWidth,
                                             pf * kRefreshImageWidth);
        }
    }else if (p.y < 0) {
        CGRect rect = self.frame;
        rect.origin.y = -32.0f;
        if (p.y < -32.0f) rect.size.height = -p.y;
        else rect.size.height = 32.0f;
        self.frame = rect;
        _slime.toPoint = _slime.startPoint;
    }
}

- (void)scrollViewDidEndDraging
{
    if (_broken) {
        if (self.loading) {
            [UIView transitionWithView:_scrollView
                              duration:0.2
                               options:UIViewAnimationCurveEaseOut
                            animations:^{
                                _scrollView.contentInset = UIEdgeInsetsMake(32.0f, 0.0f, 0.0f, 0.0f);
                            } completion:^(BOOL finished) {
                                self.broken = NO;
                            }];
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.2f];
            CGRect rect = self.frame;
            rect.origin.y = -32.0f;
            rect.size.height = 32.0f;
            self.frame = rect;
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
        self.loading = NO;
        _slime.toPoint = _slime.startPoint;
        //_notSetFrame = YES;
        [UIView transitionWithView:_scrollView
                          duration:0.2f
                           options:UIViewAnimationCurveEaseOut
                        animations:^{
                            _scrollView.contentInset = UIEdgeInsetsZero;
                        } completion:^(BOOL finished) {
                            //_notSetFrame = NO;
                        }];
    }
}

@end
