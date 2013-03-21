//
//  PrintableFactsLayoutHelperTests.m
//  MathJam
//
//  Created by Rusty Zarse on 3/21/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import "PrintableFactsLayoutHelperTests.h"
#import "PrintableFactsLayoutHelper.h"

@implementation PrintableFactsLayoutHelperTests

- (void)testCalculateFrameForEquation{
    PrintableFactsLayoutHelper *helper = [[PrintableFactsLayoutHelper alloc] initWithContainerSize:CGSizeMake(640, 940) numberOfEquations:9 columns:3];
    CGRect frame = [helper calculateFrameForEquationAtIndex:8];
    STAssertEquals(frame.origin.x,    (CGFloat)420.0,  @"x not calculated as expected");
    STAssertEquals(frame.origin.y,    (CGFloat)620.0, @"y not calculated as expected");
    STAssertEquals(frame.size.width,  (CGFloat)200.0, @"width not calculated as expected");
    STAssertEquals(frame.size.height, (CGFloat)300.0, @"height not calculated as expected");


    frame = [helper calculateFrameForEquationAtIndex:0];
    STAssertEquals(frame.origin.x,    (CGFloat)20.0,  @"x not calculated as expected");
    STAssertEquals(frame.origin.y,    (CGFloat)20.0, @"y not calculated as expected");
    STAssertEquals(frame.size.width,  (CGFloat)200.0, @"width not calculated as expected");
    STAssertEquals(frame.size.height, (CGFloat)300.0, @"height not calculated as expected");
    
    frame = [helper calculateFrameForEquationAtIndex:1];
    STAssertEquals(frame.origin.x,    (CGFloat)20.0,  @"x not calculated as expected");
    STAssertEquals(frame.origin.y,    (CGFloat)320.0, @"y not calculated as expected");
    STAssertEquals(frame.size.width,  (CGFloat)200.0, @"width not calculated as expected");
    STAssertEquals(frame.size.height, (CGFloat)300.0, @"height not calculated as expected");
    
    frame = [helper calculateFrameForEquationAtIndex:3];
    STAssertEquals(frame.origin.x,    (CGFloat)220.0,  @"x not calculated as expected");
    STAssertEquals(frame.origin.y,    (CGFloat)20.0, @"y not calculated as expected");
    STAssertEquals(frame.size.width,  (CGFloat)200.0, @"width not calculated as expected");
    STAssertEquals(frame.size.height, (CGFloat)300.0, @"height not calculated as expected");

}


@end
