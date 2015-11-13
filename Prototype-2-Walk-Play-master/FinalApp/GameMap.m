//
//  GameMap.m
//  FinalApp
//
//  Created by Lion User on 03/05/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "GameMap.h"

@implementation GameMap{
    //NSArray *listOfLevels;
}

@synthesize _allLocations;
@synthesize _importantLocations;
@synthesize _playableLocations;
@synthesize _finishedLocations;
@synthesize _score;
@synthesize _currentLevel;
@synthesize _levels;
@synthesize _entity;


//Start the game
+(GameMap *) startANewGame: (int) entity{
    GameMap *retGame = [[GameMap alloc] init];
    
    //Populate levels of game
    retGame._levels = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]       pathForResource:@"Levels" ofType:@"plist"]];
    NSArray *listOfLevels = [retGame._levels allKeys];
    [[listOfLevels mutableCopy] sortUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    //Get all locations
    retGame._allLocations = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]       pathForResource:@"ImportantLocations" ofType:@"plist"]];
    //Set initial map parameters
    [retGame setTheMapParameters:1];


    //Set initial score
    retGame._score = 0;
    
    //Set entity
    retGame._entity = &(entity);

    return retGame;

}

//Set the parameters of a GameMap
-(void) setTheMapParameters: (int) level{

    //Important Locations
    //Set current level
    NSString *levelKey = [NSString stringWithFormat: @"Level%d",level];
    _currentLevel = [_levels  objectForKey:levelKey];
    //Populate important locations
    
    _importantLocations = [[NSMutableDictionary alloc] initWithDictionary:
                           [_allLocations objectForKey:levelKey]];

    //Playable locations: all
    _playableLocations = [[NSMutableDictionary alloc] initWithDictionary: _importantLocations];
    //Initiate finished locations
    _finishedLocations = [[NSMutableDictionary alloc] init];
}

-(void)initWithAnotherMap: (GameMap *) game{
    _allLocations = [[NSDictionary alloc] initWithDictionary:game._allLocations];
    _importantLocations = [[NSMutableDictionary alloc] initWithDictionary:game._importantLocations];
    _playableLocations = [[NSMutableDictionary alloc] initWithDictionary:game._playableLocations];
    _finishedLocations = [[NSMutableDictionary alloc] initWithDictionary:game._finishedLocations];
    _score = game._score;
    _currentLevel = [[NSArray alloc] initWithArray:game._currentLevel];
    _levels = [[NSMutableDictionary alloc] initWithDictionary:game._levels];
    _entity = game._entity;
}


//Get the center of the level
-(CLLocation *) getPlayingCenter{
    NSArray *centerValues = [_importantLocations objectForKey:@"Center"];
    return [[CLLocation alloc] initWithLatitude:[[centerValues objectAtIndex:0] intValue]
                                      longitude:[[centerValues objectAtIndex:1] intValue]];
}


//Return the challenge associated with a given location
-(NSDictionary *) getChallengeForImportantLocation: (NSString *) loc {
    return [[_importantLocations objectForKey:loc] objectForKey:@"Challenge"];
    
}

//Increase the games score
-(void)increaseScore: (int) points {
    _score = _score + points;
    if([self isTheCurrentLevelFinished]){
        NSLog(@"New level");
        [self goToNextLevel];
        if([self isTheGameFinished]){
            //Exit game;
            [self finishGame];
        }
    }
}

//Test if the level is finished
-(BOOL) isTheCurrentLevelFinished {
    //For the current level test the max score
    if (_score >= [[_currentLevel objectAtIndex:2] intValue]){
        if([self isTheGameFinished]){
            [self finishGame];
        }
        return YES;
    }
    else {
        return NO;
    }
}

//Test if the game has finished
-(BOOL) isTheGameFinished{
    if ([[_currentLevel objectAtIndex:0] intValue] == _levels.count){
        return YES;
    }
    else {
        return NO;
    }
}

//New level
-(void) goToNextLevel {
    //Actualize the map - setMap
    int oldLevel = [[_currentLevel objectAtIndex:0] intValue];
    int newLevel =  oldLevel +1;
    [self setTheMapParameters:newLevel];
    //Notify new level
    
}

//Finish the game when all level are finished
-(void) finishGame{
    //Inform the player
    
    //Go to the finish screen

}

//A challenge has been finished correctly
-(void)finishChallengeAtLocation: (NSString *)location {
     //Location is finished
    [_finishedLocations setObject:[_importantLocations objectForKey:location] forKey:location];
    //Location is no playable
    [_playableLocations removeObjectForKey:location];
}


//Make persistent objects
//Encoder
-(int)encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self._allLocations forKey: @"allLocations"];
    [encoder encodeObject:self._importantLocations forKey: @"importantLocations"];
    [encoder encodeObject:self._playableLocations forKey:@"playableLocations"];
    [encoder encodeObject:self._finishedLocations forKey:@"finishedLocations"];
    [encoder encodeInteger:self._score forKey:@"Score"];
    [encoder encodeObject:self._levels forKey:@"Levels"];
    [encoder encodeObject:self._currentLevel forKey:@"currentLevel"];
    return *(_entity);

}

//Decoder
+ (GameMap *)initWithCoder:(NSCoder *)decoder {
    GameMap *retGame =[GameMap startANewGame:1 ];
        retGame._allLocations = [decoder decodeObjectForKey:@"allLocations"];
        retGame._importantLocations = [decoder decodeObjectForKey:@"importantLocations"];
        retGame._playableLocations = [decoder decodeObjectForKey:@"playableLocations"];
        retGame._finishedLocations = [decoder decodeObjectForKey:@"finishedLocations"];
        retGame._score = [[decoder decodeObjectForKey:@"Score"] integerValue];
        retGame._levels = [decoder decodeObjectForKey:@"Levels"];
        retGame._currentLevel = [decoder decodeObjectForKey:@"currentLevel"];
    return retGame;
}

//Game object: for saving
-(NSArray *) makeMapObject{
    NSArray *returnArray = [[NSArray alloc] initWithObjects:self._allLocations,self._importantLocations,
    self._playableLocations, self._finishedLocations, self._score, self._levels, self._currentLevel, nil];
    
    return returnArray;
}

//Retreive Map

-(void) setMapObject: (NSArray *) inputs{
    self._allLocations = [inputs objectAtIndex:0 ];
    self._importantLocations = [inputs objectAtIndex:1];
    self._playableLocations = [inputs objectAtIndex:2];
    self._finishedLocations = [inputs objectAtIndex:3];
    self._score = [[inputs objectAtIndex:4] intValue];
    self._levels = [inputs objectAtIndex:5];
    self._currentLevel = [inputs objectAtIndex:6];


}







@end
