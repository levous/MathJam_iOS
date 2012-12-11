//
//  RZAppDelegate.m
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "RZAppDelegate.h"
#import "RZCoreDataManager.h"
#import "Flurry.h"
#import "RZAnalyticsData.h"
#import "RZNavigationManager.h"

@implementation RZAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // flurry analytics
    [Flurry startSession:@"KB73G65WFT7RBV828GZN"];
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
    // register for posted log analytics events
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(logAnalyticsEvent:) name:kRZ_LOG_ANALYTICS_EVENT_NOTIFICATION_NAME
                                               object:nil];

    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
    UINavigationController *navController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"mainNavigationController"];

    // log each view navigation push as a page view
    [Flurry logAllPageViews:navController];
    
    // initialize CoreData stack
    [RZCoreDataManager sharedInstance];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"clear_on_launch"]) {
        [self clearData];
    }
      
    // return to system
    return YES;
}

// Receives notification from NotificationCenter and then logs the event with flurry.
// Flurry.h header file was not visible to the SessionConfigViewController, forcing this design.  Its a cleaner separation, anyway, so no harm.
- (void)logAnalyticsEvent:(NSNotification *)notification{
    
    @try {
        NSDictionary *userInfo = [notification userInfo];
        if (userInfo != nil) {
            RZAnalyticsData *data = (RZAnalyticsData *)[userInfo objectForKey:kRZ_LOG_ANALYTICS_NOTIFICATION_DATA_KEY];
            [Flurry logEvent:data.eventName withParameters:data.eventParameters];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Flurry bombed but we try/catched it.");
    }
    @finally {
        // nothing to do...
    }

}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)clearData{
    [[RZCoreDataManager sharedInstance] clearAllData];
    RZAnalyticsData *data = [RZAnalyticsData new];
    data.eventName = @"ClearSessionData";
    [data fireAnalytics];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"clear_on_launch"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"clear_on_launch"]) {
        [self clearData];
        [[RZNavigationManager sharedInstance] presentAndResetRootView];
    }

}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

void uncaughtExceptionHandler(NSException *exception) {
    [Flurry logError:@"Uncaught" message:@"Crash!" exception:exception];
}

@end
