//
//  JZTimerMan.h
//  MathJam
//
//  Created by Rusty Zarse on 12/5/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@interface JZTimerMan : NSObject
@property (strong, nonatomic, readonly) NSTimer *timer, *progressTimer;
@property (strong, nonatomic) AVAudioPlayer *audioPlayer;
@property (nonatomic, readonly) NSTimeInterval duration;
@property (weak, nonatomic) UILabel *tickLabel;
- (id)initWithDuration:(NSTimeInterval)seconds;
- (void)startSession;
@end
