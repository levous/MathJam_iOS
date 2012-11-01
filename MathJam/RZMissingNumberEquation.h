//
//  MathFact.h
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RZMathOperation) {RZMathOperationAdd, RZMathOperationSubtract, RZMathOperationMultiply, RZMathOperationDivide};
typedef NS_ENUM(NSInteger, RZMissingNumberPosition) {RZMissingNumberPositionFactorOne, RZMissingNumberPositionFactorTwo, RZMissingNumberPositionAnswer};

@interface RZMissingNumberEquation : NSObject
@property (weak, nonatomic) NSNumber *factorOneUpperBound;
@property (weak, nonatomic) NSNumber *factorTwoUpperBound;
@property (weak, nonatomic) NSNumber *factorOneLowerBound;
@property (weak, nonatomic) NSNumber *factorTwoLowerBound;

@property (strong, nonatomic) NSNumber *factorOne;
@property (strong, nonatomic) NSNumber *factorTwo;
@property (strong, nonatomic) NSNumber *answer;
@property (nonatomic) RZMathOperation mathOperation;
@property (strong, nonatomic, readonly) NSNumber *expectedMissingNumberValue;
@property (nonatomic) RZMissingNumberPosition missingNumberPosition;

@property (nonatomic, readonly, weak) NSString *factorOneText, *factorTwoText, *answerText, *mathOperationText;

- (void)generateFactors;

- (NSArray *)getAnswerChoices:(int)choiceCount;
- (BOOL) verifyAnswer:(NSNumber *)answer;




@end
