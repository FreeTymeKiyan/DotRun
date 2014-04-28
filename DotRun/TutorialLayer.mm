//
//  TutorialLayer.m
//  DotRun
//
//  Created by Kiyan Liu on 4/27/14.
//  Copyright 2014 FreeTymeKiyan. All rights reserved.
//

#import "TutorialLayer.h"
#import "HelloWorldLayer.h"

@implementation TutorialLayer

+(CCScene *) scene {
    CCScene* scene = [CCScene node];
    TutorialLayer* layer = [TutorialLayer node];
    [scene addChild:layer];
    return scene;
}

-(id) init {
    if(self = [super initWithColor:ccc4(255, 255, 255, 255)]) {
        [self setAccelerometerEnabled:YES];
        CGSize winSize = [[CCDirector sharedDirector] winSize];
        
        ball = [CCSprite spriteWithFile:@"Ball_red.jpg" rect:CGRectMake(0, 0, 26, 26)];
        [ball setPosition:ccp(winSize.width / 2, winSize.height / 2)];
        [ball setTag:0];
        [self addChild:ball];
        
        target = [CCSprite spriteWithFile:@"circle.png" rect:CGRectMake(0, 0, 52, 52)];
        [target setPosition:ccp(-target.contentSize.width / 2, -target.contentSize.height /2)];
        [self addChild:target];
        
        instructionLabel = [CCLabelTTF labelWithString:@"Move Up and Down with Gravity Control" fontName:@"Marker Felt" fontSize:32];
        [instructionLabel setColor:ccBLACK];
        [instructionLabel setPosition:ccp(winSize.width / 2, winSize.height / 2)];
        [self addChild:instructionLabel];
        
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        _world = new b2World(gravity);
        _world->SetAllowSleeping(true);
        
        // set contact listener
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(winSize.width / 2 / PTM_RATIO, winSize.height / 2 / PTM_RATIO);
        ballBodyDef.userData = ball;
        _body = _world->CreateBody(&ballBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 10.0 / PTM_RATIO;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.0f;
        ballShapeDef.restitution = 0.0f;
        _body->CreateFixture(&ballShapeDef);
        
        [self schedule:@selector(update:)];
        [self schedule:@selector(next:) interval:3.0];
    }
    return self;
}

-(void) next:(ccTime) dt {
    if (hasCollision) {
        hasCollision = NO;
        STEP--;
    }
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    if (STEP == 0) {
        // move down in the circle
        [instructionLabel setString:@"Move Down into the Circle"];
        [instructionLabel setPosition:ccp(winSize.width / 2, winSize.height - instructionLabel.contentSize.height)];
        [target setPosition:ccp(winSize.width / 2, winSize.height / 4)];
        // judge in the circle and generate bars
        if (abs(ball.position.x - target.position.x) <= ball.contentSize.width && abs(ball.position.y - target.position.y) <= ball.contentSize.width) {
            [instructionLabel setString:@"Keep Balance and Avoid Collision"];
            int height = target.position.y - target.contentSize.height / 2;
            [self generatePair:IS_UPPER direction:FROM_LEFT height:height];
            [self generatePair:IS_LOWER direction:FROM_RIGHT height:height];
            STEP++;
        }
    } else if(STEP == 1) {
        [instructionLabel setString:@"Move Up into the Circle"];
        [instructionLabel setPosition:ccp(winSize.width / 2, instructionLabel.contentSize.height)];
        [target setPosition:ccp(winSize.width / 2, winSize.height * 3 / 4)];
        // judge in the circle and generate bars
        if (abs(ball.position.x - target.position.x) <= ball.contentSize.width && abs(ball.position.y - target.position.y) <= ball.contentSize.width) {
            [instructionLabel setString:@"Keep Balance and Avoid Collision"];
            int height = target.position.y - target.contentSize.height / 2;
            [self generatePair:IS_LOWER direction:FROM_LEFT height:height];
            [self generatePair:IS_UPPER direction:FROM_RIGHT height:height];
            STEP++;
        }

    } else if (STEP == 2) {
        // remove circle and label
        [target setPosition:ccp(-target.contentSize.width / 2, -target.contentSize.height / 2)];
        [instructionLabel setPosition:ccp(-instructionLabel.contentSize.width / 2, -instructionLabel.contentSize.height / 2)];
        // stop and show choices
        CCLabelTTF* tutorialLabel = [CCLabelTTF labelWithString:@"Tutorial" fontName:@"Marker Felt" fontSize:64];
        [tutorialLabel setColor:ccBLACK];
        [tutorialLabel setPosition:ccp(winSize.width / 2, winSize.height * 2 / 3)];
        [self addChild:tutorialLabel];
        
        [CCMenuItemFont setFontSize:28];
        CCMenuItem* startItem = [CCMenuItemFont itemWithString:@"Start" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[HelloWorldLayer scene]]];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        }];
        [startItem setColor:ccBLACK];
        CCMenuItem* againItem = [CCMenuItemFont itemWithString:@"Again" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[TutorialLayer scene]];
        }];
        [againItem setColor:ccBLACK];
        CCMenu* menu = [CCMenu menuWithItems:startItem, againItem, nil];
        [menu alignItemsHorizontallyWithPadding:40];
        [menu setPosition:ccp(winSize.width/2, winSize.height / 3)];
        [self addChild:menu];
        
        [self unschedule:@selector(next:)];
    }
}

