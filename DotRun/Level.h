//
//  Level.h
//  DotRun
//
//  Created by Kiyan Liu on 4/21/14.
//  Copyright (c) 2014 FreeTymeKiyan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject {
    int duration;
    int interval;
}

-(id) init;
-(int) getInterval;
-(int) getDuration;
-(void) upgrade;

@end
