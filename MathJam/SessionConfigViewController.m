//
//  SessionConfigViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 11/1/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "SessionConfigViewController.h"
#import "RZNumericKeyboardHelper.h"

@interface SessionConfigViewController ()

@end

@implementation SessionConfigViewController

RZNumericKeyboardHelper *keyboardHelper;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    if (keyboardHelper == nil) {
        keyboardHelper = [RZNumericKeyboardHelper new];
    }
    [keyboardHelper attachDelagateToTextFields:[NSArray arrayWithObjects:self.factorOneLowerBound, self.factorTwoLowerBound, self.factorOneUpperBound, self.factorTwoUpperBound, nil]];
    
    
        
    self.factorOneLowerBound.text = self.practiceSession.factorOneLowerBound.stringValue;
    self.factorOneUpperBound.text = self.practiceSession.factorOneUpperBound.stringValue;
    self.factorTwoLowerBound.text = self.practiceSession.factorTwoLowerBound.stringValue;
    self.factorTwoUpperBound.text = self.practiceSession.factorTwoUpperBound.stringValue;
    
    [self.plusSwitch setOn:self.practiceSession.practiceAddition.boolValue animated:animated];
    [self.minusSwitch setOn:self.practiceSession.practiceSubtraction.boolValue animated:animated];
    [self.timesSwitch setOn:self.practiceSession.practiceMultiplication.boolValue animated:animated];
    [self.divideSwitch setOn:self.practiceSession.practiceDivision.boolValue animated:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [keyboardHelper detachListener];
    
    self.practiceSession.factorOneLowerBound = [NSNumber numberWithInteger:self.factorOneLowerBound.text.integerValue];
    self.practiceSession.factorOneUpperBound = [NSNumber numberWithInteger:self.factorOneUpperBound.text.integerValue];
    self.practiceSession.factorTwoLowerBound = [NSNumber numberWithInteger:self.factorTwoLowerBound.text.integerValue];
    self.practiceSession.factorTwoUpperBound = [NSNumber numberWithInteger:self.factorTwoUpperBound.text.integerValue];
    self.practiceSession.practiceAddition = [NSNumber numberWithBool:self.plusSwitch.on];
    self.practiceSession.practiceSubtraction = [NSNumber numberWithBool:self.minusSwitch.on];
    self.practiceSession.practiceMultiplication = [NSNumber numberWithBool:self.timesSwitch.on];
    self.practiceSession.practiceDivision = [NSNumber numberWithBool:self.divideSwitch.on];
    
    if (self.delegate != nil) {
        [self.delegate didConfigureSession:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
