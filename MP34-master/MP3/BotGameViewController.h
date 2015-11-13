//
//  BotGameViewController.h
//  MP3
//
//  Created by CatMac on 5/11/14.
//
//

#import <UIKit/UIKit.h>
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "BoardGame.h"
#import "BoardView.h"
#import "InitMenuTableViewController.h"
#import "IntelligentBot.h"

@interface BotGameViewController : UIViewController <BoardViewDelegate>
@property (strong, nonatomic) BoardView *boardView;


@end
