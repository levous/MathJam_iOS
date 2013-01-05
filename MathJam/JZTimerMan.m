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

- (id)initWithDuration:(NSTimeInterval)seconds delegate:(id<JZTimerManDelegate>)delegate
{
    if(self = [super init]){
        _duration = seconds;
        _timerManDelegate = delegate;
        [self initDefaultAudioPlayers];
    }
    return self;
}


- (void)initDefaultAudioPlayers{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DogBark" ofType:@"mp3"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
    AVAudioPlayer *theAudio=[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    theAudio.volume = 1.0;
    [theAudio prepareToPlay];
    
    self.sessionCompleteAudioPlayer = theAudio;
    
    path = [[NSBundle mainBundle] pathForResource:@"go" ofType:@"wav"];
    fileURL = [[NSURL alloc] initFileURLWithPath: path];
    theAudio=[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    theAudio.volume = 1.0;
    [theAudio prepareToPlay];
    
    self.sessionBeginAudioPlayer = theAudio;
    
}

- (void)playStartSound{
    [self.sessionBeginAudioPlayer play];
    
}

- (void)playAlarmSound{
    [self.sessionCompleteAudioPlayer play];
    
}


- (void)startSession{
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.duration target:self selector:@selector(timerComplete:) userInfo:nil repeats:NO];
    _endTime = [NSDate dateWithTimeIntervalSinceNow:self.duration];
    _progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerTick:) userInfo:nil repeats:YES];
    completeTime = [NSDate dateWithTimeIntervalSinceNow:self.duration];
    
    if (self.timerManDelegate != nil) {
        [self.timerManDelegate jzTimerMan:self didStartSessionWithDuration:self.duration];
    }
    
    [self playStartSound];
}

- (void)cancelSession{
    [self.timer invalidate];
    [self.progressTimer invalidate];
    if (self.timerManDelegate != nil) {
        [self.timerManDelegate jzTimerMan:self didCancelSessionWithDurationRemaining:[self.endTime timeIntervalSinceNow]];
    }
}


- (void)timerComplete:(NSTimer*)theTimer{
    [self playAlarmSound];
    if (self.timerManDelegate != nil) {
        [self.timerManDelegate jzTimerMan:self didCompleteSessionWithTotalDuration:self.duration];
    }
       
}
              
- (void)timerTick:(NSTimer*)theTimer{
    if (self.timerManDelegate != nil) {
        [self.timerManDelegate jzTimerMan:self didTickWithTimeRemaining:[self.endTime timeIntervalSinceNow]];
    }

}

@end
