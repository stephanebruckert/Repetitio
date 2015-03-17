//
//  RPGame.h
//  Repetitio
//
//  Created by Stephane Bruckert on 3/17/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPWord.h"

@interface RPGame : NSObject

@property (strong, nonatomic) NSArray *words;
@property (strong, nonatomic) NSMutableArray *largeArray;

- (id)initWithManagedObjectContext:(NSManagedObjectContext*) managedObjectContext;
- (NSUInteger)count;
- (id)objectAtIndex:(NSUInteger)index;
- (NSArray*)getUpTo4RandomAnswers:(RPWord*)word;
- (RPWord*)getRandomQuestion;

@end