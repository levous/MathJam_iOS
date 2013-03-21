//
//  PrintableFactsPdfGeneratorContentDelegate.m
//  MathJam
//
//  Created by Rusty Zarse on 3/21/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import "PrintableFactsPdfGeneratorContentDelegate.h"
#import "PrintableFactsLayoutHelper.h"
#import "RZMissingNumberEquation.h"

@implementation PrintableFactsPdfGeneratorContentDelegate

static int kRZ_NUMBER_OF_EQUATIONS = 30;

- (void)rzpdf_DrawContentInRectangle:(CGRect)contentFrame{
    containerFrame = contentFrame;
    layoutHelper = [[PrintableFactsLayoutHelper alloc] initWithContainerSize:contentFrame.size numberOfEquations:30 columns:3];
    [self drawEquations];
}

- (void)drawEquations{
    int idx = 0;
    
    RZMissingNumberEquation *equation = [[RZMissingNumberEquation alloc] init];
    equation.practiceSession = self.practiceSession;
    for(idx = 0;idx < kRZ_NUMBER_OF_EQUATIONS;++idx){
        [equation generateNewFactors];
        CGRect frame = [layoutHelper calculateFrameForEquationAtIndex:idx];
        CGRect offsetFrame = CGRectOffset(frame, containerFrame.origin.x, containerFrame.origin.y);
        
        UIFont *font = [UIFont fontWithName:kRZ_DEFAULT_FONT_NAME size:16.0];
        
        NSString *equationText = [[equation toText] stringByReplacingOccurrencesOfString:@"?" withString:@"____"];
        
        //CGSize stringSize = [equationText sizeWithFont:font
        //                           constrainedToSize:frame.size //CGSizeMake(containerFrame.size.width, containerFrame.size.height)
        //                               lineBreakMode:NSLineBreakByWordWrapping];
        
        
        // CGRect renderingRect = CGRectMake(kBorderInset + kMarginInset, kBorderInset + kMarginInset + 50.0, pageSize.width - 2*kBorderInset - 2*kMarginInset, stringSize.height);
        
        [equationText drawInRect:offsetFrame
                      withFont:font
                 lineBreakMode:NSLineBreakByWordWrapping
                     alignment:NSTextAlignmentLeft];
        
    }
    
}

@end
