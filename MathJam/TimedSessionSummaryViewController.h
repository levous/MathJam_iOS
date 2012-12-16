//
//  TimedSessionSummaryViewController.h
//  MathJam
//
//  Created by Rusty Zarse on 12/7/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RZViewControllerBase.h"
#import "JZTimerMan.h"
#import "PracticeSession.h"
#import "MathEquation.h"

@interface TimedSessionSummaryViewController : RZViewControllerBase
@property (weak, nonatomic) IBOutlet UILabel *equationsPerMinuteLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalAnsweredLabel;
@property (weak, nonatomic) IBOutlet UILabel *answeredCorrectlyFirstTryLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalIncorrectAnswersLabel;
@property (weak, nonatomic) IBOutlet UIView *highScoreView;
@property (weak, nonatomic) IBOutlet UILabel *sessionTitleLabel;

@property(strong, nonatomic) NSNumberFormatter *numberFormatter;
@property (strong, nonatomic) PracticeSession *practiceSession;
- (IBAction)donePressed:(id)sender;
@end
