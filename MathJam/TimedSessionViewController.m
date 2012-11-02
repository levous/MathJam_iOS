//
//  TimedSessionViewController.m
//  MathJam
//
//  Created by Rusty Zarse on 11/1/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "TimedSessionViewController.h"

@interface TimedSessionViewController ()

@end

@implementation TimedSessionViewController

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
    
    // if iPhone 4 or older
    CGRect pickerFrame = self.minutesPicker.frame;
    self.minutesPicker.frame = CGRectMake(pickerFrame.origin.x, pickerFrame.origin.y - 85, pickerFrame.size.width, pickerFrame.size.height);

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Picker View

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)thePickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"1 Minute";
    }
    return [NSString stringWithFormat:@"%i Minutes", row + 1];
}

- (void)pickerView:(UIPickerView *)thePickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSLog(@"%i Minute(s)", row + 1);
}

#pragma mark - Switches

- (IBAction)timedSwitchChanged:(id)sender {
    float opacity = (((UISwitch *) sender).on) ? 1.0 : 0.0;
    [UIView beginAnimations:nil context:nil];
    self.minutesPicker.alpha = opacity;
    [UIView commitAnimations];
}

- (IBAction)cancelPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end