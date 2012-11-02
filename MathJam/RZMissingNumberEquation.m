//
//  MathFact.m
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "RZMissingNumberEquation.h"

#import <stdlib.h>

@implementation RZMissingNumberEquation

#pragma mark - Read-Only Properties

- (NSString *)factorOneText{
    if (self.missingNumberPosition == RZMissingNumberPositionFactorOne) {
        return @"?";
    }
    return self.factorOne.stringValue;
}

- (NSString *)factorTwoText{
    if (self.missingNumberPosition == RZMissingNumberPositionFactorTwo) {
        return @"?";
    }
    return self.factorTwo.stringValue;
}

- (NSString *)answerText{
    if (self.missingNumberPosition == RZMissingNumberPositionAnswer) {
        return @"?";
    }
    return self.answer.stringValue;
}

- (NSString *)mathOperationText{
    switch (self.mathOperation) {
        case RZMathOperationAdd:
            return @"+";
            break;
        case RZMathOperationSubtract:
            return @"-";
            break;
        case RZMathOperationDivide:
            return @"÷";
            break;
        case RZMathOperationMultiply:
            return @"x";
            break;
            
        default:
            break;
    }
}

- (NSNumber *)expectedMissingNumberValue{
    switch (self.missingNumberPosition) {
        case RZMissingNumberPositionFactorOne:
            return self.factorOne;
            break;
        case RZMissingNumberPositionFactorTwo:
            return self.factorTwo;
            break;
        default:
            return self.answer;
    } 
    
}


#pragma mark - Initialization Methods

- (id)init{
    if (self = [super init]) {
        
    }
    return self;
}

- (RZMathOperation)performRandomOperationSelection{
    // prevent infinite loop
    if(!(self.practiceSession.practiceAddition.boolValue ||
       self.practiceSession.practiceSubtraction.boolValue ||
       self.practiceSession.practiceMultiplication.boolValue ||
       self.practiceSession.practiceDivision.boolValue)){
        self.practiceSession.practiceMultiplication = [NSNumber numberWithBool:YES];
    }
    
    // randomize 4 choices...
    int r = (arc4random() % 4);
    RZMathOperation op = (RZMathOperation)r;
    
    // ensure its enabled
    switch (op) {
        case RZMathOperationAdd:
            if (self.practiceSession.practiceAddition.boolValue) {
                return op;
            }
            break;
        case RZMathOperationSubtract:
            if (self.practiceSession.practiceSubtraction.boolValue) {
                return op;
            }
            break;
        case RZMathOperationMultiply:
            if (self.practiceSession.practiceMultiplication.boolValue) {
                return op;
            }
            break;
        case RZMathOperationDivide:
            if (self.practiceSession.practiceDivision.boolValue) {
                return op;
            }
            break;
        default:
            break;
            
    }
    // try again (warning: infinite lop potential)
    return [self performRandomOperationSelection];
}

- (NSNumber *)generateRandomFactorBetweenLowerBound:(NSNumber *)lowerBound andUpperBound:(NSNumber *)upperBound{
   
    int rangeValue = upperBound.integerValue - lowerBound.integerValue + 1;
    int r = arc4random() % rangeValue;
    return [NSNumber numberWithInt:r + lowerBound.integerValue];
}

- (void)configurePerformanceDataEntity{
    // if there was an entity already in process, this will leave it in the managed context but no longer associated with the missing number equation
    self.mathEquation = [self.coreDataManager insertNewMathEquationInSession:self.practiceSession withFactorOne:self.factorOne factorTwo:self.factorTwo operation:self.mathOperation];
}

