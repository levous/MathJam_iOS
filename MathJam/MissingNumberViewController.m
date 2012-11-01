//
//  MissingNumberViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "MissingNumberViewController.h"


@interface MissingNumberViewController ()

@end

@implementation MissingNumberViewController

- (UILabel *)missingNumberLabel{
    switch (self.fact.missingNumberPosition){
        case RZMissingNumberPositionFactorOne:
            return self.factOneLabel;
            break;
        case RZMissingNumberPositionFactorTwo:
            return self.factTwoLabel;
            break;
        default:
            return self.answerLabel;
            break;
    }
}

- (void)setUpMissingNumberEquation{
    self.fact = [RZMissingNumberEquation new];
    self.fact.mathOperation = RZMathOperationMultiply;
    
    self.fact.factorOneUpperBound = [NSNumber numberWithInt:12];
    self.fact.factorOneLowerBound = [NSNumber numberWithInt:1];
    self.fact.factorTwoUpperBound = [NSNumber numberWithInt:12];
    self.fact.factorTwoLowerBound = [NSNumber numberWithInt:1];
    [self.fact generateFactors];
    
    self.factOneLabel.text = self.fact.factorOneText;
    self.factTwoLabel.text = self.fact.factorTwoText;
    self.answerLabel.text = self.fact.answerText;
    
    self.operationLabel.text = self.fact.mathOperationText;
    
    NSArray *answerChoices = [self.fact getAnswerChoices:4];
    [self.answerOneButton setTitle:((NSNumber *)[answerChoices objectAtIndex:0]).stringValue forState:UIControlStateNormal];
    [self.answerTwoButton setTitle:((NSNumber *)[answerChoices objectAtIndex:1]).stringValue forState:UIControlStateNormal];
    [self.answerThreeButton setTitle:((NSNumber *)[answerChoices objectAtIndex:2]).stringValue forState:UIControlStateNormal];
    [self.answerFourButton setTitle:((NSNumber *)[answerChoices objectAtIndex:3]).stringValue forState:UIControlStateNormal];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self setUpMissingNumberEquation];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)answerPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSNumber *selectedAnswer = [NSNumber numberWithFloat:[button.currentTitle floatValue]];
    if([self.fact verifyAnswer:selectedAnswer]){
        [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self startCorrectAnswerAnimation];
        
    }else{
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)nextEquation{
    [self performSegueWithIdentifier:@"nextEquationSeque" sender:self];
}

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

- (void)startCorrectAnswerAnimation {
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction)
                     animations:^ {
                         self.missingNumberLabel.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(180));
                     }
                     completion:^ (BOOL finished){
                         [self completeCorrectAnswerAnimation];
                     }
     ];
}

- (void)completeCorrectAnswerAnimation {
    self.missingNumberLabel.text = self.fact.expectedMissingNumberValue.stringValue;
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear)
                     animations:^ {
                         self.missingNumberLabel.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL
     ];
    
    [self performSelector:@selector(nextEquation) withObject:nil afterDelay:0.3];

    
    
    
}

@end
