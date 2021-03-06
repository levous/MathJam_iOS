//
//  RZAnalyticsData.m
//  MathJam
//
//  Created by Rusty Zarse on 11/2/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "RZAnalyticsData.h"

@implementation RZAnalyticsData

+ (void)fireAnalyticsWithEventNamed:(NSString *)eventName{
    RZAnalyticsData *data = [RZAnalyticsData new];
    data.eventName = eventName;
    [data fireAnalytics];
}

+ (void)fireAnalyticsWithEventNamed:(NSString *)eventName andParameters:(NSDictionary *)params{
    RZAnalyticsData *data = [RZAnalyticsData new];
    data.eventName = eventName;
    data.eventParameters = params;
    [data fireAnalytics];
}

- (void)fireAnalytics{
    [[NSNotificationCenter defaultCenter] postNotificationName:kRZ_LOG_ANALYTICS_EVENT_NOTIFICATION_NAME object:nil userInfo:[NSDictionary dictionaryWithObject:self forKey:kRZ_LOG_ANALYTICS_NOTIFICATION_DATA_KEY]];
}



@end

