//
//  GameMap.h
//  FinalApp
//
//  Created by Lion User on 03/05/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@interface GameMap : NSObject

@property NSDictionary *_levels;
@property NSDictionary *_allLocations;
@property NSMutableDictionary *_importantLocations;
@property NSMutableDictionary *_playableLocations;
@property NSMutableDictionary *_finishedLocations;
@property int _score;
@property NSArray *_currentLevel;
@property int *_entity;

+(GameMap *) startANewGame: (int) entity;
+ (GameMap *)initWithCoder:(NSCoder *)decoder;
-(NSArray *) makeMapObject;
-(void) setMapObject: (NSArray *) inputs;
-(int)encodeWithCoder:(NSCoder *)encoder;
-(void)increaseScore: (int) points;
-(void)finishChallengeAtLocation: (NSString *)location;
-(void)initWithAnotherMap: (GameMap *) game;



@end


