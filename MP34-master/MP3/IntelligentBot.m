//
//  IntelligentBot.m
//  MP3
//
//  Created by CatMac on 5/11/14.
//
//

#import "IntelligentBot.h"

@implementation IntelligentBot{

}

@synthesize _game;
@synthesize  _level;

+(IntelligentBot *)newBot:(int)level{
    IntelligentBot *newBot;
    newBot._level = level;
    newBot._game = [BoardGame initNewGame:@"User" and:@"Bot"];
    return newBot;
}

-(int) makeBestMovement :(BoardGame *)game{
    [_game setOldGame:game._board :game._state1 :game._state2 :game._player1 and:game._player2];

    int chosenCol =0;
    int value =0;
    for (int i =0; i<_game._board.count ; i++) {
        //Analyze next movements
        if([game IsAValidMovement:i]){
            [game moveToColumn:i :@"Bot"];
            for (int j=1; j<_level; j++){
                for (int k = 0; k<_game._board.count; k++){
                    //Depending on the level, look further
                    if(j%2 ==0){
                        //Even turn - bot
                        [game moveToColumn:k :@"Bot"];
                        int evaluation =[self evaluateCurrentGame];
                        if (evaluation >value){
                            value = evaluation;
                            chosenCol =k;
                        }
                        //Take the piece out of the map
                        NSMutableArray *col = [game._board objectAtIndex:k];
                        [col removeObjectAtIndex:col.count];

                    }else{
                        //Odd turn - user
                        [game moveToColumn:k :@"User"];
                        int evaluation =[self evaluateCurrentGame];
                        if (evaluation >value){
                            value = evaluation;
                            chosenCol =k;
                        }
                        //Take the piece out of the map
                        NSMutableArray *col = [game._board objectAtIndex:k];
                        [col removeObjectAtIndex:col.count];

                    }
                }
            }
        }
        //Evaluate first movement
        if(_level ==1){
            chosenCol =i;
            int evaluation =[self evaluateCurrentGame];
            if (evaluation >value){
                value = evaluation;
                chosenCol =i;
            }
        
        //Take the piece out of the map
        NSMutableArray *col = [game._board objectAtIndex:i];
        [col removeObjectAtIndex:col.count];
        }

    }
    if ([_game IsAValidMovement:chosenCol])
        return chosenCol;
    else
        return chosenCol+1;
}

-(int)evaluateCurrentGame{
    int ev =0;
    int rowSize = _game._board.count;
    for (int i =0; i<rowSize ; i++){
        NSArray *col =[_game._board objectAtIndex:i];
        int colSize = col.count;
        for (int k = 0; k<colSize; k++){
            NSString *ficha = [col objectAtIndex:k];
            //Evaluate up
            if((k<colSize-1) && [ficha isEqualToString:[col objectAtIndex:k+1]]){
                if((k<colSize-2)&& [ficha isEqualToString:[col objectAtIndex:k+2]] ){
                    if ((k<colSize-3)&& [ficha isEqualToString:[col objectAtIndex:k+3]]){
                        if (10 >ev){
                            ev =10;
                        }
                    }
                    else if (7 >ev){
                        ev =7;
                    }
                }
                else if (5 >ev){
                    ev =5;
                }
            }
            //Evaluate right
            if((k<rowSize-1) && [ficha isEqualToString:[[_game._board objectAtIndex:i+1] objectAtIndex:k]]){
                if((k<rowSize-2)&& [ficha isEqualToString:[[_game._board objectAtIndex:i+2] objectAtIndex:k]] ){
                    if ((k<rowSize-3)&& [ficha isEqualToString:[[_game._board objectAtIndex:i+3] objectAtIndex:k]]){
                        if (10 >ev){
                            ev =10;
                        }
                    }
                    else if (7 >ev){
                        ev =7;
                    }
                }
                else if (5 >ev){
                    ev =5;
                }
            }
            
            //Evaluate diagonal up-right
            if((k<rowSize-1) && (k<colSize-1)&&[ficha isEqualToString:[[_game._board objectAtIndex:i+1] objectAtIndex:k+1]]){
                if((k<rowSize-2)&& (k<colSize-2)&&[ficha isEqualToString:[[_game._board objectAtIndex:i+2] objectAtIndex:k+2]] ){
                    if ((k<rowSize-3)&& (k<colSize-3)&&[ficha isEqualToString:[[_game._board objectAtIndex:i+3] objectAtIndex:k+3]]){
                        if (10 >ev){
                            ev =10;
                        }
                    }
                    else if (8 >ev){
                        ev =8;
                    }
                }
                else if (6 >ev){
                    ev =6;
                }
            }

        }
    }
    
    return ev;
}


@end
