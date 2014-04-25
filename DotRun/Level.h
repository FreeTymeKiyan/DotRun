//
//  Level.h
//  DotRun
//
//  Created by Kiyan Liu on 4/21/14.
//  Copyright (c) 2014 FreeTymeKiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject {
    float duration;
    float interval;
    int score;
    float totalTime;
}

-(id) init;
-(float) getInterval;
-(float) getDuration;
-(int) getScore;
-(void) setScore: (int) a;
-(int) getTotalTime;
-(void) setTotalTime: (float) a;
-(void) upgrade;

@end
