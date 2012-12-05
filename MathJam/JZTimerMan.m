//
//  JZTimerMan.m
//  MathJam
//
//  Created by Rusty Zarse on 12/5/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "JZTimerMan.h"
@implementation JZTimerMan

- (id)initWithDuration:(NSTimeInterval)seconds{
    if(self = [super init]){
        _duration = seconds;
        self.audioPlayer = [self defaultAudioPlayer];
    }
    return self;
}

- (void)startSession{
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(timerComplete:) userInfo:nil repeats:NO];
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
