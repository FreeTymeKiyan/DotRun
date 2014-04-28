//
//  HelloWorldLayer.h
//  DotRun
//
//  Created by Kiyan Liu on 4/19/14.
//  Copyright FreeTymeKiyan 2014. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Level.h"
#import "GLES-Render.h"
#import "MyContactListener.h"
#import "GameoverLayer.h"
#import <AudioToolbox/AudioToolbox.h>

#define PTM_RATIO 32.0
#define FROM_RIGHT 0
#define FROM_LEFT 1
#define IS_UPPER 0
#define IS_LOWER 1
#define THRESHOLD 26
#define PATTERN_NO 6

@interface HelloWorldLayer : CCLayerColor {
    b2World *_world;
    b2Body *_body;
    CCSprite *_ball;
    CGPoint posChange;
    Level *level;
//    GLESDebugDraw *_debugDraw;
    MyContactListener *_contactListener;
    CCLabelTTF *scoreLabel;
}

+(id) scene;

@end
