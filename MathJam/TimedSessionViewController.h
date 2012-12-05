//
//  TimedSessionViewController.h
//  MathJam
//
//  Created by Rusty Zarse on 11/1/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissingNumberViewController.h"

@interface TimedSessionViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *timedSwitch;
@property (weak, nonatomic) IBOutlet UIPickerView *minutesPicker;
@property (weak, nonatomic) MissingNumberViewController *missingNumberViewController;
- (IBAction)timedSwitchChanged:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)beginPressed:(id)sender;

@end
