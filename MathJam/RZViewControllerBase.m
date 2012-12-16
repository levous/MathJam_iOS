//
//  RZViewControllerBase.m
//  MathJam
//
//  Created by Rusty Zarse on 12/7/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "RZViewControllerBase.h"

@interface RZViewControllerBase ()

@end

@implementation RZViewControllerBase

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

#pragma mark iAd

- (void)presentAdView{
    
    ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.AutoresizingMask = UIViewAutoresizingFlexibleWidth;
    adView.delegate = self;
    [self.view addSubview:adView];
    
    self.adBannerView = adView;
    self.isAdBannerVisible = YES;
}

#pragma mark ADBannerViewDelegate

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    if (!self.isAdBannerVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        // Assumes the banner view is just off the top of the screen.
        self.adBannerView.frame = CGRectOffset(self.adBannerView.frame, 0, self.adBannerView.frame.size.height);
        [UIView commitAnimations];
        self.isAdBannerVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"the failed error is %@",error);
    if (self.isAdBannerVisible)
    {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        // Assumes the banner view is placed at the top of the screen.
        self.adBannerView.frame = CGRectOffset(self.adBannerView.frame, 0, -self.adBannerView.frame.size.height);
        [UIView commitAnimations];
        self.isAdBannerVisible = NO;
    }
}

#pragma mark - Rotation

// disable rotation
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}

@end
