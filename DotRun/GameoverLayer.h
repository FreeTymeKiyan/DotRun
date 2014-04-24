//
//  MyCocos2DClass.h
//  DotRun
//
//  Created by Kiyan Liu on 4/22/14.
//  Copyright 2014 FreeTymeKiyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "HelloWorldLayer.h"
#import "MainLayer.h"

@interface GameoverLayer : CCLayer {
    CCLabelTTF* scoreLable;
}

+(CCScene *)scene;
-(void) setScore: (int) s;
@end
