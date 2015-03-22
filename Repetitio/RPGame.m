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

- (id)initWithManagedObjectContext:(NSManagedObjectContext*) managedObjectContext
{
    self = [super init];
    if (self)
    {
        // Initialize Fetch Request
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"RPItem"];
        
        // Add Sort Descriptors
        [fetchRequest setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"level" ascending:YES]]];
        
        NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:nil];
        
        // Perform Fetch
        NSError *error = nil;
        [fetchedResultsController performFetch:&error];
        
        if (error) {
            NSLog(@"Unable to perform fetch.");
            NSLog(@"%@, %@", error, error.localizedDescription);
        }
        
        //NSLog(@".... ingredient count = %lu", (unsigned long)[fetchedResultsController.fetchedObjects count]);

        if ([fetchedResultsController.fetchedObjects count] < 10) {
            self.words = fetchedResultsController.fetchedObjects;
            self.largeArray = [[NSMutableArray alloc] initWithArray:self.words];
        } else {
            self.words = fetchedResultsController.fetchedObjects;
            self.largeArray = [[NSMutableArray alloc] initWithArray:self.words];
        }
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
    NSMutableArray* fourAnswers = [[NSMutableArray alloc] initWithArray:[allAnswersWithoutTheAnswer subarrayWithRange:NSMakeRange(0, MIN(3, allAnswersWithoutTheAnswer.count))]];
    [fourAnswers addObject:word];
    [fourAnswers shuffle];
    return fourAnswers;
}

- (RPWord*)getRandomQuestion {
    [self.largeArray shuffle];
    return [self.largeArray objectAtIndex:0];
}

- (id)objectAtIndex:(NSUInteger)index {
    return [self objectAtIndex:index];
}

@end
