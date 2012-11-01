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
            return [NSString stringWithFormat:@"%c", 246];
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


- (NSNumber *)generateRandomFactorBetweenLowerBoundandUpperBound{
    int r = arc4random() % [[self factorOneUpperBound] integerValue];
    return [NSNumber numberWithInt:r];
}

- (void)generateFactors{
    // generically, call the factors the small number and the answer the large number
    NSNumber *theFactorOne = [self generateRandomFactorBetweenLowerBoundandUpperBound];
    NSNumber *theFactorTwo = [self generateRandomFactorBetweenLowerBoundandUpperBound];
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
                theFactorOne = [self generateRandomFactorBetweenLowerBoundandUpperBound];
            if(theFactorTwo.floatValue == 0.0)
                theFactorTwo = [self generateRandomFactorBetweenLowerBoundandUpperBound];
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
    
}

- (NSArray *)getAnswerChoices:(int)choiceCount{
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

- (BOOL) verifyAnswer:(NSNumber *)theAnswer;
{
    NSComparisonResult comparisonResult = [theAnswer compare:self.expectedMissingNumberValue];
    if(comparisonResult == NSOrderedSame) return YES;
    // anything times zero is zero
    if((self.mathOperation == RZMathOperationMultiply) && ([self.answer compare:[NSNumber numberWithInt:0]] == NSOrderedSame)){
        return YES;
        
    }
    return NO;
}

@end
