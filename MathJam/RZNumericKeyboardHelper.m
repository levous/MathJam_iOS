//
//  RZNumericKeyboardUtility.m
//  MathJam
//
//  Created by Rusty Zarse on 11/1/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

//NOTE: Slightly concerned that arc will not retain things through run loop cycles.  If this is failing or crashing with memory access exceptions, investigate both the editingTextField and this class as consumed by viewControllers
#import "RZNumericKeyboardHelper.h"

@implementation RZNumericKeyboardHelper
UITextField *editingTextField;
id<UITextFieldDelegate> proxiedDelegate;

- (void)attachDelegateToTextFields:(NSArray *)textFields withProxiedDelegate:(id<UITextFieldDelegate>)aProxiedDelegate{
    
    // allows each delegate method to call through after managing the keyboard nonsense
    proxiedDelegate = aProxiedDelegate;
    
    // add observer for the respective notifications (depending on the os version)
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardDidShow:)
													 name:UIKeyboardDidShowNotification
												   object:nil];
	} else {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(keyboardWillShow:)
													 name:UIKeyboardWillShowNotification
												   object:nil];
	}
    
    for (UITextField *textField in textFields){
        textField.delegate = self;
    }
    
}

- (void)detachListener{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITextFieldDelegate

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    editingTextField = textField;
    if (proxiedDelegate && [proxiedDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [proxiedDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (proxiedDelegate && [proxiedDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [proxiedDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (proxiedDelegate && [proxiedDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [proxiedDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (proxiedDelegate && [proxiedDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [proxiedDelegate textFieldDidEndEditing:textField];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (proxiedDelegate && [proxiedDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [proxiedDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if (proxiedDelegate && [proxiedDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [proxiedDelegate textFieldShouldClear:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (proxiedDelegate && [proxiedDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [proxiedDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

#pragma mark - Keyboard Management

- (void)keyboardWillShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] < 3.2) {
		[self addButtonToKeyboard];
	}
}

- (void)keyboardDidShow:(NSNotification *)note {
	// if clause is just an additional precaution, you could also dismiss it
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
		[self addButtonToKeyboard];
    }
}

- (void)addButtonToKeyboard {
	// create custom button
	UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
	doneButton.frame = CGRectMake(0, 163, 106, 53);
	doneButton.adjustsImageWhenHighlighted = NO;
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0) {
		[doneButton setImage:[UIImage imageNamed:@"DoneUp3.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown3.png"] forState:UIControlStateHighlighted];
	} else {
		[doneButton setImage:[UIImage imageNamed:@"DoneUp.png"] forState:UIControlStateNormal];
		[doneButton setImage:[UIImage imageNamed:@"DoneDown.png"] forState:UIControlStateHighlighted];
	}
	[doneButton addTarget:self action:@selector(doneButton:) forControlEvents:UIControlEventTouchUpInside];
	// locate keyboard view
    
	UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
	UIView* keyboard;
	for(int i=0; i<[tempWindow.subviews count]; i++) {
		keyboard = [tempWindow.subviews objectAtIndex:i];
		// keyboard found, add the button
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.2) {
			if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
				[keyboard addSubview:doneButton];
		} else {
			if([[keyboard description] hasPrefix:@"<UIKeyboard"] == YES)
				[keyboard addSubview:doneButton];
		}
	}
}


- (void)doneButton:(id)sender {
    [editingTextField resignFirstResponder];
}

#pragma mark - Clean Up

- (void)dealloc{
    [self detachListener];
}


@end
