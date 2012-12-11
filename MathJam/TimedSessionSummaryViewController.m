//
//  TimedSessionSummaryViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 12/7/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "TimedSessionSummaryViewController.h"
#import "PracticeSession+ComputedValues.h"

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

    
    self.equationsPerMinuteLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:[self.practiceSession equationsPerMinute]]];
    self.totalAnsweredLabel.text = [NSString stringWithFormat:@"%i", totalEquationsAnswers];
    self.answeredCorrectlyFirstTryLabel.text = [NSString stringWithFormat:@"%i", answeredCorrectlyFirstTry];
    self.totalIncorrectAnswersLabel.text = [NSString stringWithFormat:@"%i", totalIncorrectAnswers];
    
    
}


- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
