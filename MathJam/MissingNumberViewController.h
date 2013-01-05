//
//  MissingNumberViewController
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZMissingNumberEquation.h"
#import "RZCoreDataManager.h"
#import "JZTimerMan.h"
#import "RZViewControllerBase.h"

@interface MissingNumberViewController : RZViewControllerBase
@property (weak, nonatomic) IBOutlet UILabel *factOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *factTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerOneButton;
@property (weak, nonatomic) IBOutlet UIButton *answerTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *answerThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *answerFourButton;
@property (weak, nonatomic) IBOutlet UIView *cardView;
@property (weak, nonatomic) IBOutlet UIView *cardContainerView;
@property (strong, nonatomic) UIImage *previousCardImage;
@property (strong, nonatomic) UIView *previousCardView;

@property (strong, nonatomic) JZTimerMan *timerMan;
@property (strong, nonatomic) RZCoreDataManager *coreDataManager;

@property (strong, nonatomic) RZMissingNumberEquation *fact;

@property (strong, nonatomic) PracticeSession *practiceSession;

@property (weak, nonatomic) UILabel *missingNumberLabel;

- (IBAction)answerPressed:(id)sender;

- (void)nextEquation;

- (void)presentSessionSummary;

@end
