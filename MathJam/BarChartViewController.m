//
//  BarChartViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 11/21/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "BarChartViewController.h"
#import "RZAnalyticsData.h"
#import "Constants.h"
#import "RZViewHelper.h"

@interface BarChartViewController ()

@end

@implementation BarChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[self navigationController] setNavigationBarHidden:NO animated:animated];
    
    RZAnalyticsData *data = [RZAnalyticsData new];
    data.eventName = @"ChartViewed";
    [data fireAnalytics];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self addTitleLabel];
    [self addInfoLabel];

}

- (void)addTitleLabel{
    UILabel *viewTitle = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 20.0, 280.0, 24.0)];
    [viewTitle setFont:[UIFont fontWithName:kRZ_DEFAULT_FONT_NAME size:14.0]];
    viewTitle.text = @"Answers Per Minute";
    viewTitle.textAlignment = NSTextAlignmentCenter;
    viewTitle.textColor = [UIColor greenColor];
    viewTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewTitle];
}


- (void)addInfoLabel{
    CGRect windowFrame = [RZViewHelper windowFrame];
    UILabel *viewTitle = [[UILabel alloc] initWithFrame:CGRectMake(20.0, windowFrame.size.height - 120, 280.0, 48.0)];
    [viewTitle setFont:[UIFont fontWithName:kRZ_DEFAULT_FONT_NAME size:10.0]];
    viewTitle.numberOfLines = 3;
    viewTitle.text = @"This is your performance history from oldest on the left to most recent on the right!";
    viewTitle.textAlignment = NSTextAlignmentCenter;
    viewTitle.textColor = [UIColor grayColor];
    viewTitle.backgroundColor = [UIColor clearColor];
    [self.view addSubview:viewTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// disable rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return NO;
}



@end
