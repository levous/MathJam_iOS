//
//  PracticeSession+Analytics.m
//  MathJam
//
//  Created by Rusty Zarse on 11/2/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "PracticeSession+Analytics.h"

@implementation PracticeSession (Analytics)
- (NSDictionary *)dictionaryForAnalytics{
    return 
    [NSDictionary dictionaryWithObjectsAndKeys:
        self.factorOneLowerBound,    @"FactorOneLB", 
        self.factorOneUpperBound,    @"FactorOneUB", 
        self.factorTwoLowerBound,    @"FactorTwoLB", 
        self.factorTwoUpperBound,    @"FactorTwoUB",
        self.practiceAddition,       @"Addition",  
        self.practiceSubtraction,    @"Subtraction",        
        self.practiceMultiplication, @"Multiplication",      
        self.practiceDivision,       @"Division",  
     nil];
}
@end
