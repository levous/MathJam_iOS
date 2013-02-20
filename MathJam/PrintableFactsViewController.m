//
//  PrintableFactsViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 2/15/13.
//  Copyright (c) 2013 Levous, LLC. All rights reserved.
//

#import "PrintableFactsViewController.h"

@interface PrintableFactsViewController ()

@end

@implementation PrintableFactsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    [self loadEquationLabels];
}

- (void)loadEquationLabels{
    int idx = 0;
    float rowHeight = 26.0;
    float x,y,w,h;
    w = 150.0, h = 40.0;
    RZMissingNumberEquation *equation = [[RZMissingNumberEquation alloc] init];
    equation.practiceSession = self.practiceSession;
    for(idx = 0;idx < 30;++idx){
        [equation generateNewFactors];
        if (idx < 15){
            x = 20.0;
            y = (idx * rowHeight) + 20;
        }else{
            x = 180.0;
            y = ((idx - 15) * rowHeight) + 20.0;
        }
        
        CGRect frame = CGRectMake(x,y,w,h);
        UILabel *label = [[UILabel alloc] initWithFrame:frame];
        label.text = [[equation toText] stringByReplacingOccurrencesOfString:@"?" withString:@"___"];
        label.font = [UIFont fontWithName:kRZ_DEFAULT_FONT_NAME size:12.0];
        [self.view addSubview:label];
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
