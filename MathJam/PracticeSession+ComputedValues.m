//
//  PracticeSession+ComputedValues.m
//  MathJam
//
//  Created by Rusty Zarse on 12/4/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "PracticeSession+ComputedValues.h"
#import "MathEquation.h"

@implementation PracticeSession (ComputedValues)

- (NSTimeInterval)sessionLengthInSeconds{
    return [self.endTime timeIntervalSinceDate:self.startTime];
}

- (float)equationsPerMinute{
    
    if (self.equations == nil || self.equations.count == 0 || self.startTime == nil || self.endTime == nil) {
        return 0;
    }
    
    int equationsAnswered = 0;
    
    for(MathEquation *eq in self.equations)
    {
        if ([eq.wrongAnswerCount intValue] > 0 || eq.answeredCorrectlyAt != nil) {
            ++equationsAnswered;
        }
    }
    
    NSTimeInterval interval = [self sessionLengthInSeconds];
    int seconds = lroundf(interval);
    float result =  ( equationsAnswered / ( seconds  / 60.0 ) );
    return result;
}

@end
