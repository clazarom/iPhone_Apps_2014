//
//  GameViewController.h
//  MP3
//
//  Created by CatMac on 5/10/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BoardGame.h"
#import "BoardView.h"
#import "InitMenuTableViewController.h"

@interface GameViewController : UIViewController <BoardViewDelegate>
@property BoardGame *_game;
@property (strong, nonatomic) BoardView *boardView;
@property NSString *_user;
@property NSString *_parseId;
@property NSString *_boardId;
@property PFObject *_parseGame;
@property PFObject *_parseBoard;


@end