-(void) generatePair : (int) position direction : (int) direction height: (int) randomHeight {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    CCSprite *bar;
    CGPoint dest;
    if (position == IS_LOWER) {
        bar = [CCSprite spriteWithFile:@"Bar.jpg" rect:CGRectMake(0, 0, 10, randomHeight)];
        if (direction == FROM_RIGHT) {
            bar.position = ccp(winSize.width + (bar.contentSize.width / 2),  bar.contentSize.height / 2);
            dest = ccp(-bar.contentSize.width/2, bar.contentSize.height / 2);
        } else {
            bar.position = ccp(-bar.contentSize.width / 2, bar.contentSize.height / 2);
            dest = ccp(winSize.width + (bar.contentSize.width / 2), bar.contentSize.height / 2);
        }
    } else { // IS_UPPER
        bar = [CCSprite spriteWithFile:@"Bar.jpg" rect:CGRectMake(0, 0, 10, winSize.height - randomHeight - THRESHOLD - ball.contentSize.height)];
        if (direction == FROM_RIGHT) {
            bar.position = ccp(winSize.width + (bar.contentSize.width / 2), randomHeight + THRESHOLD + ball.contentSize.height + (bar.contentSize.height / 2));
            NSLog(@"%f, height: %f", winSize.width + (bar.contentSize.width / 2), randomHeight + THRESHOLD + ball.contentSize.height + (bar.contentSize.height / 2));
            dest = ccp(-bar.contentSize.width/2, randomHeight + THRESHOLD + ball.contentSize.height + (bar.contentSize.height / 2));
        } else {
            bar.position = ccp(-bar.contentSize.width / 2, randomHeight + THRESHOLD + ball.contentSize.height + (bar.contentSize.height / 2));
            dest = ccp(winSize.width + (bar.contentSize.width / 2), randomHeight + THRESHOLD + ball.contentSize.height + (bar.contentSize.height / 2));
        }
    }
    bar.tag = 1;
    [self addChild:bar];
    
    [self createBody:bar];
    
    id actionMove = [CCMoveTo actionWithDuration:2 position:dest];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [bar runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}


-(void) createBody: (CCSprite*) bar {
    //创建一个刚体的定义，并将其设置为动态刚体
    b2BodyDef bodyDef;
    bodyDef.type = b2_dynamicBody;
    bodyDef.position.Set(bar.position.x / PTM_RATIO, bar.position.y / PTM_RATIO);
    bodyDef.userData = bar;
    b2Body* body = _world->CreateBody(&bodyDef);
    
    // 定义一个盒子形状，并将其复制给body fixture
    b2PolygonShape  dynamicBox;
    dynamicBox.SetAsBox(bar.contentSize.width / PTM_RATIO * 0.5f, bar.contentSize.height / PTM_RATIO * 0.5f);
    
    b2FixtureDef fixtureDef;
    fixtureDef.shape = &dynamicBox;
    fixtureDef.density = 1.0f;
    fixtureDef.friction = 0.0f;
    fixtureDef.restitution = 0.0f;
    fixtureDef.isSensor = YES;
    body->CreateFixture(&fixtureDef);
    
}

-(void) update:(ccTime) delta {
    CGPoint pos = ball.position;
    pos.y -= posChange.x;
    if (pos.y > 320 - ball.contentSize.height / 2) {
        pos.y = 320 - ball.contentSize.height / 2;
        posChange.x = 0;
        posChange.y = 0;
    }
    if (pos.y < ball.contentSize.height / 2) {
        pos.y = ball.contentSize.height / 2;
        posChange.x = 0;
        posChange.y = 0;
    }
    ball.position = pos;
    
    _world->Step(delta, 10, 10);
    for (b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite* sprite = (CCSprite *)b->GetUserData();
            b2Vec2 b2Position = b2Vec2(sprite.position.x / PTM_RATIO, sprite.position.y / PTM_RATIO);
            float32 b2Angle = -1 * CC_DEGREES_TO_RADIANS(sprite.rotation);
            b->SetTransform(b2Position, b2Angle);
        }
    }
    
    std::vector<MyContact>::iterator position;
    for (position = _contactListener->_contacts.begin(); position != _contactListener->_contacts.end(); ++position) {
        MyContact contact = *position;
        b2Body *bodyA = contact.fixtureA->GetBody();
        b2Body *bodyB = contact.fixtureB->GetBody();
        if (bodyA->GetUserData() != NULL && bodyB->GetUserData() != NULL) {
            CCSprite* a = (CCSprite *)bodyA->GetUserData();
            CCSprite* b = (CCSprite *)bodyB->GetUserData();
            if(a.tag != b.tag) {
                [self vibrate];
                [instructionLabel setString:@"Try again"];
                hasCollision = YES;
            }
        }
    }
}

-(void) accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
    posChange.x = posChange.x *0.4f+ acceleration.x *7.0f;
    //    NSLog(@"1---x:%f, y:%f", acceleration.x, acceleration.y);
    if (posChange.x>100) {
        posChange.x=100;
    }
    if (posChange.x<-100) {
        posChange.x=-100;
    }
}

-(void) spriteMoveFinished:(id)sender {
    CCSprite *sprite = (CCSprite *)sender;
    
    b2Body *spriteBody = NULL;
    for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {
        if (b->GetUserData() != NULL) {
            CCSprite *curSprite = (CCSprite *)b->GetUserData();
            if (sprite == curSprite) {
                spriteBody = b;
                break;
            }
        }
    }
    if (spriteBody != NULL) {
        _world->DestroyBody(spriteBody);
    }
    
    [self removeChild:sprite cleanup:YES];
}

-(void) vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void) dealloc {
    delete _world;
    _body = nil;
    _world = nil;
    delete _contactListener;
    [super dealloc];
}

@end
