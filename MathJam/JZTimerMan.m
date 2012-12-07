//
//  JZTimerMan.m
//  MathJam
//
//  Created by Rusty Zarse on 12/5/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import "JZTimerMan.h"
@implementation JZTimerMan{
    NSDate *completeTime;
    
}

- (id)initWithDuration:(NSTimeInterval)seconds
{
    if(self = [super init]){
        _duration = seconds;
        self.audioPlayer = [self defaultAudioPlayer];
    }
    return self;
}

- (void)startSession{
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(timerComplete:) userInfo:nil repeats:NO];
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    completeTime = [NSDate dateWithTimeIntervalSinceNow:self.duration];
    self.tickLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100.0, 50.0)];
    
    
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
              
- (void)timerTick:(NSTimer*)theTimer{
    
}

@end
