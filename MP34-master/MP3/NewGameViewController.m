//
//  NewGameViewController.m
//  MP3
//
//  Created by CatMac on 5/10/14.
//
//

#import "NewGameViewController.h"

@interface NewGameViewController ()

@end


@implementation NewGameViewController

@synthesize _userField;

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
    _userField.delegate=self;
}

-(void)viewDidUnload{
    self._userField=nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"StartGame"]){
        if ([_userField.text isEqualToString: @""]){
            UIAlertView *promp =[[UIAlertView alloc] initWithTitle:@"NoUser"
                                                           message:@"Choose a user to play with"
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [promp show];
            return NO;
        }
        else
            return YES;
    }
    return NO;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"StartGame"]){
        
        //Query the other user
        //Query games
        PFQuery *query = [PFQuery queryWithClassName:@"User"];
        PFACL *groupACL = [PFACL ACL];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                // The find succeeded. Add the returned objects to allObjects
                for (PFUser *user in objects){
                    if([user.username isEqualToString:_userField.text ] ){
                        [groupACL setReadAccess:YES forUser:user];
                        [groupACL setWriteAccess:YES forUser:user];
                    }
                }

                
            } else {
                // Log details of the failure
                NSLog(@"Error: %@ %@", error, [error userInfo]);
            }
        }];

        
        // Get reference to the destination view controller
        GameViewController *vc = [segue destinationViewController];
        
        //Create a new Game and pass it to gameView
        vc._game = [BoardGame initNewGame:[PFUser currentUser].username and:_userField.text];
        vc._user = [PFUser currentUser].username;
        [vc._game setState:vc._user :YES :@"Playing"];
        [vc._game setState:vc._user :NO :@"Waiting"];
        
        
        //Parse objects
        PFObject *pGame = [PFObject objectWithClassName:@"Game"];
        PFObject *pBoard = [PFObject objectWithClassName:@"Board"];
        pGame [@"player1"]=vc._game._player1;
        pGame [@"player2"]=vc._game._player2;
        pGame [@"state1"]=vc._game._state1;
        pGame [@"state2"]=vc._game._state2;
        
        pBoard [@"column1"]=[vc._game._board objectAtIndex:0];
        pBoard [@"column2"]=[vc._game._board objectAtIndex:1];
        pBoard [@"column3"]=[vc._game._board objectAtIndex:2];
        pBoard [@"column4"]=[vc._game._board objectAtIndex:3];
        pBoard [@"column5"]=[vc._game._board objectAtIndex:4];
        pBoard [@"column6"]=[vc._game._board objectAtIndex:5];
        pBoard [@"column7"]=[vc._game._board objectAtIndex:6];
        
        PFACL *postACL = [PFACL ACLWithUser:[PFUser currentUser]];
        [postACL setPublicReadAccess:YES];
        [postACL setPublicWriteAccess:YES];
        [groupACL setReadAccess:YES forUser:[PFUser currentUser]];
        [groupACL setWriteAccess:YES forUser:[PFUser currentUser]];
        
        pGame.ACL = groupACL;
        pBoard.ACL=groupACL;
        
        [pGame setObject:pBoard forKey:@"Board"];
        
        [pGame saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
                NSLog(@"Error: %@", error);
        }];
        
        vc._parseGame = pGame;
        vc._parseBoard = pBoard;
        
        
    }

}

- (IBAction)endEditing:(id)sender {
    [self resignFirstResponder];
}
@end
