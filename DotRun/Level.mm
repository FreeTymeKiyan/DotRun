//
//  Level.m
//  DotRun
//
//  Created by Kiyan Liu on 4/21/14.
//  Copyright (c) 2014 FreeTymeKiyan. All rights reserved.
//

#import "Level.h"

@implementation Level

-(id) init {
    if (self = [super init]) {
        duration = 8;
        interval = 2;
        score = 0;
    }
    return self;
}

-(int) getInterval {
    return interval;
}

-(int) getDuration {
    return duration;
}

-(int) getScore {
    return score;
}

-(void) setScore: (int) a {
    score = a;
}

-(int) getTotalTime {
    return totalTime;
}

-(void) setTotalTime:(float)a {
    totalTime += a;
}

-(void) upgrade {
    duration--;
    interval--;
}
@end
