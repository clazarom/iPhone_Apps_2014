//
//  BoardGame.h
//  MP3
//
//  Created by CatMac on 5/10/14.
//
//

#import <Foundation/Foundation.h>

@interface BoardGame : NSObject

@property NSString *_state1;
@property NSString *_state2;
@property NSString *_player1;
@property NSString *_player2;
@property NSMutableArray *_board;
@property NSString *_playerTurn;

-(NSArray *) columnOcuppancy :(int) col;
+(BoardGame*) initNewGame: (NSString *)p1 and :(NSString *)p2;
-(BOOL) IsAValidMovement: (int) col;
-(int) moveToColumn:(int) col :(NSString *)user;
-(BOOL) didTheUserWin;
-(UIColor *)usersColor :(NSString *) user;
-(void) setOldGame:(NSMutableArray *)board :(NSString *)state1 :(NSString *)state2 :(NSString *)p1 and :(NSString *) p2;
-(NSString *) userState:(NSString *)user;
-(void)setState:(NSString *)user :(BOOL)same :(NSString *)state;
@end
