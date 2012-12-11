//
//  TimedSessionViewController.h
//  MathJam
//
//  Created by Rusty Zarse on 11/1/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MissingNumberViewController.h"
#import "RZViewControllerBase.h"
#import "JZTimerMan.h"
@protocol TimedSessionConfigDelegate
@property JZTimerMan *timerMan;
@property PracticeSession *practiceSession;
@end

@interface TimedSessionViewController : RZViewControllerBase
@property (weak, nonatomic) IBOutlet UISwitch *timedSwitch;
@property (weak, nonatomic) IBOutlet UIPickerView *minutesPicker;
@property (weak, nonatomic) id<TimedSessionConfigDelegate> timedSessionConfigDelegate;
- (IBAction)timedSwitchChanged:(id)sender;
- (IBAction)cancelPressed:(id)sender;
- (IBAction)beginPressed:(id)sender;


@end
