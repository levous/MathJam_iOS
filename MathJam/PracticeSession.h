//
//  PracticeSession.h
//  MathJam
//
//  Created by Rusty Zarse on 11/1/12.
//  Copyright (c) 2012 Levous, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MathEquation;

@interface PracticeSession : NSManagedObject

@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * endTime;
@property (nonatomic, retain) NSNumber * factorOneLowerBound;
@property (nonatomic, retain) NSNumber * factorTwoLowerBound;
@property (nonatomic, retain) NSNumber * factorOneUpperBound;
@property (nonatomic, retain) NSNumber * factorTwoUpperBound;
@property (nonatomic, retain) NSNumber * practiceMultiplication;
@property (nonatomic, retain) NSNumber * practiceAddition;
@property (nonatomic, retain) NSNumber * practiceDivision;
@property (nonatomic, retain) NSNumber * practiceSubtraction;
@property (nonatomic, retain) NSOrderedSet *equations;
@end

@interface PracticeSession (CoreDataGeneratedAccessors)

- (void)insertObject:(MathEquation *)value inEquationsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromEquationsAtIndex:(NSUInteger)idx;
- (void)insertEquations:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeEquationsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInEquationsAtIndex:(NSUInteger)idx withObject:(MathEquation *)value;
- (void)replaceEquationsAtIndexes:(NSIndexSet *)indexes withEquations:(NSArray *)values;
- (void)addEquationsObject:(MathEquation *)value;
- (void)removeEquationsObject:(MathEquation *)value;
- (void)addEquations:(NSOrderedSet *)values;
- (void)removeEquations:(NSOrderedSet *)values;
@end
