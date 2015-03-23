//
//  RPGame.h
//  Repetitio
//
//  Created by Stephane Bruckert on 3/17/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPWord.h"

@interface RPGame : NSObject {
    RPGame *currentGame;
}

@property (strong, nonatomic) NSArray *words;
@property (strong, nonatomic) NSMutableArray *largeArray;
@property (nonatomic) float progress;
@property (nonatomic) int step;
@property (nonatomic) int wrong_answers;
@property (nonatomic) int successful_answers;
@property (assign, nonatomic) BOOL last_was_success;
@property (nonatomic) int maxSteps;

+ (id)sharedManager:(NSManagedObjectContext*) managedObjectContext;
- (id)initWithManagedObjectContext:(NSManagedObjectContext*) managedObjectContext;
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (NSArray*)getUpTo4RandomAnswers:(RPWord*)word;
- (RPWord*)getRandomQuestion;
- (void)endGame;
- (void)incrementProgress;

@end