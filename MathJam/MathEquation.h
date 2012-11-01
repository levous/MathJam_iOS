//
//  MathEquation.h
//  MathJam
//
//  Created by Rusty Zarse on 11/1/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PracticeSession;

@interface MathEquation : NSManagedObject

@property (nonatomic, retain) NSNumber * factorOne;
@property (nonatomic, retain) NSNumber * factorTwo;
@property (nonatomic, retain) NSNumber * operation;
@property (nonatomic, retain) NSNumber * wrongAnswerCount;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSDate * answeredCorrectlyAt;
@property (nonatomic, retain) PracticeSession *session;

@end