- (void)generateNewFactors{
    self.mathOperation = [self performRandomOperationSelection];
    
    // generically, call the factors the small number and the answer the large number
    NSNumber *theFactorOne = [self generateRandomFactorBetweenLowerBound:self.practiceSession.factorOneLowerBound andUpperBound:self.practiceSession.factorOneUpperBound];
    NSNumber *theFactorTwo = [self generateRandomFactorBetweenLowerBound:self.practiceSession.factorTwoLowerBound andUpperBound:self.practiceSession.factorTwoUpperBound];
    NSNumber *theAnswer = nil;
    
    // prevent impossible divide by zero
    if (self.mathOperation == RZMathOperationDivide) {
        int loopCount = 0;
        while (theFactorOne.floatValue == 0.0 || theFactorTwo.floatValue == 0.0 ) {
            
            if(loopCount > 10){
                // 10 has no significance. If we've tried several times to generate a factor that's not zero and keep getting zero, something else is jsut wrong.  Abort
                return;
            }
            
            if(theFactorOne.floatValue == 0.0)
                theFactorOne = [self generateRandomFactorBetweenLowerBound:self.practiceSession.factorOneLowerBound andUpperBound:self.practiceSession.factorOneUpperBound];
            if(theFactorTwo.floatValue == 0.0)
                theFactorTwo = [self generateRandomFactorBetweenLowerBound:self.practiceSession.factorTwoLowerBound andUpperBound:self.practiceSession.factorTwoUpperBound];
        }
    }
    
    switch (self.mathOperation) {
        case RZMathOperationSubtract:
            // fall through
        case RZMathOperationAdd:
            theAnswer = [NSNumber numberWithFloat:(theFactorOne.floatValue + theFactorTwo.floatValue)];
            break;
        case RZMathOperationDivide:
            //fall through
        case RZMathOperationMultiply:
            theAnswer = [NSNumber numberWithFloat:(theFactorOne.floatValue * theFactorTwo.floatValue)];
            break;
        default:
            break;
    }
    
    switch (self.mathOperation) {
        case RZMathOperationDivide:
            //fall through
        case RZMathOperationSubtract:
            self.factorOne = theAnswer;
            self.factorTwo = theFactorOne;
            self.answer = theFactorTwo;
            break;

        case RZMathOperationAdd:
            //fall through
        case RZMathOperationMultiply:
            self.factorOne = theFactorOne;
            self.factorTwo = theFactorTwo;
            self.answer = theAnswer;
            break;
            
        default:
            break;
    }
    
    [self configurePerformanceDataEntity];
}


#pragma mark - Behavior Methods


- (NSArray *)getAnswerChoices:(int)choiceCount{
    //TODO: add logic for division so that the answer isn't always the largest number
    NSMutableArray *choices = [NSMutableArray new];
    int idx;
    int correctAnswerIdx = arc4random() % choiceCount;
    int upperThreshold = self.factorOne.integerValue;
    if (upperThreshold < self.factorTwo.integerValue) upperThreshold = self.factorTwo.integerValue;
    if (upperThreshold < self.answer.integerValue) upperThreshold = self.answer.integerValue;
    upperThreshold++;
    
    for(idx = 0; idx < choiceCount; ++idx){
        if(correctAnswerIdx == idx){
            [choices addObject:self.expectedMissingNumberValue];
        }else{
            int r = arc4random() % upperThreshold;
            // avoid having the correct answer twice...  prolly want to be more clever and prevent any number twice....
            if (r == self.expectedMissingNumberValue.integerValue) r = arc4random() % upperThreshold;

            [choices addObject:[NSNumber numberWithInt:r]];
        }
    }
    return [NSArray arrayWithArray:choices];
}


- (void)incrementWrongAnswerCount{
    int count = self.mathEquation.wrongAnswerCount.integerValue;
    ++count;
    self.mathEquation.wrongAnswerCount = [NSNumber numberWithInt:count];
}

- (void)recordSuccessPerformanceData{
    NSDate *endTime = [NSDate date];
    self.mathEquation.answeredCorrectlyAt = endTime;
    // ending the session with each successful answer but continuing to use the session until its released.
    self.practiceSession.endTime = endTime; 
    NSError *error = nil;
    if (![self.coreDataManager save:&error]){
        NSLog(@"CoreData Save FAILED: %@", error.localizedDescription);
    }
}


- (BOOL)verifyAnswer:(NSNumber *)theAnswer;
{
    BOOL isCorrect = NO;
    
    NSComparisonResult comparisonResult = [theAnswer compare:self.expectedMissingNumberValue];
    if(comparisonResult == NSOrderedSame) isCorrect = YES;
    // anything times zero is zero
    if( !isCorrect && (self.mathOperation == RZMathOperationMultiply) && ([self.answer compare:[NSNumber numberWithInt:0]] == NSOrderedSame)){
        isCorrect = YES;
    }
    if (isCorrect) {
        [self recordSuccessPerformanceData];
        return YES;
    }
    
    // wrong answer, chumpity
    [self incrementWrongAnswerCount];
    return NO;
}

@end
