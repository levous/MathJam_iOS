//
//  TimedSessionSummaryViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 12/7/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "TimedSessionSummaryViewController.h"

#import "PracticeSession+ComputedValues.h"
#import "RZAnalyticsData.h"

@implementation TimedSessionSummaryViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.highScoreView.hidden = YES;
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    [self.numberFormatter setPositiveFormat:@"###0.#"];
    
    int totalEquationsAnswers = 0;
    int totalIncorrectAnswers = 0;
    int answeredCorrectlyFirstTry = 0;
    for (MathEquation *equation in self.practiceSession.equations) {
        totalIncorrectAnswers += [equation.wrongAnswerCount intValue];
        
        if ([equation.wrongAnswerCount intValue] > 0 || equation.answeredCorrectlyAt != nil) {
            ++totalEquationsAnswers;
        }
        
        if ([equation.wrongAnswerCount intValue] == 0 && equation.answeredCorrectlyAt != nil) {
            ++answeredCorrectlyFirstTry;
        }
    }

    int equationsPerMinute = [self.practiceSession equationsPerMinute];
    NSTimeInterval sessionLengthInSeconds = [self.practiceSession sessionLengthInSeconds];
    
    
    self.equationsPerMinuteLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:equationsPerMinute]];
    self.totalAnsweredLabel.text = [NSString stringWithFormat:@"%i", totalEquationsAnswers];
    self.answeredCorrectlyFirstTryLabel.text = [NSString stringWithFormat:@"%i", answeredCorrectlyFirstTry];
    self.totalIncorrectAnswersLabel.text = [NSString stringWithFormat:@"%i", totalIncorrectAnswers];
    self.sessionTitleLabel = [NSString stringWithFormat:@"%@ Minutes Practice", [self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:sessionLengthInSeconds/60]]];
    
    [self sendAnalyticsWithTotalEquationsAnsweredCount:totalEquationsAnswers
                                         firstTryCount:answeredCorrectlyFirstTry
                                   totalIncorrectCount:totalIncorrectAnswers
                                    equationsPerMinute:equationsPerMinute
                                         sessionLength:sessionLengthInSeconds];
    
    ADBannerView *adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    adView.AutoresizingMask = UIViewAutoresizingFlexibleWidth;
    // don't care yet adView.delegate = self;
    [self.view addSubview:adView];
    
}

- (void)sendAnalyticsWithTotalEquationsAnsweredCount:(int)eqCount firstTryCount:(int)firstTry totalIncorrectCount:(int)wrongAnswers equationsPerMinute:(int)eqPerMinute sessionLength:(NSTimeInterval)sessionLength{
    NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:eqCount], @"TotalAnswered",
                                 [NSNumber numberWithInt:firstTry], @"FirstTry",
                                 [NSNumber numberWithInt:wrongAnswers], @"WrongAnswers",
                                 [NSNumber numberWithInt:eqPerMinute], @"EqPerMinute",
                                 [NSNumber numberWithInt:(int)sessionLength], @"SessionSeconds",
                                 nil];
    
    [RZAnalyticsData fireAnalyticsWithEventNamed:@"TimedSessionSummaryViewed" andParameters:data];
}

- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
