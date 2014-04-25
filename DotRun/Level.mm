//
//  Level.m
//  DotRun
//
//  Created by Kiyan Liu on 4/21/14.
//  Copyright (c) 2014 FreeTymeKiyan. All rights reserved.
//

#import "Level.h"
#define RATIO 1 / 3;

@implementation Level

-(id) init {
    if (self = [super init]) {
        duration = 6;
        interval = 2;
        score = 0;
    }
    return self;
}

-(float) getInterval {
    return interval;
}

-(float) getDuration {
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
    float step = 0.2;
    if (duration <= 4 && duration > 3) {
        step = 0.03;
    }
    interval = duration * RATIO;
    
    if (duration < 3 && duration > 2) { // minimum
        step = 0.01;   
    }
    duration -= step;
    if (duration < 2) {
        duration = 2;
    }
    if (interval < 1) {
        interval = 1;
    }
//    NSLog(@"duration: %f, interval: %f", duration, interval);
}
@end
