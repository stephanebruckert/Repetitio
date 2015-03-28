//
//  RPWord.m
//  Repetitio
//
//  Created by Stephane Bruckert on 3/17/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//

#import "RPWord.h"

@implementation RPWord

@dynamic word;
@dynamic trans;
@dynamic smEF;
@dynamic smReps;
@dynamic smInterval;
@dynamic smNextDate;
@dynamic smPrevDate;

- (NSString *)description {
    return [NSString stringWithFormat: @"name=%@ inter=%@ EF=%@ reps=%@ nextday=%@ prevdate=%@", self.word, self.smInterval, self.smEF, self.smReps, self.smNextDate, self.smPrevDate];
}

- (void)update:(int)grade {
    if (grade <= 0) {
        grade = 0;
    }
    [self calcIntervalEF:grade];
}

- (void)calcIntervalEF:(int)grade {
    NSNumber *oldEF = self.smEF;
    NSNumber *newEF;
    
    if (grade < 3) {
        self.smReps = 0;
        self.smInterval = 0;
    } else {
        newEF = @(oldEF.floatValue + (0.1 - (5-grade)*(0.08+(5-grade)*0.02)));
        NSLog(@"newEF: %@", newEF);
        if (newEF.floatValue < 1.3) { // 1.3 is the minimum EF
            self.smEF = [[NSNumber alloc] initWithFloat:1.3];
        } else {
            self.smEF = newEF;
        }
        self.smReps = [[NSNumber alloc] initWithInt:1];
        
        switch (self.smReps.intValue) {
            case 1:
                self.smInterval = [[NSNumber alloc] initWithInt:1];
                break;
            case 2:
                self.smInterval = [[NSNumber alloc] initWithInt:6];
                break;
            default:
                self.smInterval = [[NSNumber alloc] initWithFloat:ceil((self.smReps.intValue - 1) * self.smEF.floatValue)];
                break;
        }
    }
    
    if (grade == 3) {
        self.smInterval = 0;
    }
    
    self.smNextDate = [[NSDate date] dateByAddingTimeInterval:(60*60*24*self.smInterval.intValue)];
    [self.managedObjectContext save:nil];
}

@end
