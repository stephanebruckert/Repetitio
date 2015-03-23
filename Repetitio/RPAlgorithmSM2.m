//
//  RPAlgorithmSM2.m
//  Repetitio
//
//  Created by Stephane Bruckert on 3/23/15.
//  Copyright (c) 2015 Tuts+. All rights reserved.
//

#import "RPAlgorithmSM2.h"

@implementation RPAlgorithmSM2
double defaultEFactor = 2.5;
/*
 * Set quality response:
 * 5 - (0 mistake && 3 secs) perfect response
 * 4 - (0 mistake && > 3 secs) correct response after a hesitation
 * 3 - (0 mistake && > 10 secs) correct response recalled with serious difficulty
 * 2 - (1 mistake) incorrect response; where the correct one seemed easy to recall
 * 1 - (1 mistake && > 5 secs) incorrect response; the correct one remembered
 * 0 - (2 mistakes) complete blackout.
 */
+ (void) setQuality:(int) newResponse forResponse:(RPWord*)word {
    int qualityResponse = newResponse;
    //if (qualityResponse < 3)  = defaultEFactor;
}

@end

