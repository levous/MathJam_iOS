//
//  PrintableFactsViewController.h
//  MathJam
//
//  Created by Rusty Zarse on 2/15/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RZMissingNumberEquation.h"
#import "PracticeSession.h"

@interface PrintableFactsViewController : UIViewController
@property (strong, nonatomic) PracticeSession *practiceSession;
@end

