//
//  TimerSplashViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 12/7/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "TimerSplashViewController.h"

#import <QuartzCore/QuartzCore.h>
#import "RZViewHelper.h"


@interface TimerSplashViewController ()

@end

@implementation TimerSplashViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        

        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
        
    [self.view setFrame:[RZViewHelper windowFrame]];
    
    UIView *box = self.box;
    [box.layer setCornerRadius:30.0f];
    [box.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [box.layer setBorderWidth:1.0f];
    [box.layer setShadowColor:[UIColor blackColor].CGColor];
    [box.layer setShadowOpacity:0.5];
    [box.layer setShadowRadius:3.0];
    [box.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
