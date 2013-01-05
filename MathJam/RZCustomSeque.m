//
//  RZCustomSeque.m
//  MathJam
//
//  Created by Rusty Zarse on 10/31/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "RZCustomSeque.h"
#import "MissingNumberViewController.h"

@implementation RZCustomSeque
- (void) perform {
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad ){
        [self iPadPerform];
        //[self iPhonePerform];
    }else{
        [self iPhonePerform];
    }
}


- (void)iPadPerform{
    MissingNumberViewController *src = (MissingNumberViewController *) self.sourceViewController;
    MissingNumberViewController *dst = (MissingNumberViewController *) self.destinationViewController;
    
    UIView *oldCardView = src.cardView;
    
    [src.navigationController pushViewController:dst animated:NO];
    
    dst.previousCardView = oldCardView;
        
}


- (void)iPhonePerform{
    UIViewController *src = (UIViewController *) self.sourceViewController;
    UIViewController *dst = (UIViewController *) self.destinationViewController;
    
    [UIView transitionWithView:src.navigationController.view duration:0.2
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{
                        [src.navigationController pushViewController:dst animated:NO];
                    }
                    completion:NULL];
    
}
@end
