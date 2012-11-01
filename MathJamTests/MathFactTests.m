//
//  MathFactTests.m
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "MathFactTests.h"
#import "RZMissingNumberEquation.h"
@implementation MathFactTests
- (void)testSetup
{
    RZMissingNumberEquation *fact = RZMissingNumberEquation.new;
    fact.factorOneUpperBound = [NSNumber numberWithInt:12];
    fact.factorTwoUpperBound = [NSNumber numberWithInt:10];
    fact.factorOneLowerBound = [NSNumber numberWithInt:2];
    fact.factorTwoLowerBound = [NSNumber numberWithInt:5];
    [fact generateFactors];
    STAssertEquals(NSOrderedAscending, [fact.factorOne compare:[NSNumber numberWithInt:13]], @"factor should have been 12 or less");
    STAssertEquals(NSOrderedDescending, [fact.factorOne compare:[NSNumber numberWithInt:1]], @"factor should have been 2 or more");
    STAssertEquals(NSOrderedAscending, [fact.factorTwo compare:[NSNumber numberWithInt:11]], @"factor should have been 10 or less");
    STAssertEquals(NSOrderedDescending, [fact.factorTwo compare:[NSNumber numberWithInt:4]], @"factor should have been 5 or more");

}
@end
