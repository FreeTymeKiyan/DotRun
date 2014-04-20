//
//  HelloWorldLayer.h
//  DotRun
//
//  Created by Kiyan Liu on 4/19/14.
//  Copyright FreeTymeKiyan 2014. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"

@interface HelloWorldLayer : CCLayer {
    b2World *_world;
    b2Body *_body;
    CCSprite *_ball;
}

+(id) scene;

@end
