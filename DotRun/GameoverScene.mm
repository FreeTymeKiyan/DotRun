//
//  MyCocos2DClass.mm
//  DotRun
//
//  Created by Kiyan Liu on 4/22/14.
//  Copyright 2014 FreeTymeKiyan. All rights reserved.
//

#import "GameoverScene.h"


@implementation GameoverScene

+(CCScene *)scene {
    CCScene * scene = [CCScene node];
//    GameoverScene *layer = [GameoverScene node];
//    [layer setScore: param];
//    NSLog(@"score1: %i", param);
//    [scene addChild: layer];
    return scene;
}

-(void) setScore: (int) s {
    [scoreLable setString:[NSString stringWithFormat:@"Score: %i", s]];
}

-(id) init {
    if (self = [super init]) {
        CGSize s = [CCDirector sharedDirector].winSize;
        
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:64];
        label.position =  ccp(s.width / 2, s.height / 2 + label.contentSize.height / 2);
        [self addChild: label];
        
        scoreLable = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Marker Felt" fontSize:64];
        scoreLable.position =  ccp(s.width / 2, s.height / 2 - label.contentSize.height / 2);
        [self addChild: scoreLable];
    }
    return self;
}

- (void)dealloc {
    [scoreLable release];
    scoreLable = nil;
    [super dealloc];
}

@end
