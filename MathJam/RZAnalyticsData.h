//
//  RZAnalyticsData.h
//  MathJam
//
//  Created by Rusty Zarse on 11/2/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RZAnalyticsData : NSObject
@property(strong, nonatomic) NSString *eventName;
@property(strong, nonatomic) NSDictionary *eventParameters;
- (void)fireAnalytics;
@end
