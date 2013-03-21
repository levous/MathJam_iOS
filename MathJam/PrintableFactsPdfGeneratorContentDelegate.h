//
//  PrintableFactsPdfGeneratorContentDelegate.h
//  MathJam
//
//  Created by Rusty Zarse on 3/21/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZPdfGenerator.h"
#import "PracticeSession.h"
@class PrintableFactsLayoutHelper;

@interface PrintableFactsPdfGeneratorContentDelegate : NSObject<RZPdfGeneratorContentDelagete>{
    PrintableFactsLayoutHelper *layoutHelper;
    CGRect containerFrame;
}

@property (strong, nonatomic) PracticeSession *practiceSession;

@end
