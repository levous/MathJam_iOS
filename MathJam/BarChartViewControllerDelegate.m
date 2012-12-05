//
//  BarChartViewControllerDelegate.m
//  TestCharting
//
//  Created by Rusty Zarse on 11/20/12.
//  Copyright (c) 2012 Rusty Zarse. All rights reserved.
//

#import "BarChartViewControllerDelegate.h"
#import "PracticeSession+ComputedValues.h"

NSMutableArray *_vals = nil;



@implementation BarChartViewControllerDelegate{

    float _max;
    
}

- (id)init{
    if(self = [super init]){
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd h:mm"];
        
        self.numberFormatter = [[NSNumberFormatter alloc] init];
        [self.numberFormatter setPositiveFormat:@"###0.#"];
        
    }
    return self;
}

-(int) frd3DBarChartViewControllerNumberRows:(FRD3DBarChartViewController *)frd3DBarChartViewController
{
    return 1;
}

-(int) frd3DBarChartViewControllerNumberColumns:(FRD3DBarChartViewController *)frd3DBarChartViewController
{
    return _vals.count;
}


-(float) frd3DBarChartViewController:(FRD3DBarChartViewController *)frd3DBarChartViewController valueForBarAtRow:(int)row column:(int)column
{
    return [[[_vals objectAtIndex:column] valueForKey:@"equations_per_minute"] floatValue];
}

-(float) frd3DBarChartViewControllerMaxValue:(FRD3DBarChartViewController *)frd3DBarChartViewController
{
    return _max;
}

-(float) frd3DBarChartViewController:(FRD3DBarChartViewController *)frd3DBarChartViewController percentSizeForBarAtRow:(int)row column:(int)column
{
    return 1.0;
}


-(NSString *)frd3DBarChartViewController:(FRD3DBarChartViewController *)frd3DBarChartViewController legendForColumn:(int)column
{
    
    NSDictionary *hash = [_vals objectAtIndex:column];
    float eqPerMinute = [[hash valueForKey:@"equations_per_minute"] floatValue];
    
    
    NSString *columnLabel = [NSString stringWithFormat:@"%@",
                             [self.numberFormatter stringFromNumber:[NSNumber numberWithFloat:eqPerMinute]]
                             ];
    
    return columnLabel;
}

-(NSString *) frd3DBarChartViewController:(FRD3DBarChartViewController *)frd3DBarChartViewController legendForRow:(int)row
{
    return @"APM";
}

-(UIColor *) frd3DBarChartViewController:(FRD3DBarChartViewController *)frd3DBarChartViewController colorForBarAtRow:(int)row column:(int)column
{
    int quarter = (int)((column % 12 )/ 3.0);
    
    UIColor *color = [UIColor colorWithHue:0.2 + quarter / 8.0 saturation:1.0 brightness:1.0 alpha:1.0];
    return color;
    
}

-(NSString *) frd3DBarChartViewController:(FRD3DBarChartViewController *)frd3DBarChartViewController legendForValueLine:(int)line
{
    int lineValue = (_max / 5) * (line + 1);
    return [NSString stringWithFormat:@"%i", lineValue];
}

-(int) frd3DBarChartViewControllerNumberHeightLines:(FRD3DBarChartViewController *)frd3DBarChartViewController
{
    return 5;
}

-(void) regenerateValues
{
    NSArray *allPracticeSessions = [self.coreDataManager getAllPracticeSessions];
    
    _max = 0.0;
    _vals = [NSMutableArray array];
    for(PracticeSession *practiceSession in allPracticeSessions){
        if (practiceSession.equations != nil) {
            NSDictionary *hash = [NSMutableDictionary dictionary];
            int totalCount = practiceSession.equations.count;
            float equationsPerMinute = [practiceSession equationsPerMinute];
            [hash setValue:[NSNumber numberWithInteger:totalCount] forKey:@"total_count"];
            [hash setValue:practiceSession.endTime forKey:@"end_time"];
            [hash setValue:[NSNumber numberWithFloat:equationsPerMinute] forKey:@"equations_per_minute"];
            
            [_vals addObject:hash];
            _max = MAX(_max, (int)equationsPerMinute);
            
        }
    
    }
    
    if(_max == 0) _max = 1;
    // set max to something divisible by 5
    _max = (((int)(_max / 5)) + 1) * 5;
}

@end
