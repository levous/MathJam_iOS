//
//  MathFact.h
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZCoreDataManager.h"
#import "RZEnums.h"

// enum RZMissingNumberPosition ------------------------------------------------
typedef NS_ENUM(NSInteger, RZMissingNumberPosition) {RZMissingNumberPositionFactorOne, RZMissingNumberPositionFactorTwo, RZMissingNumberPositionAnswer};

//------------------------------------------------------------------------------
//  This class represents an equation that will be used to test math facts.  The term "factor" generally refers to one of the two numbers enlisted in the equation to produce the answer.
//
@interface RZMissingNumberEquation : NSObject

// establish the working parameters for generating an equation.  
@property (strong, nonatomic) NSNumber *answer;

// factors, operation and answer
@property (strong, nonatomic) NSNumber *factorOne;
@property (strong, nonatomic) NSNumber *factorTwo;

@property (nonatomic) RZMathOperation mathOperation;

// missing number details
@property (strong, nonatomic, readonly) NSNumber *expectedMissingNumberValue;
@property (nonatomic) RZMissingNumberPosition missingNumberPosition;

// user performance data / core data
@property (weak, nonatomic) RZCoreDataManager *coreDataManager;
@property (weak, nonatomic) PracticeSession *practiceSession;
@property (weak, nonatomic) MathEquation *mathEquation;


// provide text for display
@property (nonatomic, readonly, weak) NSString *factorOneText, *factorTwoText, *answerText, *mathOperationText;

// Initializes the equation with a new set of factors/answer
- (void)generateNewFactors;

// Returns an array containing the requested number of answer choices of which one is the correct answer
- (NSArray *)getAnswerChoices:(int)choiceCount;

// Checks the provided number and returns YES if the number matches the expected value
- (BOOL) verifyAnswer:(NSNumber *)answer;





@end
