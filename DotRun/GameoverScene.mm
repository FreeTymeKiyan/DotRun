//
//  MyCocos2DClass.mm
//  DotRun
//
//  Created by Kiyan Liu on 4/22/14.
//  Copyright 2014 FreeTymeKiyan. All rights reserved.
//

#import "GameoverScene.h"


@implementation GameoverScene

+(CCScene *)sceneWithParam: (int) param {
    CCScene * scene = [CCScene node];
    GameoverScene *layer = [GameoverScene node];
    [layer setScore: param];
    NSLog(@"score1: %i", param);
    [scene addChild: layer];
    return scene;
}

-(void) setScore: (int) s {
    score = s;
    NSLog(@"score2: %i", score);
}

-(id) init {
    if (self = [super init]) {
        CGSize s = [CCDirector sharedDirector].winSize;
        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:64];
        label.position =  ccp(s.width / 2, s.height / 2 + label.contentSize.height / 2);
        [self addChild: label];
        NSLog(@"score3: %i", score);
        CCLabelTTF* scorelabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", score] fontName:@"Marker Felt" fontSize:64];
        scorelabel.position =  ccp(s.width / 2, s.height / 2 - label.contentSize.height / 2);
        [self addChild: scorelabel];
    }
    return self;
}

//-(id) initWithParam: (int) score {
//    if (self = [super init]) {
//        CGSize s = [CCDirector sharedDirector].winSize;
//        CCLabelTTF* label = [CCLabelTTF labelWithString:@"Game Over" fontName:@"Marker Felt" fontSize:64];
//        label.position =  ccp(s.width / 2, s.height / 2);
//        [self addChild: label];
//        
//        CCLabelTTF* scorelabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %i", score] fontName:@"Marker Felt" fontSize:64];
//        scorelabel.position =  ccp(s.width / 2, s.height / 2 - label.contentSize.height);
//        [self addChild: scorelabel];
//        
//    }
//    return self;
//}

@end
