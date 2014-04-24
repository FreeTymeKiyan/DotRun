//
//  MyCocos2DClass.mm
//  DotRun
//
//  Created by Kiyan Liu on 4/22/14.
//  Copyright 2014 FreeTymeKiyan. All rights reserved.
//

#import "GameoverLayer.h"


@implementation GameoverLayer

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
//        [self setTouchEnabled:YES];
        
        CGSize s = [CCDirector sharedDirector].winSize;
        
        scoreLable = [CCLabelTTF labelWithString:@"Score: 0" fontName:@"Marker Felt" fontSize:64];
        scoreLable.position =  ccp(s.width / 2, s.height / 2 + scoreLable.contentSize.height / 2);
        [self addChild: scoreLable];
        
        // Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		// to avoid a retain-cycle with the menuitem and blocks
//		__block id copy_self = self;
        CCMenuItem* shareItem = [CCMenuItemFont itemWithString:@"Share" block:^(id sender) {
            NSLog(@"Share Clicked");
//            system share
        }];
        CCMenuItem* replayItem = [CCMenuItemFont itemWithString:@"Replay" block:^(id sender) {
//            NSLog(@"Replay Clicked");
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene]]];
        }];
        CCMenuItem* exitItem = [CCMenuItemFont itemWithString:@"Exit" block:^(id sender) {
//            NSLog(@"exit Clicked");
//            return to main scene
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainLayer scene]]];
        }];
        CCMenu *menu = [CCMenu menuWithItems:shareItem, replayItem, exitItem, nil];
		[menu alignItemsHorizontallyWithPadding:40];
		[menu setPosition:ccp(s.width/2, s.height/2 - scoreLable.contentSize.height / 2)];
		
		// Add the menu to the layer
		[self addChild:menu];

    }
    return self;
}

- (void)dealloc {
//    [scoreLable release];
//    scoreLable = nil;
    [super dealloc];
}

@end
