//
//  MathFactTests.m
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "MathFactTests.h"
#import "RZMissingNumberEquation.h"
#import "RZCoreDataManager.h"   

@implementation MathFactTests
- (void)testMathFactInitialization
{
    RZCoreDataManager *cdm = [RZCoreDataManager sharedInstance];
    PracticeSession *ps = [cdm insertNewPracticeSession];
    
    RZMissingNumberEquation *fact = RZMissingNumberEquation.new;
    fact.practiceSession = ps;
    fact.practiceSession.factorOneUpperBound = [NSNumber numberWithInt:12];
    fact.practiceSession.factorTwoUpperBound = [NSNumber numberWithInt:10];
    fact.practiceSession.factorOneLowerBound = [NSNumber numberWithInt:2];
    fact.practiceSession.factorTwoLowerBound = [NSNumber numberWithInt:5];
    [fact generateNewFactors];
    int factorOneA = fact.factorOne.integerValue;
    STAssertEquals(NSOrderedAscending, [fact.factorOne compare:[NSNumber numberWithInt:13]], @"factor should have been 12 or less");
    STAssertEquals(NSOrderedDescending, [fact.factorOne compare:[NSNumber numberWithInt:1]], @"factor should have been 2 or more");
    STAssertEquals(NSOrderedAscending, [fact.factorTwo compare:[NSNumber numberWithInt:11]], @"factor should have been 10 or less");
    STAssertEquals(NSOrderedDescending, [fact.factorTwo compare:[NSNumber numberWithInt:4]], @"factor should have been 5 or more");
    [fact generateNewFactors];
    int factorOneB = fact.factorOne.integerValue;
    STAssertEquals(NSOrderedAscending, [fact.factorOne compare:[NSNumber numberWithInt:13]], @"factor should have been 12 or less");
    STAssertEquals(NSOrderedDescending, [fact.factorOne compare:[NSNumber numberWithInt:1]], @"factor should have been 2 or more");
    STAssertEquals(NSOrderedAscending, [fact.factorTwo compare:[NSNumber numberWithInt:11]], @"factor should have been 10 or less");
    STAssertEquals(NSOrderedDescending, [fact.factorTwo compare:[NSNumber numberWithInt:4]], @"factor should have been 5 or more");
    [fact generateNewFactors];
    int factorOneC = fact.factorOne.integerValue;
    STAssertEquals(NSOrderedAscending, [fact.factorOne compare:[NSNumber numberWithInt:13]], @"factor should have been 12 or less");
    STAssertEquals(NSOrderedDescending, [fact.factorOne compare:[NSNumber numberWithInt:1]], @"factor should have been 2 or more");
    STAssertEquals(NSOrderedAscending, [fact.factorTwo compare:[NSNumber numberWithInt:11]], @"factor should have been 10 or less");
    STAssertEquals(NSOrderedDescending, [fact.factorTwo compare:[NSNumber numberWithInt:4]], @"factor should have been 5 or more");
    
    STAssertFalse((factorOneA == factorOneB && factorOneB == factorOneC ), @"generating renadom factors should not produce the same result three times in a row.  Ok.  Its possibl.  Investigate and harden the test or the code :)");
    

}
@end
