//
//  RPGame.m
//  Repetitio
//
//  Created by Stephane Bruckert on 3/17/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//
#import <CoreData/CoreData.h>

#import "RPGame.h"
#import "NSMutableArray_Shuffling.h"

@interface RPGame ()

@end

@implementation RPGame

@synthesize progress;
@synthesize step;
@synthesize wrong_answers;
@synthesize successful_answers;
@synthesize last_was_success;
@synthesize maxSteps;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*) managedObjectContext
{
    self = [super init];
    if (self)
    {
        NSLog(@"hoihoi");
        // Initialize Fetch Request
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RPItem"];
        
        // Add Sort Descriptors
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES]]];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        // Perform Fetch
        NSError *error = nil;
        [fetchedResultsController performFetch:&error];
        
        if (error) {
            NSLog(@"Unable to perform fetch.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        
        //NSLog(@".... ingredient count = %lu", (unsigned long)[fetchedResultsController.fetchedObjects count]);

        self.words = fetchedResultsController.fetchedObjects;
        self.largeArray = [[NSMutableArray alloc] initWithArray:self.words];
        
        step = 1;
        wrong_answers = 0;
        successful_answers = 0;
        last_was_success = YES;
        maxSteps = [self quizCount];
        [self incrementProgress];
    }
    return self;
}

- (NSUInteger)count {
    return [self count];
}

- (NSArray*)getUpTo4RandomAnswers:(RPWord*)word {
    [self.largeArray shuffle];
    
    NSMutableArray* allAnswersWithoutTheAnswer = [NSMutableArray arrayWithArray:self.largeArray];
    [allAnswersWithoutTheAnswer removeObject:word];
    
    NSMutableArray* fourAnswers = [[NSMutableArray alloc] initWithArray:[allAnswersWithoutTheAnswer subarrayWithRange:NSMakeRange(0, MIN(4, allAnswersWithoutTheAnswer.count))]];
    [fourAnswers addObject:word];
    [fourAnswers shuffle];
    return fourAnswers;
}

- (RPWord*)getRandomQuestion {
    [self.largeArray shuffle];
    NSLog(@"%@",self.largeArray);
    return [self.largeArray objectAtIndex:0];
}

- (id)objectAtIndex:(NSUInteger)index {
    return [self objectAtIndex:index];
}

- (int)quizCount {
    int count = 0;
    NSDateComponents *components = [[NSCalendar currentCalendar]
                                    components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                    fromDate:[NSDate date]];
    NSDate *today = [[NSCalendar currentCalendar] dateFromComponents:components];
    for (int i=0; i< _words.count; i++) {
        RPWord* word = [self words][i];
        NSDateComponents *components = [[NSCalendar currentCalendar]
                                        components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                        fromDate:[word smNextDate]];
        NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:components];
        if ([today isEqualToDate:startDate]) {
            count++;
        }
    }
    return count;
}

- (void)endGame {
    /* reinitiliaze parameters for next game */
    [self incrementProgress];
    step = 1;
    wrong_answers = 0;
    successful_answers = 0;
}

- (void)incrementProgress {
    progress += 1./maxSteps;
}

@end
