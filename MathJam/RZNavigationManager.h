//
//  RZNavigationManager.h
//  MathJam
//
//  Created by Rusty Zarse on 11/21/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RZCoreDataManager.h"
#import "JZTimerMan.h"

@interface RZNavigationManager : UINavigationController<JZTimerManDelegate>

+ (RZNavigationManager *)sharedInstance;

@property(weak, nonatomic) UINavigationController *navigationController;

- (void)handleSegue:(UIStoryboardSegue *)segue sender:(id)sender;

- (void)presentSessionSummary;

@end
