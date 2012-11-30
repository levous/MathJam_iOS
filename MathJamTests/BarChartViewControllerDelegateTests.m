//
//  BarChartViewControllerDelegateTests.m
//  MathJam
//
//  Created by Rusty Zarse on 11/29/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "BarChartViewControllerDelegateTests.h"
#import "BarChartViewControllerDelegate.h"
#import "RZCoreDataManagerForTests.h"

@implementation BarChartViewControllerDelegateTests



- (void)testBarChartMaxValueAndValueLinesAreAppropriate{
    BarChartViewControllerDelegate *barChartViewControllerDelegate = [BarChartViewControllerDelegate new];
    
    
    RZCoreDataManager *cdMgr = [RZCoreDataManagerForTests sharedInstance];
    
    NSArray *sessions = [cdMgr getAllPracticeSessions];
    
    int maxCount = 0;
    for(PracticeSession *session in sessions){
        if(session.equations){
            maxCount = MAX(maxCount, session.equations.count);
        }
    }
    
    float chartMax = (((int)(maxCount / 5)) + 1 ) * 5;
    
    
    [barChartViewControllerDelegate setCoreDataManager:cdMgr];
    [barChartViewControllerDelegate regenerateValues];
    
    STAssertEquals(chartMax, [barChartViewControllerDelegate frd3DBarChartViewControllerMaxValue:nil], @"The max chart value was not correct");
    
    
    PracticeSession *anySession = [sessions objectAtIndex:0];
    
    for(int i = 0;i < 52;++i){
        [cdMgr insertNewMathEquationInSession:anySession withFactorOne:[NSNumber numberWithInt:1] factorTwo:[NSNumber numberWithInt:1] operation:RZMathOperationAdd];
        
    }
    
    maxCount = anySession.equations.count;
    float newChartMax = (((int)(maxCount / 5)) + 1 ) * 5;
    
    STAssertFalse(newChartMax == chartMax, @"Test is invalid, expected these values to not be equal");
    
    [barChartViewControllerDelegate regenerateValues];
    
    STAssertEquals(newChartMax, [barChartViewControllerDelegate frd3DBarChartViewControllerMaxValue:nil], @"The max chart value was not correct");
    
}
@end
