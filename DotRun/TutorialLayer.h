//
//  TutorialLayer.h
//  DotRun
//
//  Created by Kiyan Liu on 4/27/14.
//  Copyright 2014 FreeTymeKiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "MyContactListener.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TutorialLayer : CCLayerColor {
    CCSprite* ball;
    b2World *_world;
    b2Body *_body;
    CGPoint posChange;
    MyContactListener *_contactListener;
    int STEP;
    CCLabelTTF* instructionLabel;
    BOOL hasCollision;
    CCSprite* target;
}

+(CCScene *) scene;

@end
