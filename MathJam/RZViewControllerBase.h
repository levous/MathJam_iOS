//
//  RZViewControllerBase.h
//  MathJam
//
//  Created by Rusty Zarse on 12/7/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface RZViewControllerBase : UIViewController<ADBannerViewDelegate>

@property(nonatomic)BOOL isAdBannerVisible;
@property (strong, nonatomic) UIView *adBannerView;

- (void)presentAdView;

@end
