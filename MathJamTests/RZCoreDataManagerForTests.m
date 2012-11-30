//
//  RZCoreDataManagerForTests.m
//  MathJam
//
//  Created by Rusty Zarse on 11/29/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "RZCoreDataManagerForTests.h"
#import "RZMissingNumberEquation.h"

@implementation RZCoreDataManagerForTests

- (void)initializeTestData{
    
    for (int i = 1; i < 21; ++i) {
        PracticeSession *session = [self insertNewPracticeSession];
        NSTimeInterval secondsSinceNow = 60 * 60 * 24 * i * -1;
        NSDate *startTime = [NSDate dateWithTimeIntervalSinceNow:secondsSinceNow];
        NSDate *nextTime = [NSDate dateWithTimeInterval:5 sinceDate:startTime];
        [session setStartTime:startTime];
    
        RZMissingNumberEquation *missingNumberEq = [RZMissingNumberEquation new];
        missingNumberEq.practiceSession = session;
        
        for (int j = 1; j < 30; ++j) {
            nextTime = [NSDate dateWithTimeInterval:5 sinceDate:nextTime];
            // this will properly set up MathEquation
            [missingNumberEq generateNewFactors];
            missingNumberEq.mathEquation.answeredCorrectlyAt = nextTime;
        }
        
        [self save:nil];
    }
}

- (id)initWithURL:(NSURL *)databaseURL{
    self = [super initWithURL:databaseURL];
    
    // now create test data
    [self initializeTestData];
    
    return self;
}

@end
