//
//  RPWord.m
//  Repetitio
//
//  Created by Stephane Bruckert on 3/17/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//

#import "RPWord.h"

@implementation RPWord

@synthesize smEF;
@synthesize smReps;
@synthesize smInterval;
@synthesize smNextDate;
@synthesize smPrevDate;

- (NSString *)description {
    return [NSString stringWithFormat: @"Word: name=%@ trans=%@", [self valueForKey:@"word"], [self valueForKey:@"trans"]];
}

@end
