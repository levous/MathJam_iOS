//
//  RZNumericKeyboardUtility.h
//  MathJam
//
//  Created by Rusty Zarse on 11/1/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RZNumericKeyboardHelper : NSObject<UITextFieldDelegate>

- (void)attachDelagateToTextFields:(NSArray *)textFields;
- (void)detachListener;
@end
