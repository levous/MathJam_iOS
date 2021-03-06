//
//  SessionConfigViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 11/1/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "SessionConfigViewController.h"
#import "RZNumericKeyboardHelper.h"
#import "PracticeSession+Analytics.h"
#import "RZAnalyticsData.h"

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
    [super viewWillAppear:animated];
	// Do any additional setup after loading the view.
    if (keyboardHelper == nil) {
        keyboardHelper = [RZNumericKeyboardHelper new];
    }
    [keyboardHelper attachDelegateToTextFields:[NSArray arrayWithObjects:self.factorOneLowerBound, self.factorTwoLowerBound, self.factorOneUpperBound, self.factorTwoUpperBound, nil] withProxiedDelegate:self];
        
    self.factorOneLowerBound.text = self.practiceSession.factorOneLowerBound.stringValue;
    self.factorOneUpperBound.text = self.practiceSession.factorOneUpperBound.stringValue;
    self.factorTwoLowerBound.text = self.practiceSession.factorTwoLowerBound.stringValue;
    self.factorTwoUpperBound.text = self.practiceSession.factorTwoUpperBound.stringValue;
    
    [self.plusSwitch setOn:self.practiceSession.practiceAddition.boolValue animated:animated];
    [self.minusSwitch setOn:self.practiceSession.practiceSubtraction.boolValue animated:animated];
    [self.timesSwitch setOn:self.practiceSession.practiceMultiplication.boolValue animated:animated];
    [self.divideSwitch setOn:self.practiceSession.practiceDivision.boolValue animated:animated];
    
    
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (self.factorOneLowerBound.text.integerValue > self.factorOneUpperBound.text.integerValue || self.factorTwoLowerBound.text.integerValue > self.factorTwoUpperBound.text.integerValue) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops..." message:@"[Something] to [something else] usually means the first thing is smaller.  Can you make the first number smaller or equal to the second?  please..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }

    if (self.factorOneLowerBound.text.length > 3 ||
        self.factorTwoLowerBound.text.length > 3 ||
        self.factorOneUpperBound.text.length > 3 ||
        self.factorTwoUpperBound.text.length > 3
        
        ) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops..." message:@"Sorry, we jusrt can't fit numbers that large into the buttons.  Could you limit your practice to three digit factors or smaller?  please..." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        return NO;
    }

    return YES;
}


#pragma mark - Analytics

// method posts notification with notification center.  For some strange reason, the SessionConfigViewController couldn't see the Flurry.h header.
// Rather then waste time trying to diagnose xcode nonesense, used NC.  Cleaner architecture anyway
- (void)logAnalytics:(PracticeSession *)session{
    RZAnalyticsData *data = [RZAnalyticsData new];
    data.eventName = @"PracticeSessionConfig";
    data.eventParameters = [session dictionaryForAnalytics];
    [[NSNotificationCenter defaultCenter] postNotificationName:kRZ_LOG_ANALYTICS_EVENT_NOTIFICATION_NAME object:nil userInfo:[NSDictionary dictionaryWithObject:data forKey:kRZ_LOG_ANALYTICS_NOTIFICATION_DATA_KEY]];
    
}


#pragma mark - Completion

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
    
    [self logAnalytics:self.practiceSession];
    
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
