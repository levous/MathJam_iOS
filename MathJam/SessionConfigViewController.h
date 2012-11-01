//
//  SessionConfigViewController.h
//  MathJam
//
//  Created by Rusty Zarse on 11/1/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PracticeSession.h"

@interface SessionConfigViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISwitch *plusSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *minusSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *timesSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *divideSwitch;

@property (weak, nonatomic) IBOutlet UITextField *factorOneLowerBound;
@property (weak, nonatomic) IBOutlet UITextField *factorTwoLowerBound;
@property (weak, nonatomic) IBOutlet UITextField *factorOneUpperBound;
@property (weak, nonatomic) IBOutlet UITextField *factorTwoUpperBound;


@property (strong, nonatomic) PracticeSession *practiceSession;




@end
