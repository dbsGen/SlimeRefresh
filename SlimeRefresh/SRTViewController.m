//
//  SRTViewController.m
//  SlimeRefresh
//
//  Created by zrz on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import "SRTViewController.h"
#import "SRRefreshView.h"

@interface SRTViewController ()
<UIScrollViewDelegate, SRRefreshDelegate>

@end

@implementation SRTViewController {
    SRRefreshView   *_slimeView;
    UIScrollView    *_scrollView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        CGRect bounds = self.view.bounds;
        _scrollView = [[UIScrollView alloc] initWithFrame:bounds];
        bounds.size.height += 1;
        _scrollView.contentSize = bounds.size;
        _scrollView.delegate = self;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        view.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:view];
        [self.view addSubview:_scrollView];
        
        _slimeView = [[SRRefreshView alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
        _slimeView.delegate = self;
        _slimeView.scrollView = _scrollView;
        [_scrollView addSubview:_slimeView];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [_slimeView performSelector:@selector(endRefresh)
                     withObject:nil afterDelay:1 
                        inModes:[NSArray arrayWithObject:NSRunLoopCommonModes]];
}

@end
