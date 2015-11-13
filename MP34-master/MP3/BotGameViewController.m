//
//  BotGameViewController.m
//  MP3
//
//  Created by CatMac on 5/11/14.
//
//

#import "BotGameViewController.h"

@interface BotGameViewController (){
    BoardGame *_game;
    IntelligentBot *_bot;
}

@end

@implementation BotGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Init bot and game
    _game =[BoardGame initNewGame:@"User" and:@"Bot"];
    _bot = [IntelligentBot newBot:3];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [super viewDidAppear:animated];
    self.boardView = [[BoardView alloc] initWithFrame:self.view.bounds slotDiameter:40];
    self.boardView.delegate = self;
    [self.view addSubview:self.boardView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)boardView:(BoardView *)boardView columnSelected:(int)column
{
    //The user plays
    if([[_game userState:@"User" ] isEqualToString:@"Playing"]&&[_game IsAValidMovement:(column-1)]){
        int row =[_game moveToColumn:(column-1) :@"User"];
        UIView *piece = [[UIView alloc]
                         initWithFrame:CGRectMake(column*self.boardView.gridWidth-self.boardView.slotDiameter/2.0,
                                                  -self.boardView.slotDiameter,
                                                  self.boardView.slotDiameter,
                                                  self.boardView.slotDiameter)];
        piece.backgroundColor = [_game usersColor:@"User"];
        [self.view insertSubview:piece belowSubview:self.boardView];
        [UIView animateWithDuration:2.0 animations:^{
            piece.center = CGPointMake(column*self.boardView.gridWidth, (7-row)*self.boardView.gridHeight);
        } completion:^(BOOL finished){
            if ([_game didTheUserWin])
                [self winningUser:@"User"];
            //After a movement, leave game and wait for the other user
            [_game setState:@"User" :YES :@"Waiting"];
            [_game setState:@"User" :NO :@"Playing"];
            
            

        }];
    }
    else
        NSLog(@"Not a valid position");
    
    //Bot Playing after
    int moves = [_bot makeBestMovement:_game]+1;
    NSLog(@"bEST move: %d", moves);
    if([[_game userState:@"Bot" ] isEqualToString:@"Playing"]&&[_game IsAValidMovement:(moves-1)]){
        int row2 =[_game moveToColumn:(moves-1) :@"Bot"];
        UIView *piece2 = [[UIView alloc]
                         initWithFrame:CGRectMake(moves*self.boardView.gridWidth-self.boardView.slotDiameter/2.0,
                                                  -self.boardView.slotDiameter,
                                                  self.boardView.slotDiameter,
                                                  self.boardView.slotDiameter)];
        piece2.backgroundColor = [_game usersColor:@"Bot"];
        [self.view insertSubview:piece2 belowSubview:self.boardView];
        [UIView animateWithDuration:2.0 animations:^{
            piece2.center = CGPointMake(moves*self.boardView.gridWidth, (7-row2)*self.boardView.gridHeight);
        } completion:^(BOOL finished){
            if ([_game didTheUserWin])
                [self winningUser:@"Bot"];
            //After a movement, leave game and wait for the other user
            [_game setState:@"Bot" :YES :@"Waiting"];
            [_game setState:@"Bot" :NO :@"Playing"];
            
        }];
    }
    else
        NSLog(@"Not a valid position");

}

-(void) winningUser :(NSString *) us{
    //Promp winning
    UIAlertView *promp =[[UIAlertView alloc] initWithTitle:@"Win"
                                                   message:@"You win!"
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
    [promp show];
    
    //Change states
    [_game setState:us :YES :@"Won"];
    [_game setState:us :NO :@"Lost"];
    
    //Go to initMenu
    InitMenuTableViewController *myController =[self.storyboard instantiateViewControllerWithIdentifier:@"Init"];
    [self.navigationController pushViewController:myController animated:YES];
}



@end
