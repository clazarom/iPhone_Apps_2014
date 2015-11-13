//
//  IntelligentBot.h
//  MP3
//
//  Created by CatMac on 5/11/14.
//
//

#import <Foundation/Foundation.h>
#import "BoardGame.h"

@interface IntelligentBot : NSObject

@property BoardGame *_game;
@property int _level;

-(int) makeBestMovement :(BoardGame *)game;
+(IntelligentBot *)newBot:(int)level;
@end
