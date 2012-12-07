//
//  JZTimerMan.m
//  MathJam
//
//  Created by Rusty Zarse on 12/5/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "JZTimerMan.h"
#import <QuartzCore/QuartzCore.h>

@implementation JZTimerMan

- (id)initWithDuration:(NSTimeInterval)seconds{
    if(self = [super init]){
        _duration = seconds;
        self.audioPlayer = [self defaultAudioPlayer];
    }
    return self;
}

//TODO: refactor this UI access out of the timer man and into a delegate
- (void)showTimerSplash{
    UIViewController *container = [[UIViewController alloc] init];
    [[NSBundle mainBundle] loadNibNamed:@"TimerSplashView" owner:container options:nil];
    
    self.splashView = container.view;
    
    UIWindow *mainWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:0];
    
    
    // so naughty.  Really need to wire this up properly
    //TODO: wire up the box view with a proper class.
    UIView *box = [[[self.splashView.subviews objectAtIndex:0] subviews] objectAtIndex:0];
    [box.layer setCornerRadius:30.0f];
    [box.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [box.layer setBorderWidth:1.0f];
    [box.layer setShadowColor:[UIColor blackColor].CGColor];
    [box.layer setShadowOpacity:0.5];
    [box.layer setShadowRadius:3.0];
    [box.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    [mainWindow addSubview:self.splashView];
    
    [UIView animateWithDuration:0.2
                          delay:0.5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.splashView.alpha = 0.0;
                     }
                     completion:^(BOOL finished){
                         [self.splashView removeFromSuperview];
                     }
     ];
    
    
}


- (void)startSession{
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(timerComplete:) userInfo:nil repeats:NO];
    [self showTimerSplash];
    
}

- (AVAudioPlayer *)defaultAudioPlayer{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DogBark" ofType:@"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
    AVAudioPlayer *theAudio=[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    theAudio.volume = 1.0;
    [theAudio prepareToPlay];
    return theAudio;
    
}

- (void)playAlarmSound{
    [self.audioPlayer play];
    
}

- (void)timerComplete:(NSTimer*)theTimer{
    [self playAlarmSound];
    [[[UIAlertView alloc] initWithTitle:@"Timer Alert" message:@"Nice job, JACKSON!" delegate:nil cancelButtonTitle:@"Bark" otherButtonTitles:nil] show];
    
       
}

@end
