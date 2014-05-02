//
//  MainLayer.mm
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
        // judge whether it's the first launch
        if (![[NSUserDefaults standardUserDefaults] boolForKey:@"everLaunched"]) {
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"everLaunched"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        }
        
        CGSize s = [[CCDirector sharedDirector]winSize];
        // add title
        CCLabelTTF* titleLabel = [CCLabelTTF labelWithString:@"DOTRUN" fontName:@"Marker Felt" fontSize:64 ];
        [titleLabel setColor:ccBLACK];
        [titleLabel setPosition:ccp(s.width / 2, s.height * 2 / 3)];
        [self addChild:titleLabel];
        // add menu items
        [CCMenuItemFont setFontSize:28];
        CCMenuItemFont* arcadeItem = [CCMenuItemFont itemWithString:@"New Game" block:^(id sender) {
//            NSLog(@"Arcade clicked");
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[TutorialLayer scene]]];
            } else {
                [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene]]];
            }
        }];
        [arcadeItem setColor:ccBLACK];
        
        CCMenuItemFont* tutorialItem1 = [CCMenuItemFont itemWithString:@"Tutorial: OFF"];
        CCMenuItemFont* tutorialItem2 = [CCMenuItemFont itemWithString:@"Tutorial: ON"];
        [tutorialItem1 setColor:ccBLACK];
        [tutorialItem2 setColor:ccBLACK];
//        CCMenuItemToggle* toggleItem = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects:tutorialItem2, tutorialItem1, nil]];
        CCMenuItemToggle* toggleItem;
        
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]) {
            toggleItem = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects:tutorialItem2, tutorialItem1, nil]];
        } else {
            toggleItem = [CCMenuItemToggle itemWithItems:[NSArray arrayWithObjects:tutorialItem1, tutorialItem2, nil]];
        }
        [toggleItem setBlock:^(id sender) {
//            NSLog(@"toggleitem clicked");
            [[NSUserDefaults standardUserDefaults] setBool:![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] forKey:@"firstLaunch"];
        }];
        
        CCMenuItemFont* leaderboardItem = [CCMenuItemFont itemWithString:@"Leaderboard" block:^(id sender) {
//            NSLog(@"Leaderboard clicked");
            [self showGameCenter];
        }];
        [leaderboardItem setColor:ccBLACK];
        
        CCMenuItemFont* rateItem = [CCMenuItemFont itemWithString:@"Rate Me!" block:^(id sender) {
//            NSLog(@"rateitem clciked");
            NSString *urlStr = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%d", 872519440];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        }];
        [rateItem setColor:ccBLACK];
        
        // add menu
        CCMenu* menu = [CCMenu menuWithItems:arcadeItem, rateItem, toggleItem, leaderboardItem,  nil];
        [menu alignItemsInColumns:[NSNumber numberWithInt:2], [NSNumber numberWithInt:2], nil];
        [menu setPosition:ccp(s.width / 2, s.height / 3)];
        [self addChild:menu];
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
    }
    return self;
}

- (void) showGameCenter {
    GKGameCenterViewController *gameCenterController = [[GKGameCenterViewController alloc] init];
    if (gameCenterController != nil) {
        __block id copy_self = self;
        gameCenterController.gameCenterDelegate = copy_self;
        [[CCDirector sharedDirector] presentViewController:gameCenterController animated:YES completion:nil];
        [gameCenterController release];
    }
}

- (void) gameCenterViewControllerDidFinish:(GKGameCenterViewController *)gameCenterViewController {
    [[CCDirector sharedDirector] dismissViewControllerAnimated:YES completion:nil];
}

-(void) dealloc {
    [super dealloc];
}

@end
