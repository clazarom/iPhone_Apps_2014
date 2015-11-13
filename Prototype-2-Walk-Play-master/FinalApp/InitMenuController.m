//
//  InitMenuController.m
//  FinalApp
//
//  Created by Lion User on 04/05/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "InitMenuController.h"

@interface InitMenuController ()

@end

@implementation InitMenuController{
    NSMutableArray *_games;
    NSString *_appFile;
}

@synthesize _playTable;
@synthesize _gameToSave;
@synthesize _entityToSave;
@synthesize userLabel;
@synthesize lastScoreLabel;
@synthesize PlayButton;
@synthesize ScoresButton;



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
    //Delegates
    _playTable.delegate = self;
    _playTable.dataSource =self;
    
    //No back button
    self.navigationItem.hidesBackButton = YES;
    
    //Set Games
    [self setAllGamesStarted];
    
    //Values of table
    
    //Background
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Compass On Old Map.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    

     //Set Label colors
     self.userLabel.textColor = [UIColor blackColor];
     self.userLabel.highlighted = YES;
     self.lastScoreLabel.textColor = [UIColor blackColor];
     self.lastScoreLabel.highlighted = YES;
     self.PlayButton.titleLabel.textColor = [UIColor whiteColor];
     self.ScoresButton.titleLabel.textColor = [UIColor whiteColor];

     [userLabel setFont:[UIFont fontWithName:@"Papyrus" size:20]];
     [lastScoreLabel setFont:[UIFont fontWithName:@"Papyrus" size:20]];
     [PlayButton.titleLabel setFont:[UIFont fontWithName:@"Papyrus" size:20]];
     [ScoresButton.titleLabel setFont:[UIFont fontWithName:@"Papyrus" size:15]];
    
    //Table view
    _playTable.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;




    
   
}

//Parse login


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }


}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self._gameToSave=nil;
    self._playTable=nil;
    self.userLabel=nil;
    self.lastScoreLabel=nil;
    self.PlayButton=nil;
    self.ScoresButton=nil;


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) setAllGamesStarted{
    /*//Get games
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    _appFile = [documentsDirectory stringByAppendingPathComponent:@"set.txt"];
    NSLog(@"appFile: %@ ",_appFile);
    
    //Get the context
    _games= [NSKeyedUnarchiver unarchiveObjectWithFile:_appFile];
    NSLog (@"GAMES: %d", [_games count]);
    BOOL replacement = NO;
    [NSKeyedArchiver archiveRootObject:_games toFile:_appFile];
    //Check replacements
    for (id ident in _games){
        if (ident == entity){
            //Replace
            //Take the old out
            //Insert the new one
            [NSKeyedArchiver archiveRootObject:_games toFile:_appFile];
            

            replacement=YES;
        }
    }
    if (!replacement) {
        //Add new game to the list
        [_games setValue:_gameToSave forKey:[NSString stringWithFormat:@"%d", _entityToSave]];
        [NSKeyedArchiver archiveRootObject:_games toFile:_appFile];

    }*/
    
    //Retrieve Maps from Parse
    //[query getObjectInBackgroundWithId:@"xWMyZ4YEGZ" block:^(PFObject *gameScore, NSError *error) {
        // Do something with the returned PFObject in the gameScore variable.
    //}];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. Add the returned objects to allObjects
            [_games addObjectsFromArray:objects];
            NSLog(@"Game Retreived");

                 
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
                 }
                 }];
    

}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_games count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"InitCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell
    PFObject *rowMap = [_games objectAtIndex:indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"Game number: %@", rowMap[@"entity"]];
    
    return cell;

}

/*-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self performSegueWithIdentifier:@"previousGame" sender:indexPath];
    
}*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //If pressing PLAY: new game
    if ([[segue identifier] isEqualToString:@"newGame"]){
        // Get reference to the destination view controller
        MapViewController *vc = [segue destinationViewController];
        
        
        //Create a new Game and pass it to gameView
        vc._gameMap = [GameMap startANewGame:[_games count]+1];
        
        //[vc setMyObjectHere:object];
    }
    
    //If pressing one of the cells: load old game
    else if ([[segue identifier] isEqualToString:@"previousGame"]){
        // Get reference to the destination view controller
        MapViewController *vc = [segue destinationViewController];
        NSLog(@"Mensaje Previo");
        
        NSIndexPath *index = [self._playTable indexPathForSelectedRow];
        //Get the corresponding old game and pass it to the mapView
        NSCoder *savedGame = [_games objectAtIndex:index.row];
        vc._gameMap = [GameMap initWithCoder:savedGame];
        
    }
    
}

/**********************************************
 Parse login menu:
            Functions
 */

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Make sure you fill out all of the information!"
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
    [self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"Failed to sign up...");
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"User dismissed the signUpViewController");
}


@end
