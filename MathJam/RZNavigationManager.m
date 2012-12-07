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
#import "TimerSplashViewController.h"

@implementation RZNavigationManager{
    UILabel *tickLabel;
}

static RZNavigationManager *sharedInstance = nil;


+ (RZNavigationManager *)sharedInstance {
    if (nil != sharedInstance) {
        return sharedInstance;
    }
    
    static dispatch_once_t pred;        // Lock
    dispatch_once(&pred, ^{             // This code is called at most once per app
        sharedInstance = [[RZNavigationManager alloc] init];
    });
    
    return sharedInstance;
}

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

- (UIWindow *)mainWindow{
    return [[[UIApplication sharedApplication] windows] objectAtIndex:0];
}

#pragma mark - JZTimerManDelegate


- (void)showTimerSplash{
    TimerSplashViewController *controller = [[TimerSplashViewController alloc] initWithNibName:@"TimerSplashViewController" bundle:nil];
    
    UIView *splashView = controller.view;
    

    UIView *box = controller.box;
    [box.layer setCornerRadius:30.0f];
    [box.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [box.layer setBorderWidth:1.0f];
    [box.layer setShadowColor:[UIColor blackColor].CGColor];
    [box.layer setShadowOpacity:0.5];
    [box.layer setShadowRadius:3.0];
    [box.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    splashView.alpha = 0.0;
    
    CGRect newBoxFrame = box.frame;
    newBoxFrame.origin.y = -newBoxFrame.size.height;
    
    
    [[self mainWindow] addSubview:splashView];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         splashView.alpha = 0.7;
                         [box.layer setShadowRadius:7.0];
                     }
                     completion:^(BOOL finished){
    
                         
                         [UIView animateWithDuration:0.2
                                               delay:0.3
                                             options:UIViewAnimationOptionCurveEaseInOut
                                          animations:^{
                                              splashView.alpha = 0.0;
                                              box.frame = newBoxFrame;
                                          }
                                          completion:^(BOOL finished){
                                              [splashView removeFromSuperview];
                                          }
                          ];
                         
                     }
     ];

    
    
    
    
}

- (void)jzTimerMan:(id)timerMan didStartSessionWithDuration:(NSTimeInterval)duration{
    [self showTimerSplash];
    if (tickLabel != nil) {
        [tickLabel removeFromSuperview];
    }
    tickLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 20.0, 70.0, 20.0)];
    tickLabel.backgroundColor = [UIColor clearColor];
    tickLabel.textColor = [UIColor grayColor];
    tickLabel.font = [UIFont fontWithName:@"ChalkboardSE-Regular" size:8.0];
    tickLabel.userInteractionEnabled = NO;
    [[self mainWindow] addSubview:tickLabel];
    
}

- (void)jzTimerMan:(id)timerMan didCompleteSessionWithTotalDuration:(NSTimeInterval)duration{
    [tickLabel removeFromSuperview];
}


- (void)jzTimerMan:(id)timerMan didCancelSessionWithDurationRemaining:(NSTimeInterval)duration{
    [tickLabel removeFromSuperview];
}

- (void)jzTimerMan:(id)timerMan didTickWithTimeRemaining:(NSTimeInterval)duration{
    tickLabel.text = [NSString stringWithFormat:@"%i sec", (int)duration];
}


@end
