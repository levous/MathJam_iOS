//
//  JZTimerMan.h
//  MathJam
//
//  Created by Rusty Zarse on 12/5/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>
@protocol JZTimerManDelegate
- (void)jzTimerMan:(id)timerMan didStartSessionWithDuration:(NSTimeInterval)duration;
- (void)jzTimerMan:(id)timerMan didCompleteSessionWithTotalDuration:(NSTimeInterval)duration;
- (void)jzTimerMan:(id)timerMan didTickWithTimeRemaining:(NSTimeInterval)duration;
- (void)jzTimerMan:(id)timerMan didCancelSessionWithDurationRemaining:(NSTimeInterval)duration;

@end


@interface JZTimerMan : NSObject
@property (strong, nonatomic, readonly) NSTimer *timer, *progressTimer;

@property (strong, nonatomic, readonly) NSDate *endTime;

@property (weak, nonatomic, readonly) id<JZTimerManDelegate> timerManDelegate;
@property (strong, nonatomic) AVAudioPlayer *sessionCompleteAudioPlayer, *sessionBeginAudioPlayer;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (strong, nonatomic) UIView *splashView;
@property (weak, nonatomic) UILabel *tickLabel;
- (id)initWithDuration:(NSTimeInterval)seconds delegate:(id<JZTimerManDelegate>)delegate;
- (void)startSession;
- (void)cancelSession;
@end
