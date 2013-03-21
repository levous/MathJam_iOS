//
//  RZPdfGenerator.h
//  MathJam
//
//  Created by Rusty Zarse on 3/21/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RZPdfGeneratorContentDelagete
- (void)rzpdf_DrawContentInRectangle:(CGRect)contentFrame;
@end

@interface RZPdfGenerator : NSObject{
    CGSize pageSize;
}

@property id<RZPdfGeneratorContentDelagete>contentDelegate;
- (NSString *) demoPdf;
- (void) generatePdfWithFilePath: (NSString *)thefilePath;

@end
