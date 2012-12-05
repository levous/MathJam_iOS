//
//  RZNavigationManager.m
//  MathJam
//
//  Created by Rusty Zarse on 11/21/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "RZNavigationManager.h"
#import "MissingNumberViewController.h"
#import "SessionConfigViewController.h"
#import "TimedSessionViewController.h"
#import "BarChartViewControllerDelegate.h"

@implementation RZNavigationManager

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *vcFrom  = [segue sourceViewController];
    UIViewController *vcTo = [segue destinationViewController];
    
    MissingNumberViewController *mnvcFrom = (MissingNumberViewController *)vcFrom;
    MissingNumberViewController *mnvcTo = (MissingNumberViewController *)vcTo;
    
    if([[segue identifier] isEqualToString:@"showSessionConfigSeque"])
    {
        
        // close current session, start a new one
        PracticeSession *newSession = [mnvcFrom.coreDataManager insertCopyOfPracticeSession:mnvcFrom.practiceSession];
        mnvcFrom.practiceSession = newSession;
        SessionConfigViewController *svcTo = (SessionConfigViewController *)vcTo;
        svcTo.delegate = (id<SessionConfigDelegate>)mnvcFrom;
        svcTo.practiceSession = mnvcFrom.practiceSession;
        
    }
    else if ([[segue identifier] isEqualToString:@"nextEquationSeque"])
    {
        mnvcTo.practiceSession = mnvcFrom.practiceSession;
        mnvcTo.coreDataManager = mnvcFrom.coreDataManager;
        mnvcTo.timerMan = mnvcFrom.timerMan;
        

    }
    else if(([[segue identifier] isEqualToString:@"showChartSeque"]))
    {
        BarChartViewControllerDelegate *barChartDelegate = [[BarChartViewControllerDelegate alloc] init];
        barChartDelegate.coreDataManager = mnvcFrom.coreDataManager;
        [barChartDelegate regenerateValues];
        [segue.destinationViewController setFrd3dBarChartDelegate:barChartDelegate];
        
    }
    else if(([[segue identifier] isEqualToString:@"showTimedPracticeSeque"]))
    {
        TimedSessionViewController *timedSessionVC = (TimedSessionViewController *)vcTo;
        timedSessionVC.missingNumberViewController = mnvcFrom;
        
    }


}

@end
