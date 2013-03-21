//
//  PrintableFactsLayoutHelper.h
//  MathJam
//
//  Created by Rusty Zarse on 3/21/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrintableFactsLayoutHelper : NSObject{
    CGFloat columnWidth, rowHeight, equationsPerColumn;
}

@property CGSize containerSize;
@property int columns;
@property int numberOfEquations;

- (id)initWithContainerSize:(CGSize)p_containerSize numberOfEquations:(int)p_numberOfEquations columns:(int)numberOfColumns;
- (CGRect)calculateFrameForEquationAtIndex:(int)equationIdx;

@end
