//
//  MissingNumberViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "MissingNumberViewController.h"
#import "RZCoreDataManager.h"
#import "RZNavigationManager.h"
#import "RZAnalyticsData.h"

@interface MissingNumberViewController ()

@end

@implementation MissingNumberViewController{
    UILabel *test;
}

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

- (void)fixButtonFonts{
    self.answerOneButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.answerTwoButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.answerThreeButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.answerFourButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    
}

- (void)preparePreviousCardTransition{
    
    if (self.previousCardImage != nil) {
        self.previousCardView = [[UIImageView alloc] initWithImage:self.previousCardImage];
        [self.cardContainerView addSubview:self.previousCardView];
    }
    
}

- (void)performPreviousCardTransition{
    if (self.previousCardView != nil) {
            
        [UIView transitionWithView:self.cardContainerView
                          duration:0.2
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations: ^{
                            [self.previousCardView removeFromSuperview];
                        }
                        completion:NULL];
    
    
       
    }
}

- (void)decorateViews{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        
        UIView *card = self.cardView;
        [card.layer setCornerRadius:8.0f];
        [card.layer setBorderColor:[UIColor whiteColor].CGColor];
        [card.layer setBorderWidth:3.0f];
       
    }
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self cleanViewControllerStack];

    // initialize core data instances if they are not passed in
    if (self.coreDataManager == nil) self.coreDataManager = [RZCoreDataManager sharedInstance];
    if (self.practiceSession == nil) self.practiceSession = [self.coreDataManager insertNewPracticeSession];
    
    [self fixButtonFonts];
    
    [self decorateViews];
        
    [self setUpMissingNumberEquation];
    
    
        
    
        
    
    [RZAnalyticsData fireAnalyticsWithEventNamed:@"MissingNumberCardViewed"];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [self preparePreviousCardTransition];
    [self performSelector:@selector(performPreviousCardTransition) withObject:nil afterDelay:0.1 ];

    
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
        [self beginCorrectAnswerAnimation];
        
    }else{
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
    RZNavigationManager *navManager = [RZNavigationManager sharedInstance];
    [navManager handleSegue:segue sender:sender];
}

- (void)nextEquation{
    
    UIGraphicsBeginImageContext(self.cardView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.cardView.layer renderInContext:context];
    self.previousCardImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    [self performNextEquationSegue];
}

- (void)performNextEquationSegue{
    [self performSegueWithIdentifier:@"nextEquationSeque" sender:self];
}

- (void)presentSessionSummary{
    [self performSegueWithIdentifier:@"showTimedPracticeSummarySegue" sender:self];   
}

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

- (void)beginCorrectAnswerAnimation {
    
    CGSize s = [self.missingNumberLabel.text sizeWithFont:self.missingNumberLabel.font constrainedToSize:CGSizeMake(300.0, MAXFLOAT) lineBreakMode:self.missingNumberLabel.lineBreakMode];
    CGRect labelFrame = self.missingNumberLabel.frame;
    self.missingNumberLabel.frame = CGRectMake(labelFrame.origin.x + (labelFrame.size.width - s.width), labelFrame.origin.y, s.width, s.height);
    
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseIn)
                     animations:^ {
                         self.missingNumberLabel.transform = CGAffineTransformRotate(CGAffineTransformIdentity, RADIANS(180));
                         //self.missingNumberLabel.alpha = 0.5;
                     }
                     completion:^ (BOOL finished){
                         [self completeCorrectAnswerAnimation];
                         [[self view] layoutIfNeeded];
                     }
     ];
}

- (void)completeCorrectAnswerAnimation {
    self.missingNumberLabel.text = self.fact.expectedMissingNumberValue.stringValue;
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseOut)
                     animations:^ {
                         self.missingNumberLabel.alpha = 1.0;
                         self.missingNumberLabel.transform = CGAffineTransformIdentity;
                         [[self view] layoutIfNeeded];
                         [[self view] setNeedsDisplay];
                         
                     
                     }
                     completion:^ (BOOL finished){
                         [self performSelector:@selector(nextEquation) withObject:nil afterDelay:0.2];
                     }
     ];
    
    
    
    
    
}





@end
