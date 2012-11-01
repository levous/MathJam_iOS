//
//  MissingNumberViewController
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RZMissingNumberEquation.h"

@interface MissingNumberViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *factOneLabel;
@property (weak, nonatomic) IBOutlet UILabel *factTwoLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationLabel;
@property (weak, nonatomic) IBOutlet UIButton *answerOneButton;
@property (weak, nonatomic) IBOutlet UIButton *answerTwoButton;
@property (weak, nonatomic) IBOutlet UIButton *answerThreeButton;
@property (weak, nonatomic) IBOutlet UIButton *answerFourButton;
@property (strong, nonatomic) RZMissingNumberEquation *fact;

@property (weak, nonatomic) UILabel *missingNumberLabel;

- (IBAction)answerPressed:(id)sender;


@end