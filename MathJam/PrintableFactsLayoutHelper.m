//
//  PrintableFactsLayoutHelper.m
//  MathJam
//
//  Created by Rusty Zarse on 3/21/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import "PrintableFactsLayoutHelper.h"

@implementation PrintableFactsLayoutHelper

static CGFloat OUTSIDE_MARGIN = 20.0;

- (id)initWithContainerSize:(CGSize)p_containerSize numberOfEquations:(int)p_numberOfEquations columns:(int)numberOfColumns{
    self = [self init];
    if(self){
        self.numberOfEquations = p_numberOfEquations;
        self.columns = numberOfColumns;
        self.containerSize = p_containerSize;
        columnWidth = ((self.containerSize.width - (OUTSIDE_MARGIN * 2)) / self.columns);
        rowHeight = ((self.containerSize.height - (OUTSIDE_MARGIN * 2)) / (self.numberOfEquations / self.columns));
        equationsPerColumn = (int)ceil(self.numberOfEquations / self.columns);
    }
    return self;
}

- (CGRect)calculateFrameForEquationAtIndex:(int)equationIdx{
    
    float x,y;

    // calculate column index
    CGFloat columnIdx = floor(equationIdx / equationsPerColumn);
    // calculate x position
    x = (columnIdx) * columnWidth + OUTSIDE_MARGIN;
    // calculate y position
    y = ((equationIdx - (columnIdx * equationsPerColumn)) * rowHeight) + 20;
    
    
    
    return CGRectMake(x,y,columnWidth,rowHeight);

}

@end
