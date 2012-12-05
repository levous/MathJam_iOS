//
//  BarChartViewControllerDelegate.h
//  TestCharting
//
//  Created by Rusty Zarse on 11/20/12.
//  Copyright (c) 2012 Rusty Zarse. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRD3DBarChartViewController.h"
#import "RZCoreDataManager.h"

@interface BarChartViewControllerDelegate : NSObject<FRD3DBarChartViewControllerDelegate>
@property(strong, nonatomic) RZCoreDataManager *coreDataManager;
@property(strong, nonatomic) NSDateFormatter *dateFormatter;
@property(strong, nonatomic) NSNumberFormatter *numberFormatter;

-(void) regenerateValues;

@end
