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

    
    self.equationsPerMinuteLabel.text = [self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:[self.practiceSession equationsPerMinute]]];
    
}


- (IBAction)donePressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
