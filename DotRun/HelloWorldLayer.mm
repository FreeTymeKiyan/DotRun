//
//  HelloWorldLayer.mm
//  DotRun
//
//  Created by Kiyan Liu on 4/19/14.
//  Copyright FreeTymeKiyan 2014. All rights reserved.
//

#import "HelloWorldLayer.h"

@implementation HelloWorldLayer

+(id) scene {
    CCScene *scene = [CCScene node];
    HelloWorldLayer *layer = [HelloWorldLayer node];
    [scene addChild:layer];
    return scene;
}

-(id) init {
    if((self = [super initWithColor:ccc4(255,255,255,255)])) {
        CGSize winSize = [CCDirector sharedDirector].winSize;
        [self setAccelerometerEnabled:YES];
        
        _ball = [CCSprite spriteWithFile:@"Ball_red.jpg" rect:CGRectMake(0, 0, 26, 26)];
        [_ball setPosition:ccp(winSize.width / 2, winSize.height / 2)];
        [_ball setTag:0];
        [self addChild:_ball];
//        NSLog(@"%f, %f", winSize.width / 2, winSize.height / 2);
        
        b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
        _world = new b2World(gravity);
        _world->SetAllowSleeping(true);
        
        // set contact listener
        _contactListener = new MyContactListener();
        _world->SetContactListener(_contactListener);
        
//        _debugDraw = new GLESDebugDraw(PTM_RATIO);
//        _world->SetDebugDraw(_debugDraw);
//        uint32 flags = 0;
//        flags += b2Draw::e_shapeBit;
//        _debugDraw->SetFlags(flags);
        
        // Create ball body and shape
        b2BodyDef ballBodyDef;
        ballBodyDef.type = b2_dynamicBody;
        ballBodyDef.position.Set(winSize.width / 2 / PTM_RATIO, winSize.height / 2 / PTM_RATIO);
        ballBodyDef.userData = _ball;
        _body = _world->CreateBody(&ballBodyDef);
        
        b2CircleShape circle;
        circle.m_radius = 10.0 / PTM_RATIO;
        
        b2FixtureDef ballShapeDef;
        ballShapeDef.shape = &circle;
        ballShapeDef.density = 1.0f;
        ballShapeDef.friction = 0.0f;
        ballShapeDef.restitution = 0.0f;
        _body->CreateFixture(&ballShapeDef);
        
        level = [[Level alloc] init];
        
        scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"Marker Felt" fontSize:32];
        [scoreLabel setPosition:ccp(winSize.width - scoreLabel.contentSize.width / 2, scoreLabel.contentSize.height / 2)];
        [scoreLabel setColor:ccBLACK];
        [self addChild: scoreLabel];
        
        [self schedule:@selector(update:)];
        [self schedule:@selector(gameLogic:) interval:[level getInterval]];
    }
    return self;
}

-(void) gameLogic:(ccTime)dt {
    int pattern = arc4random() % PATTERN_NO;
    [self generatePattern: pattern];
}

-(void) generatePattern: (int) pattern {
    int randomHeight = abs(arc4random());
    switch (pattern) {
        case 0:
            [self generatePair:IS_LOWER direction:FROM_LEFT height:randomHeight];
            [self generatePair:IS_UPPER direction:FROM_RIGHT height:randomHeight];
            break;
        case 1:
            [self generatePair:IS_UPPER direction:FROM_LEFT height:randomHeight];
            [self generatePair:IS_LOWER direction:FROM_RIGHT height:randomHeight];
            break;
        case 2:
            [self generateBar:IS_LOWER direction:FROM_LEFT height:randomHeight];
            break;
        case 3:
            [self generateBar:IS_UPPER direction:FROM_RIGHT height:randomHeight];
            break;
        case 4:
            [self generateBar:IS_UPPER direction:FROM_LEFT height:randomHeight];
            break;
        case 5:
            [self generateBar:IS_LOWER direction:FROM_RIGHT height:randomHeight];
            break;
        default:
            break;
    }
    [self upgrade];
}

