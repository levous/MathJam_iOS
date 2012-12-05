//
//  PracticeSession+ComputedValues.m
//  MathJam
//
//  Created by Rusty Zarse on 12/4/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "PracticeSession+ComputedValues.h"

@implementation PracticeSession (ComputedValues)

- (float)equationsPerMinute{
    
    if (self.equations == nil || self.equations.count == 0 || self.startTime == nil || self.endTime == nil) {
        return 0;
    }
    
    NSTimeInterval interval = [self.endTime timeIntervalSinceDate:self.startTime];
    
    return ( self.equations.count / ( interval / 60.0 ) );
}

@end
