//
//  RPWord.h
//  Repetitio
//
//  Created by Stephane Bruckert on 3/17/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface RPWord : NSManagedObject

@property (strong, nonatomic) NSString *trans;
@property (strong, nonatomic) NSString *word;
@property (strong, nonatomic) NSNumber *smEF;
@property (strong, nonatomic) NSNumber *smReps;
@property (strong, nonatomic) NSNumber *smInterval;
@property (strong, nonatomic) NSDate *smNextDate;
@property (strong, nonatomic) NSDate *smPrevDate;

- (NSString *)description;
- (void)update:(int)grade;
- (void)calcIntervalEF:(int)grade;
@end
