//
//  SRTViewController.m
//  SlimeRefresh
//
//  Created by zrz on 12-6-15.
//  Copyright (c) 2012年 zrz. All rights reserved.
//

#import "SRTViewController.h"
#import "SRAnimationView.h"

@interface SRTViewController ()

@end

@implementation SRTViewController {
    SRAnimationView *_slimeView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _slimeView = [[SRAnimationView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _slimeView.startPoint = CGPointMake(20, 40);
        [self.view addSubview:_slimeView];
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

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    _slimeView.toPoint = [touch locationInView:self.view];
}

@end
