//
//  PracticeSessionTests.m
//  MathJam
//
//  Created by Rusty Zarse on 12/4/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "PracticeSessionTests.h"
#import "RZCoreDataManagerForTests.h"
#import "PracticeSession+ComputedValues.h"

@implementation PracticeSessionTests{
    RZCoreDataManager *coreDataManager;
}

- (void)setUp{
    coreDataManager = [RZCoreDataManager sharedInstance];
}

- (void)testEquationsPerMinute{
    NSArray *allSessions = [coreDataManager getAllPracticeSessions];
    PracticeSession *someSession = [allSessions objectAtIndex:1];
    
    NSTimeInterval duration = [someSession.endTime timeIntervalSinceDate:someSession.startTime];
    
    int equationsCount = someSession.equations.count;
    
    float perMinute = equationsCount / (duration / 60.0);
    
    float actual = [someSession equationsPerMinute];
    
    STAssertEquals(perMinute, actual, @"Expected %f equations per minute but got %f", perMinute, actual);
}


@end
