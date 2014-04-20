//
//  HelloWorldLayer.mm
//  DotRun
//
//  Created by Kiyan Liu on 4/19/14.
//  Copyright FreeTymeKiyan 2014. All rights reserved.
//

#import "HelloWorldLayer.h"

#define PTM_RATIO 32.0

@implementation HelloWorldLayer

+(id) scene {
    CCScene *scene = [CCScene node];
    HelloWorldLayer *layer = [HelloWorldLayer node];
    [scene addChild:layer];
    return scene;
}

-(id) init {
    if((self = [super init])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [self setAccelerometerEnabled:true];
        
        _ball = [CCSprite spriteWithFile:@"Ball.jpg" rect:CGRectMake(0, 0, 52, 52)];
        _ball.position = ccp(winSize.width / 2, winSize.height / 2);
        [self addChild:_ball];
//        NSLog(@"%f, %f", winSize.width / 2, winSize.height / 2);
        
        b2Vec2 gravity = b2Vec2(0.0f, -30.0f);
        _world = new b2World(gravity);
        _world->SetAllowSleeping(true);
        
        b2BodyDef groundBodyDef;
        groundBodyDef.position.Set(0,0);
        b2Body *groundBody = _world->CreateBody(&groundBodyDef);
        b2EdgeShape groundBox;
        b2FixtureDef boxShapeDef;
        boxShapeDef.shape =&groundBox;
        groundBox.Set(b2Vec2(0,0), b2Vec2(winSize.width/PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        groundBox.Set(b2Vec2(0,0), b2Vec2(0, winSize.height/PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        groundBox.Set(b2Vec2(0, winSize.height/PTM_RATIO), b2Vec2(winSize.width/PTM_RATIO, winSize.height / PTM_RATIO));
        groundBody->CreateFixture(&boxShapeDef);
        groundBox.Set(b2Vec2(winSize.width/PTM_RATIO, winSize.height/PTM_RATIO), b2Vec2(winSize.width / PTM_RATIO, 0));
        groundBody->CreateFixture(&boxShapeDef);
        
        // Create ball body and shape
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(winSize.width / 2 / PTM_RATIO, winSize.height / 2 / PTM_RATIO);
        ballBodyDef.userData = _ball;
        _body = _world->CreateBody(&ballBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 26.0 / PTM_RATIO;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.0f;
        ballShapeDef.restitution = 0.0f;
        _body->CreateFixture(&ballShapeDef);
        
        [self schedule:@selector(update:)];
    }
    return self;
}

-(void) update:(ccTime) delta {
    float dt = 0.03f;
    _world->Step(dt, 10, 10);
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *ballData = (CCSprite *)b->GetUserData();
            ballData.position = ccp(b->GetPosition().x * PTM_RATIO, b->GetPosition().y * PTM_RATIO);
            ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
        } 
    }
    
    CGPoint pos = _ball.position;
    pos.y -= posChange.x;
    pos.x += posChange.y;
    if (pos.x > 480) {
        pos.x = 480;
        posChange.x = 0;
        posChange.y = 0;
        
    }
    if (pos.x < 0) {
        pos.x = 0;
        posChange.x = 0;
        posChange.y = 0;
    }
    if (pos.y > 320) {
        pos.y = 320;
        posChange.x = 0;
        posChange.y = 0;
    }
    if (pos.y < 0) {
        pos.y = 0;
        posChange.x = 0;
        posChange.y = 0;
    }
    _ball.position = pos;
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    posChange.x = posChange.x *0.4f+ acceleration.x *7.0f;
    posChange.y = posChange.y *0.4f+ acceleration.y *7.0f;
    if (posChange.x>100) {
        posChange.x=100;
    }
    if (posChange.x<-100) {
        posChange.x=-100;
    }
    if (posChange.y>100) {
        posChange.y=100;
    }
    if (posChange.y<-100) {
        posChange.y=-100;
    }
}

-(void) dealloc {
    delete _world;
    _body = NULL;
    _world = NULL;
    [super dealloc];
}

@end