//
//  BoardGame.m
//  MP3
//
//  Created by CatMac on 5/10/14.
//
//

#import "BoardGame.h"

@implementation BoardGame

@synthesize _state1;
@synthesize _state2;
@synthesize _player1;
@synthesize _player2;
@synthesize _board;
@synthesize _playerTurn;

//Init a blank score board
+(BoardGame *) initNewGame: (NSString *)p1 and :(NSString *)p2{
    //New boardgame
    BoardGame *newGame =[[BoardGame alloc] init];
    //Set the game board
    newGame._board = [[NSMutableArray alloc] init];
    
    //Blank game
    for(int i =0; i < 7; i++){
        //Column blank
        NSMutableArray *col = [[NSMutableArray alloc] init];
        [newGame._board addObject:col];
    }
    
    //Set the users
    newGame._player1 = p1;
    newGame._player2 = p2;
    
    //Set the state: playing
    newGame._state1=@"Playing";
    newGame._state2=@"Wating";
    
    return newGame;
}

//Set a Game
-(void) setOldGame:(NSMutableArray *)board :(NSString *)state1 :(NSString *)state2 :(NSString *)p1 and :(NSString *) p2 {
    _board=board;
    _state1=state1;
    _state2=state2;
    _player1=p1;
    _player2=p2;
}

- (NSString *)userState:(NSString *)user{
    if ([user isEqualToString:_player1]) {
        return _state1;
    }else if([user isEqualToString:_player2])
        return _state2;
    return @"";
}

-(void)setState:(NSString *)user :(BOOL)same :(NSString *)state{
    if([user isEqualToString:_player1]){
        if(same)
            _state1=state;
        else
            _state2=state;

    }else if([user isEqualToString:_player2]){
        if(same)
            _state2=state;
        else
            _state1=state;
    }
}

    
-(BOOL) IsAValidMovement: (int) col{
    if (col >= _board.count)
        return NO;
    else if([[_board objectAtIndex:col] count] >= 6)
        return NO;
    else
        return YES;
}





-(int) moveToColumn:(int) col :(NSString *)user{
    if ([user isEqualToString:_player1]||[user isEqualToString:_player2]){
        NSMutableArray *column =[_board objectAtIndex:col];
        [column addObject:user];
        return column.count;
    }
    return 0;

}

-(BOOL) didTheUserWin {
    if([self checkVertical]||[self checkDiagonal]||[self checkHorizontal])
        return YES;
    else
        return NO;
}

-(BOOL)checkVertical{
    NSLog(@"Vertical");

    for (int i =0; i < 3; i++){
        NSArray *column =[_board objectAtIndex:i];
        if(column.count >=3){
            for (int j =0; j<column.count-3
                 ; j++){
                NSString *ficha =[column objectAtIndex:j] ;
                if (![ficha isEqualToString:@""]){
                    NSString *ficha1=[column objectAtIndex:j+1];
                    NSString *ficha2=[column objectAtIndex:j+2];
                    NSString *ficha3=[column objectAtIndex:j+3];
                    NSLog(@"hAY UNA FICHA");
                    if ([ficha isEqualToString:ficha1]){
                        NSLog(@"Dos verticales iguales");
                        if([ficha isEqualToString:ficha2]){
                            NSLog(@"Tres verticales iguales");
                            if([ficha isEqualToString:ficha3]){
                                NSLog(@"Cuatro verticales iguales");
                                return YES;
                            }
                        }
                    }
                }
            }
        }
    }
    return NO;
}

-(BOOL) checkHorizontal{
    for (int i =0; i < 4; i++){
        NSArray *column1 =[_board objectAtIndex:i];
        NSArray *column2 =[_board objectAtIndex:i+1];
        NSArray *column3 =[_board objectAtIndex:i+2];
        NSArray *column4 =[_board objectAtIndex:i+3];

        for (int j =0; j<column1.count&&j<column2.count&&j<column3.count&&j<column4.count; j++){
            NSString *ficha =[column1 objectAtIndex:j] ;
            if (![ficha isEqualToString:@""]&&i>2){
                NSLog(@"hAY UNA FICHA");
                NSString *ficha1=[column2 objectAtIndex:j];
                NSString *ficha2=[column3 objectAtIndex:j];
                NSString *ficha3=[column4 objectAtIndex:j];
                
                if ([ficha isEqualToString:ficha1]&&[ficha isEqualToString:ficha2]&&[ficha isEqualToString:ficha3]){
                    NSLog(@"Cuatro horizontales iguales");
                    return YES;
                }
            }

        }
    }
    return NO;
}
-(BOOL) checkDiagonal{
    for (int j=3; j<4; j++){
        int i =3;
        NSArray *column =[_board objectAtIndex:i];
        if (column.count>=i){
            NSArray *column1 =[_board objectAtIndex:i+1];
            NSArray *column2 =[_board objectAtIndex:i+2];
            NSArray *column3 =[_board objectAtIndex:i+3];
            NSArray *columnA =[_board objectAtIndex:i-1];
            NSArray *columnB =[_board objectAtIndex:i-2];
            NSArray *columnC =[_board objectAtIndex:i-3];
            NSString *ficha = [column objectAtIndex:j];
            if (![ficha isEqualToString:@""]
                &&(column1.count >=j)
                &&(column2.count >=j)
                &&(column3.count >=j)
                &&[ficha isEqualToString:[column1 objectAtIndex:j-1]]
                &&[ficha isEqualToString:[column2  objectAtIndex:j-2]]
                &&[ficha isEqualToString:[column3  objectAtIndex:j-3]]){
                NSLog(@"dIAGONAL HACIA LA DERECHA, arriba");
                return YES;
            }
            else if(![ficha isEqualToString:@""]
                    &&(columnA.count >=j)
                    &&(columnB.count >=j)
                    &&(columnC.count >=j)
                    &&[ficha isEqualToString:[columnA objectAtIndex:j-1]]
                    &&[ficha isEqualToString:[columnB objectAtIndex:j-2]]
                    &&[ficha isEqualToString:[columnC objectAtIndex:j-3]]){
                NSLog(@"dIAGONAL HACIA LA DERECHA, arriba");
                return YES;
            }
        }
    }
    

    return NO;
}

-(UIColor *)usersColor :(NSString *) user{
    if ([user isEqualToString:_player1])
        return [UIColor redColor] ;
    else  if ([user isEqualToString:_player2])
        return [UIColor greenColor];
    else
        return [UIColor whiteColor];
}

-(NSArray *) columnOcuppancy :(int) col{
    return [_board objectAtIndex: col];
}
@end
