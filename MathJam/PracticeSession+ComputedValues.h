//
//  PracticeSession+ComputedValues.h
//  MathJam
//
//  Created by Rusty Zarse on 12/4/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "PracticeSession.h"

@interface PracticeSession (ComputedValues)
- (NSTimeInterval)sessionLengthInSeconds;
- (float)equationsPerMinute;
@end
