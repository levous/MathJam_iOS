//
//  TimerSplashViewController.h
//  MathJam
//
//  Created by Rusty Zarse on 12/7/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RZViewControllerBase.h"

@interface TimerSplashViewController : RZViewControllerBase
@property (weak, nonatomic) IBOutlet UILabel *goLabel;
@property (weak, nonatomic) IBOutlet UIView *box, *background;

@end
