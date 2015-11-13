//
//  Event.m
//  FinalApp
//
//  Created by Lion User on 03/05/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@implementation Event
@synthesize eventId;
@synthesize eventTtype;

//The event is taking place
//The event view has to start

-(void) startEvent: (NSString *) eType and :(NSString *) eId{
    //Depending on the type
    //Load an event view
    
    //The event id load the specific information
}


//The event is finishing
-(void) finishEvent {
    //Add the locations as finished
    
}

//The player has answer the question of the Challenge
//Return if this answer is correct
-(BOOL) receiveAnswer: (NSString *) answer{
    
    //Return correct or not
    return NO;
}



@end
