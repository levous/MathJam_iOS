//
//  RZNavigationManager.m
//  MathJam
//
//  Created by Rusty Zarse on 11/21/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "RZNavigationManager.h"

#import "Constants.h"
#import "MissingNumberViewController.h"
#import "SessionConfigViewController.h"
#import "TimedSessionViewController.h"
#import "BarChartViewControllerDelegate.h"
#import "TimerSplashViewController.h"
#import "TimedSessionSummaryViewController.h"
#import "PrintableFactsViewController.h"

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

- (id)init{
    if( self = [super init])
    {
        UIViewController *rootViewController = [self mainWindow].rootViewController;
        // the rootViewController appears to be a nav controller.  This might be a brittle assumption
        self.navigationController = (UINavigationController *)rootViewController;
    }
    return self;
}

#pragma mark - Seque Management

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
        mnvcTo.previousCardImage = mnvcFrom.previousCardImage;

    }
    else if([[segue identifier] isEqualToString:@"showChartSeque"])
    {
        BarChartViewControllerDelegate *barChartDelegate = [[BarChartViewControllerDelegate alloc] init];
        barChartDelegate.coreDataManager = mnvcFrom.coreDataManager;
        [barChartDelegate regenerateValues];
        [segue.destinationViewController setFrd3dBarChartDelegate:barChartDelegate];
        
    }
    else if([[segue identifier] isEqualToString:@"showTimedPracticeSeque"])
    {
        TimedSessionViewController *timedSessionVC = (TimedSessionViewController *)vcTo;
        timedSessionVC.timedSessionConfigDelegate = (id<TimedSessionConfigDelegate>)mnvcFrom;
        if ([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
            timedSessionVC.parentPopoverController = [(UIStoryboardPopoverSegue *)segue popoverController];
        }
        
    }
    else if([[segue identifier] isEqualToString:@"showTimedPracticeSummarySegue"])
    {
        TimedSessionSummaryViewController *tsvc = (TimedSessionSummaryViewController *)vcTo;
        tsvc.practiceSession = mnvcFrom.practiceSession;
    }
    else if([[segue identifier] isEqualToString:@"printableEquationsSegue"]){
        PrintableFactsViewController *pevc = (PrintableFactsViewController *)vcTo;
        pevc.practiceSession = mnvcFrom.practiceSession;
    }
}


#pragma mark -

- (void)endCurrentSession{
    // this is really not appreopriate here
    //TODO: refactor to move session management responsbility out of nav mgr
    UIViewController *topController = self.navigationController.topViewController;
    if ([topController isKindOfClass:[MissingNumberViewController class]]) {
        [[((MissingNumberViewController *)topController) practiceSession] setEndTime:[NSDate date]];
    }
}

- (void)presentSessionSummary{
    UIViewController *topController = self.navigationController.topViewController;
    if ([topController isKindOfClass:[MissingNumberViewController class]]) {
        [((MissingNumberViewController *)topController) presentSessionSummary];
    }
}

- (void)presentNextEquation{
    UIViewController *topController = self.navigationController.topViewController;
    if ([topController isKindOfClass:[MissingNumberViewController class]]) {
        [((MissingNumberViewController *)topController) nextEquation];
    }
}

- (void)presentRootView{
    [[self navigationController] popToRootViewControllerAnimated:YES];
}

- (void)presentAndResetRootView{
    // slightly hacky
    // pop to root 
    [self presentRootView];
    // its a missing number vc :)
    MissingNumberViewController *vc = (MissingNumberViewController *)[self.navigationController topViewController];
    // reset the cdm (this is to prevent core data refs from going kaboom when deleting data history
    vc.coreDataManager = [RZCoreDataManager sharedInstance];
    // copy the practice session to retain values
    vc.practiceSession = [vc.coreDataManager insertNewPracticeSession];
    // transition to new vc to pick up new details
    [self presentNextEquation];
}
 
- (UIWindow *)mainWindow{
    return [[[UIApplication sharedApplication] windows] objectAtIndex:0];
}

#pragma mark - JZTimerManDelegate


- (void)showTimerSplash{
    TimerSplashViewController *controller = [[TimerSplashViewController alloc] initWithNibName:@"TimerSplashViewController" bundle:nil];
    
    UIView *splashView = controller.view;
    splashView.alpha = 0.0;

    UIView *box = controller.box;
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
                                              [self presentNextEquation];
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
    tickLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 20.0, 30.0, 15.0)];
    tickLabel.textAlignment = NSTextAlignmentCenter;
    tickLabel.backgroundColor = [UIColor colorWithRed:255.0 green:255.0 blue:255.0 alpha:0.4];
    tickLabel.textColor = [UIColor grayColor];
    tickLabel.font = [UIFont fontWithName:kRZ_DEFAULT_FONT_NAME size:8.0];
    tickLabel.userInteractionEnabled = NO;
    
    [[self mainWindow] addSubview:tickLabel];
    
}

- (void)jzTimerMan:(id)timerMan didCompleteSessionWithTotalDuration:(NSTimeInterval)duration{
    [tickLabel removeFromSuperview];
    [self endCurrentSession];
    [self presentSessionSummary];
}


- (void)jzTimerMan:(id)timerMan didCancelSessionWithDurationRemaining:(NSTimeInterval)duration{
    [tickLabel removeFromSuperview];
}

- (void)jzTimerMan:(id)timerMan didTickWithTimeRemaining:(NSTimeInterval)duration{
    tickLabel.text = [NSString stringWithFormat:@"%i sec", (int)duration];
}


@end
