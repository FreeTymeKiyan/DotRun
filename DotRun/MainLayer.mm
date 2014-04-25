//
//  MyCocos2DClass.mm
//  DotRun
//
//  Created by Kiyan Liu on 4/24/14.
//  Copyright 2014 FreeTymeKiyan. All rights reserved.
//

#import "MainLayer.h"


@implementation MainLayer

+(CCScene*) scene {
    CCScene* scene = [CCScene node];
    MainLayer* layer = [MainLayer node];
    [scene addChild:layer];
    return scene;
}

-(id) init {
    if (self = [super initWithColor:ccc4(255, 255, 255, 255)]) {
        CGSize s = [[CCDirector sharedDirector]winSize];
        // add title
        CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:@"Dot Run" fontName:@"Marker Felt" fontSize:64 ];
        [titleLabel setColor:ccBLACK];
        [titleLabel setPosition:ccp(s.width / 2, s.height / 2 + titleLabel.contentSize.height / 2)];
        [self addChild:titleLabel];
        // add menu items
        [CCMenuItemFont setFontSize:28];
        CCMenuItemFont* arcadeItem = [CCMenuItemFont itemWithString:@"Arcade" block:^(id sender) {
//            NSLog(@"Arcade clicked");
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene]]];
        }];
        [arcadeItem setColor:ccBLACK];
        CCMenuItemFont* settingsItem = [CCMenuItemFont itemWithString:@"Settings" block:^(id sender) {
            NSLog(@"Settings clicked");
        }];
        [settingsItem setColor:ccBLACK];
        CCMenuItemFont* leaderboardItem = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
            NSLog(@"Leaderboard clicked");
        }];
        [leaderboardItem setColor:ccBLACK];
        // add menu
        CCMenu* menu = [CCMenu menuWithItems:arcadeItem, settingsItem, leaderboardItem, nil];
        [menu alignItemsHorizontallyWithPadding:40];
        [menu setPosition:ccp(s.width / 2, s.height / 2 - titleLabel.contentSize.height / 2)];
        [self addChild:menu];
    }
    return self;
}

-(void) onEnter {
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

@end
