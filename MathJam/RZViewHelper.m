//
//  RZViewHelper.m
//  MathJam
//
//  Created by Rusty Zarse on 1/15/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import "RZViewHelper.h"

@interface RZViewHelper ()

@end

@implementation RZViewHelper

+ (CGRect)windowFrame{
    UIWindow *window = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    return window.frame;
}

+ (UIFont *)defaultFont{
    return [UIFont fontWithName:kRZ_DEFAULT_FONT_NAME size:10.0];
}

@end
