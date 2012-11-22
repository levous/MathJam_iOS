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


RZCoreDataManager *cdm = nil;
PracticeSession *ps = nil;


- (void)setUp
{
    [super setUp];
    
    cdm = [RZCoreDataManager sharedInstance];
    ps = [cdm insertNewPracticeSession];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (RZMissingNumberEquation *)setUpDivisionEquation{
    RZMissingNumberEquation *fact = RZMissingNumberEquation.new;
    fact.practiceSession = ps;
    fact.practiceSession.factorOneUpperBound = [NSNumber numberWithInt:12];
    fact.practiceSession.factorTwoUpperBound = [NSNumber numberWithInt:10];
    fact.practiceSession.factorOneLowerBound = [NSNumber numberWithInt:2];
    fact.practiceSession.factorTwoLowerBound = [NSNumber numberWithInt:5];
    fact.practiceSession.practiceAddition = [NSNumber numberWithBool:NO];
    fact.practiceSession.practiceSubtraction = [NSNumber numberWithBool:NO];
    fact.practiceSession.practiceMultiplication = [NSNumber numberWithBool:NO];
    
    fact.practiceSession.practiceDivision = [NSNumber numberWithBool:YES];
    return fact;
}

- (void)testRandomMissingNumberPosition
{
    bool hadFactOne, hadFactTwo, hadAnswer;
    RZMissingNumberEquation *fact = RZMissingNumberEquation.new;
    fact.practiceSession = ps;

    int i = 0;
    for (i= 0; i<20; ++i) {
        [fact generateNewFactors];
        switch (fact.missingNumberPosition) {
            case RZMissingNumberPositionFactorOne:
                hadFactOne = YES;
                break;
            case RZMissingNumberPositionFactorTwo:
                hadFactTwo = YES;
                break;
            case RZMissingNumberPositionAnswer:
                hadAnswer = YES;
                break;
        }
    }
    
    STAssertTrue(hadFactOne, @"Should have seen at least once");
    STAssertTrue(hadFactTwo, @"Should have seen at least once");
    STAssertTrue(hadAnswer, @"Should have seen at least once");
}

- (void)testRandomMathOperation
{
    bool hadMult, hadDiv, hadSub, hadAdd;
    RZMissingNumberEquation *fact = RZMissingNumberEquation.new;
    fact.practiceSession = ps;
    
    int i = 0;
    for (i= 0; i<20; ++i) {
        [fact generateNewFactors];
        switch (fact.mathOperation) {
            case RZMathOperationAdd:
                hadAdd = YES;
                break;
            case RZMathOperationSubtract:
                hadSub = YES;
                break;
            case RZMathOperationMultiply:
                hadMult = YES;
                break;
            case RZMathOperationDivide:
                hadDiv = YES;
                break;
        }
    }
    
    STAssertTrue(hadAdd, @"Should have seen at least once");
    STAssertTrue(hadSub, @"Should have seen at least once");
    STAssertTrue(hadMult, @"Should have seen at least once");
    STAssertTrue(hadDiv, @"Should have seen at least once");
}

- (bool)validateNumericRange:(RZMissingNumberEquation *)fact message:(NSString **)message{
    NSNumber *value1, *value2;
    if (fact.mathOperation == RZMathOperationDivide || fact.mathOperation == RZMathOperationSubtract) {
        // the ranges apply to the smaller of the number family but for subtraction and division, the large number comes first and the answer is oe of the smaller pair.  Terminology is quaestionable, at best...
        value1 = fact.answer;

    }else{
        value1 = fact.factorOne;
    }
    
    value2 = fact.factorTwo;
    
    bool valid = YES;
    NSString *messageString = @"";

    if (NSOrderedAscending != [value1 compare:[NSNumber numberWithInt:13]]){
        valid = NO;
        messageString = [NSString stringWithFormat:@"factor 1 should have been 12 or less but was %@\n", value1];
    }
                               
    if (NSOrderedDescending != [value1 compare:[NSNumber numberWithInt:1]]){
        valid = NO;
        messageString = [messageString stringByAppendingFormat:@"factor 1 should have been 2 or more but was %@", value1];
    }
       
    if (NSOrderedAscending != [value2 compare:[NSNumber numberWithInt:11]]){
        valid = NO;
        messageString = [messageString stringByAppendingFormat:@"factor 2 should have been 10 or less but was %@", value2];
    }
                         
    if (NSOrderedDescending != [value2 compare:[NSNumber numberWithInt:4]]){
        valid = NO;
        messageString = [messageString stringByAppendingFormat:@"factor 2 should have been 5 or more but was %@", value2];
    }
   
    *message = messageString;
    
    return valid;
    
    
}

- (void)testMathFactNumericRange
{    
    RZMissingNumberEquation *fact = RZMissingNumberEquation.new;
    fact.practiceSession = ps;
    fact.practiceSession.factorOneUpperBound = [NSNumber numberWithInt:12];
    fact.practiceSession.factorTwoUpperBound = [NSNumber numberWithInt:10];
    fact.practiceSession.factorOneLowerBound = [NSNumber numberWithInt:2];
    fact.practiceSession.factorTwoLowerBound = [NSNumber numberWithInt:5];
   
    NSString *message;
    
    [fact generateNewFactors];
    STAssertTrue([self validateNumericRange:fact message:&message], message);
    
    // gen again
    [fact generateNewFactors];
    STAssertTrue([self validateNumericRange:fact message:&message], message);
    
    // gen again
    [fact generateNewFactors];
    STAssertTrue([self validateNumericRange:fact message:&message], message);
    
    
}

- (void)testDividendIsNotAlwaysGreatestValueAnswerChoice
{
    RZMissingNumberEquation *fact = [self setUpDivisionEquation];
    
    BOOL dividendAlwaysGreatest = YES;
    for(int i = 0; i < 100 ; ++i){
        [fact generateNewFactors];
        if (fact.missingNumberPosition == RZMissingNumberPositionFactorOne) {
            for (NSNumber *choice in [fact getAnswerChoices:4]) {
                if ([choice compare:[fact expectedMissingNumberValue]] == NSOrderedDescending) {
                    dividendAlwaysGreatest = NO;
                    break;
                }
            }
            
        }
    }
    
    STAssertFalse(dividendAlwaysGreatest, @"In 100 tries, the dividend was always the greatest value choice, making that too freakin easy");
    
    
    
}

- (void)testQuotientIsNotAlwaysSmallestValueAnswerChoice
{
    RZMissingNumberEquation *fact = [self setUpDivisionEquation];
    
    BOOL quotientAlwaysSmallest = YES;
    for(int i = 0; i < 100 ; ++i){
        [fact generateNewFactors];
        if (fact.missingNumberPosition == RZMissingNumberPositionAnswer) {
            for (NSNumber *choice in [fact getAnswerChoices:4]) {
                if ([choice compare:[fact expectedMissingNumberValue]] == NSOrderedAscending) {
                    quotientAlwaysSmallest = NO;
                    break;
                }
            }
        }
    }
    
    int divisorAlwaysSmallest = YES;
    for(int i = 0; i < 100 ; ++i){
        [fact generateNewFactors];
        if (fact.missingNumberPosition == RZMissingNumberPositionFactorTwo) {
            for (NSNumber *choice in [fact getAnswerChoices:4]) {
                if ([choice compare:[fact expectedMissingNumberValue]] == NSOrderedAscending) {
                    divisorAlwaysSmallest = NO;
                    break;
                }
            }
        }
    }
    
    STAssertFalse(divisorAlwaysSmallest, @"In 100 tries, the divisor was always the smallest value choice, making that too freakin easy");
    STAssertFalse(divisorAlwaysSmallest, @"In 100 tries, the quotient was always the smallest value choice, making that too freakin easy");
    
    
    
}

- (void)testMinuendIsNotAlwaysGreatestValueAnswerChoice
{
    RZMissingNumberEquation *fact = [self setUpDivisionEquation];
    fact.practiceSession.practiceDivision = [NSNumber numberWithBool:NO];
    fact.practiceSession.practiceSubtraction = [NSNumber numberWithBool:YES];
    

    BOOL minuendAlwaysGreatest = YES;
    for(int i = 0; i < 100 ; ++i){
        [fact generateNewFactors];
        if (fact.missingNumberPosition == RZMissingNumberPositionFactorOne) {
            for (NSNumber *choice in [fact getAnswerChoices:4]) {
                if ([choice compare:[fact expectedMissingNumberValue]] == NSOrderedDescending) {
                    minuendAlwaysGreatest = NO;
                    break;
                }
            }
            
        }
    }
    
    STAssertFalse(minuendAlwaysGreatest, @"In 100 tries, the minuend was always the greatest value choice, making that too freakin easy");
    
    
    
}


- (void)testDifferenceIsNotAlwaysSmallestValueAnswerChoice
{
    RZMissingNumberEquation *fact = [self setUpDivisionEquation];
    fact.practiceSession.practiceDivision = [NSNumber numberWithBool:NO];
    fact.practiceSession.practiceSubtraction = [NSNumber numberWithBool:YES];
    
    BOOL differenceAlwaysSmallest = YES;
    for(int i = 0; i < 100 ; ++i){
        [fact generateNewFactors];
        if (fact.missingNumberPosition == RZMissingNumberPositionAnswer) {
            for (NSNumber *choice in [fact getAnswerChoices:4]) {
                if ([choice compare:[fact expectedMissingNumberValue]] == NSOrderedAscending) {
                    differenceAlwaysSmallest = NO;
                    break;
                }
            }
        }
    }
    
    int subtrahendAlwaysSmallest = YES;
    for(int i = 0; i < 100 ; ++i){
        [fact generateNewFactors];
        if (fact.missingNumberPosition == RZMissingNumberPositionFactorTwo) {
            for (NSNumber *choice in [fact getAnswerChoices:4]) {
                if ([choice compare:[fact expectedMissingNumberValue]] == NSOrderedAscending) {
                    subtrahendAlwaysSmallest = NO;
                    break;
                }
            }
        }
    }
    
    STAssertFalse(differenceAlwaysSmallest, @"In 100 tries, the difference was always the smallest value choice, making that too freakin easy");
    STAssertFalse(subtrahendAlwaysSmallest, @"In 100 tries, the subtrahend was always the smallest value choice, making that too freakin easy");
    
    
    
}

@end
