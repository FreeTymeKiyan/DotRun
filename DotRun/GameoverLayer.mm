//
//  GameoverLayer.mm
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
    [scoreLable setString:[NSString stringWithFormat:@"%i", s]];
    CGSize size = [CCDirector sharedDirector].winSize;
    [scoreLable setPosition:ccp(size.width / 2, scoreLable.position.y)];
}

-(id) init {
    if (self = [super initWithColor:ccc4(255,255,255,255)]) {
//        [self setTouchEnabled:YES];
        
        CGSize s = [CCDirector sharedDirector].winSize;
        
        int bestScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"BestScore"];
        NSString* bestStr;
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNewBest"]) {
            bestStr = [NSString stringWithFormat:@"New Best: %i", bestScore];
        } else {
            bestStr = [NSString stringWithFormat:@"Best: %i", bestScore];
        }
        CCLabelTTF* bestLabel = [CCLabelTTF labelWithString:bestStr fontName:@"Marker Felt" fontSize:28];
        [bestLabel setPosition:ccp(s.width / 2, s.height / 2)];
        [bestLabel setColor:ccBLACK];
        [self addChild: bestLabel];
        
        scoreLable = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:64];
        [scoreLable setPosition:ccp(s.width / 2, s.height / 2 + bestLabel.contentSize.height + scoreLable.contentSize.height / 2)];
        [scoreLable setColor:ccBLACK];
        [self addChild: scoreLable];
        
        // Default font size will be 28 points.
		[CCMenuItemFont setFontSize:28];
		// to avoid a retain-cycle with the menuitem and blocks
//		__block id copy_self = self;
        CCMenuItem* shareItem = [CCMenuItemFont itemWithString:@"Share" block:^(id sender) {
            NSLog(@"Share Clicked");
//            system share
            NSArray *activityItems;
            NSString *sharingText = [NSString stringWithFormat:@"I just got %i in DotRun! See who can beat me! Download: https://itunes.apple.com/us/app/dotrun/id872519440?ls=1&mt=8", bestScore];
            
            CCScene *scene = [[CCDirector sharedDirector] runningScene];
            CCNode *n = [scene.children objectAtIndex:0];
            UIImage *sharingImage = [self screenshotWithStartNode:n];
            
            if (sharingImage != nil) {
                activityItems = @[sharingText, sharingImage];
            } else {
                activityItems = @[sharingText];
            }
            UIActivityViewController *activityController =
            [[UIActivityViewController alloc] initWithActivityItems:activityItems  applicationActivities:nil];
            [[CCDirector sharedDirector] presentViewController:activityController animated:YES completion:nil];
        }];
        [shareItem setColor:ccBLACK];
        CCMenuItem* replayItem = [CCMenuItemFont itemWithString:@"Replay" block:^(id sender) {
//            NSLog(@"Replay Clicked");
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene]]];
        }];
        [replayItem setColor:ccBLACK];
        CCMenuItem* exitItem = [CCMenuItemFont itemWithString:@"Exit" block:^(id sender) {
//            NSLog(@"exit Clicked");
//            return to main scene
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MainLayer scene]]];
        }];
        [exitItem setColor:ccBLACK];
        CCMenu *menu = [CCMenu menuWithItems:shareItem, replayItem, exitItem, nil];
		[menu alignItemsHorizontallyWithPadding:40];
		[menu setPosition:ccp(s.width/2, s.height/2 - bestLabel.contentSize.height - exitItem.contentSize.height / 2)];
		
		// Add the menu to the layer
		[self addChild:menu];

    }
    return self;
}

-(UIImage*) screenshotWithStartNode:(CCNode*)startNode
{
    [CCDirector sharedDirector].nextDeltaTimeZero = YES;
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    CCRenderTexture* rtx =
    [CCRenderTexture renderTextureWithWidth:winSize.width
                                     height:winSize.height];
    [rtx begin];
    [startNode visit];
    [rtx end];
    
    return [rtx getUIImage];
}

- (void)dealloc {
//    [scoreLable release];
//    scoreLable = nil;
    [super dealloc];
}

@end
