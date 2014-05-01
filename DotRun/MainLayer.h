//
//  MyCocos2DClass.h
//  DotRun
//
//  Created by Kiyan Liu on 4/24/14.
//  Copyright 2014 FreeTymeKiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "TutorialLayer.h"
#import <GameKit/GameKit.h>

@interface MainLayer : CCLayerColor <GKGameCenterControllerDelegate> {
    
}

+(CCScene *) scene;

@end
