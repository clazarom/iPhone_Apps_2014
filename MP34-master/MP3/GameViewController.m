//
//  GameViewController.m
//  MP3
//
//  Created by CatMac on 5/10/14.
//
//

#import "GameViewController.h"

@interface GameViewController ()

@end



@implementation GameViewController

@synthesize  _game;
@synthesize _user;
@synthesize _parseId;
@synthesize _parseGame;
@synthesize _parseBoard;

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
	// Do any additional setup after loading the view.
    //[self paintBoard];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.boardView = [[BoardView alloc] initWithFrame:self.view.bounds slotDiameter:40];
    self.boardView.delegate = self;
    [self.view addSubview:self.boardView];
    
    //Add previous game
    for (int i =0; i <7; i++){
        NSArray *col = [_game._board objectAtIndex:i];
        if(col.count >0){
            for (int row=0; row< col.count; row++){
                NSString *ficha = [col objectAtIndex:row];
                if(![ficha isEqualToString:@""]){
                    UIView *piece = [[UIView alloc]
                     initWithFrame:CGRectMake((i+1)*self.boardView.gridWidth-self.boardView.slotDiameter/2.0,
                     -self.boardView.gridWidth,
                     self.boardView.slotDiameter,
                     self.boardView.slotDiameter)];
                     piece.backgroundColor = [_game usersColor:ficha];
                     piece.center = CGPointMake((i+1)*self.boardView.gridWidth, (6-row)*self.boardView.gridHeight);
                     [self.view insertSubview:piece belowSubview:self.boardView];
                     }
                    
                    /*UIView *piece = [[UIView alloc]
                                     initWithFrame:CGRectMake(i*self.boardView.gridWidth-self.boardView.slotDiameter/2.0,
                                                              -self.boardView.slotDiameter,
                                                              self.boardView.slotDiameter,
                                                              self.boardView.slotDiameter)];
                    piece.backgroundColor = [_game usersColor:ficha];
                    [self.view insertSubview:piece belowSubview:self.boardView];
                    [UIView animateWithDuration:2.0 animations:^{
                        piece.center = CGPointMake(i*self.boardView.gridWidth, (7-row)*self.boardView.gridHeight);
                    }];*/
                    
                }
                
            }
        }

}



- (void)boardView:(BoardView *)boardView columnSelected:(int)column
{
    NSLog(@"State of user is: %@", [_game userState:_user ] );
    if([[_game userState:_user ] isEqualToString:@"Playing"]&&[_game IsAValidMovement:(column-1)]){
        int row =[_game moveToColumn:(column-1) :_user];
        UIView *piece = [[UIView alloc]
                     initWithFrame:CGRectMake(column*self.boardView.gridWidth-self.boardView.slotDiameter/2.0,
                                              -self.boardView.slotDiameter,
                                              self.boardView.slotDiameter,
                                              self.boardView.slotDiameter)];
        piece.backgroundColor = [_game usersColor:_user];
        [self.view insertSubview:piece belowSubview:self.boardView];
        [UIView animateWithDuration:2.0 animations:^{
        piece.center = CGPointMake(column*self.boardView.gridWidth, (7-row)*self.boardView.gridHeight);
        } completion:^(BOOL finished){
            if ([_game didTheUserWin])
                [self winningUser:_user];
            //After a movement, leave game and wait for the other user
            [_game setState:_user :YES :@"Waiting"];
            [_game setState:_user :NO :@"Playing"];
            NSLog(@"sTATE: %@", [_game userState:_user]);
            //Save game to Parse
            [self saveToParse];

            //Go to init menu
            InitMenuTableViewController *myController =[self.storyboard instantiateViewControllerWithIdentifier:@"Init"];
            [self.navigationController pushViewController:myController animated:YES];
        } ];
        
    }
    else
        NSLog(@"Not a valid position");
}

-(void) saveToParse {

    if (_parseGame){
      NSLog(@"parsegame: %@", _parseGame);
     _parseGame [@"player1"]=_game._player1;
     _parseGame [@"player2"]=_game._player2;
     _parseGame [@"state1"]=_game._state1;
     _parseGame [@"state2"]=_game._state2;
    
    _parseBoard [@"column1"]=[_game._board objectAtIndex:0];
    _parseBoard [@"column2"]=[_game._board objectAtIndex:1];
    _parseBoard [@"column3"]=[_game._board objectAtIndex:2];
    _parseBoard [@"column4"]=[_game._board objectAtIndex:3];
    _parseBoard [@"column5"]=[_game._board objectAtIndex:4];
    _parseBoard [@"column6"]=[_game._board objectAtIndex:5];
    _parseBoard [@"column7"]=[_game._board objectAtIndex:6];
        
        [_parseGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
                NSLog(@"Error: %@", error);
        }];
    }
    else{
        NSLog(@"nooooooo parsegame: %@", _parseGame);

        //Parse objects
        PFObject *pGame = [PFObject objectWithClassName:@"Game"];
        PFObject *pBoard = [PFObject objectWithClassName:@"Board"];
        pGame [@"player1"]=_game._player1;
        pGame [@"player2"]=_game._player2;
        pGame [@"state1"]=_game._state1;
        pGame [@"state2"]=_game._state2;
        
        pBoard [@"column1"]=[_game._board objectAtIndex:0];
        pBoard [@"column2"]=[_game._board objectAtIndex:1];
        pBoard [@"column3"]=[_game._board objectAtIndex:2];
        pBoard [@"column4"]=[_game._board objectAtIndex:3];
        pBoard [@"column5"]=[_game._board objectAtIndex:4];
        pBoard [@"column6"]=[_game._board objectAtIndex:5];
        pBoard [@"column7"]=[_game._board objectAtIndex:6];
        
        PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [postACL setPublicReadAccess:YES];
        [postACL setPublicWriteAccess:YES];
        pGame.ACL = postACL;
        pBoard.ACL= postACL;
        
        [pGame setObject:pBoard forKey:@"Board"];

        
        [pGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
                NSLog(@"Error: %@", error);
        }];

    }
    
    //[_parseGame setObject:_parseBoard forKey:@"Board"];

    [_parseGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
            NSLog(@"Error: %@", error);
    }];

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
    //Save game to Parse
    [self saveToParse];
    
    //Go to initMenu
    InitMenuTableViewController *myController =[self.storyboard instantiateViewControllerWithIdentifier:@"Init"];
    [self.navigationController pushViewController:myController animated:YES];
}

@end
