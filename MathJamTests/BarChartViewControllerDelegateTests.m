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
#import "PracticeSession+ComputedValues.h"

@implementation BarChartViewControllerDelegateTests{
    BarChartViewControllerDelegate *barChartViewControllerDelegate;
    NSArray *sessions;
    float maxScore;
}

- (void)setUp{
    barChartViewControllerDelegate = [BarChartViewControllerDelegate new];
    
    RZCoreDataManager *cdMgr = [RZCoreDataManagerForTests sharedInstance];
    
    sessions = [cdMgr getAllPracticeSessions];
    
    
    for(PracticeSession *session in sessions){
        if(session.equations){
            maxScore = MAX(maxScore, [session equationsPerMinute]);
        }
    }
    
    [barChartViewControllerDelegate setCoreDataManager:cdMgr];
    

}

- (void)testBarChartMaxValueAndValueLinesAreAppropriate{
    float chartMax = (((int)(maxScore / 5)) + 1 ) * 5;
    
    [barChartViewControllerDelegate regenerateValues];
    
    STAssertEquals(chartMax, [barChartViewControllerDelegate frd3DBarChartViewControllerMaxValue:nil], @"The max chart value was not correct");
    
    
    PracticeSession *anySession = [sessions objectAtIndex:0];
    
    for(int i = 0;i < 200;++i){
        [barChartViewControllerDelegate.coreDataManager insertNewMathEquationInSession:anySession withFactorOne:[NSNumber numberWithInt:1] factorTwo:[NSNumber numberWithInt:1] operation:RZMathOperationAdd];
        
    }
    
    float newChartMax = (((int)([anySession equationsPerMinute] / 5)) + 1 ) * 5;
    
    STAssertFalse(newChartMax == chartMax, @"Test is invalid, expected these values to not be equal");
    
    [barChartViewControllerDelegate regenerateValues];
    
    STAssertEquals(newChartMax, [barChartViewControllerDelegate frd3DBarChartViewControllerMaxValue:nil], @"The max chart value was not correct");
    
    
}

- (void)testBarChartHorizontalLabelsShowDateAndScore{
        
    [barChartViewControllerDelegate regenerateValues];
    
    PracticeSession *thirdSession = [sessions objectAtIndex:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd h:mm"];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"###0.#"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[thirdSession equationsPerMinute]]];
    
    
    NSString *expectedLabel = [NSString stringWithFormat:@"%@", formattedNumberString];

    NSString *labelForThirdColumn = [barChartViewControllerDelegate frd3DBarChartViewController:nil legendForColumn:2];
    
    STAssertEqualObjects(expectedLabel, labelForThirdColumn, @"Expected the label to include the date, time and score");
    
    
}

@end