-(void) spriteMoveFinished:(id)sender {
    CCSprite* sprite = (CCSprite *)sender;
    
    b2Body* spriteBody = NULL;
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

-(void) generateBar: (int) position direction: (int)direction height: (int) randomHeight {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = winSize.height / 2;
    int maxY = winSize.height * 2 / 3;
    int range = maxY - minY;
    randomHeight = randomHeight % range + minY;
    CCSprite *bar = [CCSprite spriteWithFile:@"Bar.jpg" rect:CGRectMake(0, 0, 10, randomHeight)];
    CGPoint dest;
    if (position == IS_LOWER) {
        if (direction == FROM_LEFT) {
            [bar setPosition:ccp(-bar.contentSize.width / 2, bar.contentSize.height / 2)];
            dest = ccp(winSize.width + bar.contentSize.width / 2, bar.contentSize.height / 2);
        } else {
            [bar setPosition:ccp(winSize.width + bar.contentSize.width / 2, bar.contentSize.height / 2)];
            dest = ccp(-bar.contentSize.width / 2, bar.contentSize.height / 2);
        }
    } else {
        if (direction == FROM_LEFT) {
            [bar setPosition:ccp(-bar.contentSize.width / 2, winSize.height - bar.contentSize.height / 2)];
            dest = ccp(winSize.width + bar.contentSize.width / 2, winSize.height - bar.contentSize.height / 2);
        } else {
            [bar setPosition:ccp(winSize.width + bar.contentSize.width / 2, winSize.height - bar.contentSize.height / 2)];
            dest = ccp(-bar.contentSize.width / 2, winSize.height - bar.contentSize.height / 2);
        }
    }
    bar.tag = 1;
    [self addChild:bar];

    [self createBody:bar];
    
    id actionMove = [CCMoveTo actionWithDuration:[level getDuration] position:dest];
//    NSLog(@"duration: %f", [level getDuration]);
    id actionMoveDone = [CCCallFuncN actionWithTarget:self
                                             selector:@selector(spriteMoveFinished:)];
    [bar runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void) generatePair : (int) position direction : (int) direction height: (int) randomHeight {
    CGSize winSize = [[CCDirector sharedDirector] winSize];
    int minY = THRESHOLD + _ball.contentSize.height;
    int maxY = winSize.height - THRESHOLD - _ball.contentSize.height;
    int range = maxY - minY;
    randomHeight = randomHeight % range + minY;
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
        bar = [CCSprite spriteWithFile:@"Bar.jpg" rect:CGRectMake(0, 0, 10, maxY - randomHeight)];
        if (direction == FROM_RIGHT) {
            bar.position = ccp(winSize.width + (bar.contentSize.width / 2), randomHeight + THRESHOLD + _ball.contentSize.height + (bar.contentSize.height / 2));
            NSLog(@"%f, height: %f", winSize.width + (bar.contentSize.width / 2), randomHeight + THRESHOLD + _ball.contentSize.height + (bar.contentSize.height / 2));
            dest = ccp(-bar.contentSize.width/2, randomHeight + THRESHOLD + _ball.contentSize.height + (bar.contentSize.height / 2));
        } else {
            bar.position = ccp(-bar.contentSize.width / 2, randomHeight + THRESHOLD + _ball.contentSize.height + (bar.contentSize.height / 2));
            dest = ccp(winSize.width + (bar.contentSize.width / 2), randomHeight + THRESHOLD + _ball.contentSize.height + (bar.contentSize.height / 2));
        }
    }
    bar.tag = 1;
    [self addChild:bar];
    
    [self createBody:bar];
    
    id actionMove = [CCMoveTo actionWithDuration:[level getDuration] position:dest];
//    NSLog(@"duration: %f", [level getDuration]);
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
    CGPoint pos = _ball.position;
    pos.y -= posChange.x;
    if (pos.y > 320 - _ball.contentSize.height / 2) {
        pos.y = 320 - _ball.contentSize.height / 2;
        posChange.x = 0;
        posChange.y = 0;
    }
    if (pos.y < _ball.contentSize.height / 2) {
        pos.y = _ball.contentSize.height / 2;
        posChange.x = 0;
        posChange.y = 0;
    }
    _ball.position = pos;
    
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
                NSLog(@"%@", @"Game Over!!!");
                [self gameOver];
            }
        }
    }
    
    [level setTotalTime:delta];
    int currentTime = (int)[level getTotalTime];
    if ([level getScore] < currentTime) {
        [level setScore: currentTime];
        [scoreLabel setString:[NSString stringWithFormat:@"%i", [level getScore]]];
        scoreLabel.position = ccp([[CCDirector sharedDirector] winSize].width - scoreLabel.contentSize.width / 2, scoreLabel.contentSize.height / 2);
    }
}

-(void) gameOver {
    [self vibrate];
    // stop moving
    [self unschedule:@selector(update:)];
    [self unschedule:@selector(gameLogic:)];
    
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"BestScore"] < [level getScore]) {
        [[NSUserDefaults standardUserDefaults] setInteger:[level getScore] forKey:@"BestScore"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isNewBest"];
    } else
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isNewBest"];
    // move to next scene
    CCScene* s = [GameoverLayer scene];
    GameoverLayer* layer = [GameoverLayer node];
    [layer setScore:[level getScore]];
    [s addChild:layer];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:s]];
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

-(void) draw {
    [super draw];
    ccGLEnableVertexAttribs( kCCVertexAttribFlag_Position );
    kmGLPushMatrix();
    //    kmGLScalef(CC_CONTENT_SCALE_FACTOR(), CC_CONTENT_SCALE_FACTOR(), 1);
    _world->DrawDebugData();
    kmGLPopMatrix();
}

-(int) bestScore {
//    int x = [[NSUserDefaults standardUserDefaults] integerForKey:@"BestScore"];
//    NSLog(@"best score: %i", x);
    return [[NSUserDefaults standardUserDefaults] integerForKey:@"BestScore"];
}

-(void) vibrate {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

-(void) upgrade {
    [level upgrade];
    [self unschedule:@selector(gameLogic:)];
    [self schedule:@selector(gameLogic:) interval:[level getInterval]];
}

-(void) dealloc {
    delete _world;
    _body = nil;
    _world = nil;
    [level release];
    delete _contactListener;
    [super dealloc];
}

@end