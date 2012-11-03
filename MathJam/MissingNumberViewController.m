//
//  MissingNumberViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "MissingNumberViewController.h"
#import "RZCoreDataManager.h"

@interface MissingNumberViewController ()

@end

@implementation MissingNumberViewController
int wrongAnswerCount = 0;

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
    
    //TODO: refactor this logic into a model class and out of the view controller
    //. perhaps an equation factory
    self.fact = [RZMissingNumberEquation new];
    
    // pass core data stuff
    self.fact.practiceSession = self.practiceSession;
    self.fact.coreDataManager = self.coreDataManager;

    
    [self.fact generateNewFactors];
    
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


- (void)cleanViewControllerStack
{
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *viewControllers = [NSMutableArray array];
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if (![vc isKindOfClass:self.class]) {
            [viewControllers addObject:vc];
        }
    }
    [viewControllers addObject:self];
    self.navigationController.viewControllers = viewControllers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self cleanViewControllerStack];

    // initialize core data instances if they are not passed in
    if (self.coreDataManager == nil) self.coreDataManager = [RZCoreDataManager sharedInstance];
    if (self.practiceSession == nil) self.practiceSession = [self.coreDataManager insertNewPracticeSession];
    
    
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
        ++wrongAnswerCount;
        [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
}

- (void)didConfigureSession:(id)sender{
    // reset start time to disinclude config setting time
    self.practiceSession.startTime = [NSDate date];
    [self nextEquation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"nextEquationSeque"])
    {
        // Get reference to the destination view controller
        MissingNumberViewController *vc = [segue destinationViewController];
        
        // Pass practice session to the next view controller
        vc.practiceSession = self.practiceSession;
    }else if([[segue identifier] isEqualToString:@"showSessionConfigSeque"]){
        // close current session, start a new one
        self.practiceSession = [self.coreDataManager insertCopyOfPracticeSession:self.practiceSession];
        
        UIViewController *vc = [segue destinationViewController];
        if([vc respondsToSelector:@selector(setPracticeSession:)]){
            [vc performSelector:@selector(setPracticeSession:) withObject:self.practiceSession];
        }
        if([vc respondsToSelector:@selector(setDelegate:)]){
            [vc performSelector:@selector(setDelegate:) withObject:self];
        }
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
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveLinear)
                     animations:^ {
                         self.missingNumberLabel.transform = CGAffineTransformIdentity;
                     }
                     completion:NULL
     ];
    
    [self performSelector:@selector(nextEquation) withObject:nil afterDelay:0.2];

    
    
    
}

@end
