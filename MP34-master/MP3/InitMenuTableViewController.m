//
//  InitMenuTableViewController.m
//  MP3
//
//  Created by CatMac on 5/10/14.
//
//

#import "InitMenuTableViewController.h"

@interface InitMenuTableViewController (){
    NSMutableArray *_objects;
    NSMutableArray *_playing;
    NSMutableArray *_waiting;
    NSMutableArray *_won;
    NSMutableArray *_lost;
    NSMutableArray *_boardGames;
    PFObject *_gameToPlay;


    
}

@end

@implementation InitMenuTableViewController

@synthesize _menuTableView;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //Hide navigation button
    [self.navigationItem setHidesBackButton:YES];
    
    //Populate the table
    _menuTableView.delegate = self;
    _menuTableView =[[UITableView alloc]  initWithFrame:CGRectZero style:UITableViewStyleGrouped ];
    
    //Init arrays
    _objects =[[NSMutableArray alloc] init];
    _playing =[[NSMutableArray alloc] init];
    _waiting =[[NSMutableArray alloc] init];
    _won =[[NSMutableArray alloc] init];
    _lost =[[NSMutableArray alloc] init];
    _boardGames=[[NSMutableArray alloc] init];
    
    
    //Parse: query
    [self retrieveFromParse];
    
   }

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    //Load all games
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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView reloadData];
}

-(void) retrieveFromParse{
    //Query games
    PFQuery *query = [PFQuery queryWithClassName:@"Game"];
    [query includeKey:@"Board"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. Add the returned objects to allObjects
            for (PFObject *game in objects){
                if([[PFUser currentUser].username isEqualToString: [game objectForKey: @"player1"]] || [[PFUser currentUser].username isEqualToString: [game objectForKey: @"player2"]] ){
                    [_objects addObject:game];
                    NSLog(@"Found an old game");
                }
            }
            [self organizeGamesInSections];
            [self.tableView reloadData];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
   

}

-(void) organizeGamesInSections{
    NSLog(@"Organizing....");
    _playing = [_playing init];
    _waiting = [_waiting init];
    _won = [_won init];
    _lost = [_lost init];

    for (PFObject *game in _objects){
        NSString *state;
        if([[PFUser currentUser].username isEqualToString: [game objectForKey: @"player1"]])
           state = [game objectForKey:@"state1"] ;
        else
            state = [game objectForKey:@"state2"] ;

        if ([state isEqualToString:@"Playing"])
            [_playing addObject:game];
        if ([state isEqualToString:@"Waiting"])
            [_waiting addObject:game];
        if ([state isEqualToString:@"Won"])
            [_won addObject:game];
        if ([state isEqualToString:@"Lost"])
            [_lost addObject:game];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        case 3:
            
            return _playing.count;
            break;
        case 4:
            return _waiting.count;
            break ;
        case 5:
            return _won.count;
            break;
        case 6:
            return _lost.count;
            break;
            
        default:
            break;
    }
    return 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier ;
    UITableViewCell *cell;
    cell.accessoryType=UITableViewCellAccessoryDetailDisclosureButton;
    
    
    // Configure the cell...
    if (indexPath.section==0){
        CellIdentifier = @"UserCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        //cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.text =[NSString stringWithFormat: @"User: %@", [PFUser currentUser].username];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"Games: %d", _objects.count];
    }
    if (indexPath.section==1){
        CellIdentifier = @"BotCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        //cell =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.textLabel.text = @"Stand alone game";
    }

    else  if (indexPath.section==2){
        CellIdentifier = @"New";
        
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.textLabel.text = @"New";
    }
    else if (indexPath.section ==3){
        //Playing games
        CellIdentifier = @"Old";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        cell.textLabel.text = @"Playing";
    
        PFObject *game = [_playing objectAtIndex:indexPath.row];

        if( [[game objectForKey:@"player1"] isEqualToString:[PFUser currentUser].username]){
            cell.detailTextLabel.text = [game objectForKey:@"player2"];
            
        }else
            cell.detailTextLabel.text = [game objectForKey:@"player1"];


    }

    else if (indexPath.section ==4){
        //Waiting to play games
        CellIdentifier = @"Old";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        cell.textLabel.text = @"Waiting";
        
        PFObject *game = [_waiting objectAtIndex:indexPath.row];
        if( [[game objectForKey:@"player1"] isEqualToString:[PFUser currentUser].username]){
            cell.detailTextLabel.text = [game objectForKey:@"player2"];
            
        }else
            cell.detailTextLabel.text = [game objectForKey:@"player1"];

        
    }
    else if (indexPath.section ==5){
        //Playing games
        CellIdentifier = @"Old";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        cell.textLabel.text = @"Won";
        PFObject *game = [_won objectAtIndex:indexPath.row];
        if( [[game objectForKey:@"player1"] isEqualToString:[PFUser currentUser].username]){
            cell.detailTextLabel.text = [game objectForKey:@"player2"];
            
        }else
            cell.detailTextLabel.text = [game objectForKey:@"player1"];
        

    }
    else if (indexPath.section ==6){
        //Lost games
        CellIdentifier = @"Old";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

        cell.textLabel.text = @"Lost";
        PFObject *game = [_lost objectAtIndex:indexPath.row];
        if( [[game objectForKey:@"player1"] isEqualToString:[PFUser currentUser].username]){
            cell.detailTextLabel.text = [game objectForKey:@"player2"];
            
        }else
            cell.detailTextLabel.text = [game objectForKey:@"player1"];
        
        


    }
    
    return cell;
}

- (void) SegueWithSelectRowAtPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.section) {
        case 3:
            _gameToPlay =[_playing objectAtIndex:indexPath.row];
            break;
        case 4:
            _gameToPlay =[_waiting objectAtIndex:indexPath.row];

            break;
        case 5:
            _gameToPlay =[_won objectAtIndex:indexPath.row];
            break;
        case 6:
            _gameToPlay =[_lost objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }

    //[self performSegueWithIdentifier:@"OldGame" sender:self];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

//In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([[segue identifier] isEqualToString:@"OldGame"]){
        [self SegueWithSelectRowAtPath:[[self tableView] indexPathForSelectedRow]];
        if(_gameToPlay){
        //Get info from PFObject
        //[_gameToPlay objectForKey: @"player1"];
        
        NSMutableArray *retArray = [[NSMutableArray alloc] init];
        for(int i =1; i < 8; i++){
            //Column blank
            NSMutableArray *col = [[NSMutableArray alloc] init];
            NSString *key = [NSString stringWithFormat:@"column%d",i];
            NSMutableArray *cAux = [[NSMutableArray alloc] initWithArray:[[_gameToPlay objectForKey:@"Board"] objectForKey:key]];
            if(!cAux.count==0 )
                col = cAux;
            [retArray addObject:col];
            }



        // Get reference to the destination view controller
        GameViewController *vc = [segue destinationViewController];
        
            
        //Create a new Game and pass it to gameView
        vc._game =[BoardGame initNewGame:[PFUser currentUser].username and:@"user"];
        [vc._game setOldGame:retArray :[_gameToPlay objectForKey: @"state1"] :[_gameToPlay objectForKey: @"state2"]:[_gameToPlay objectForKey: @"player1"] and:[_gameToPlay objectForKey: @"player2"]];
        vc._user = [PFUser currentUser].username;
        vc._parseId=_gameToPlay.objectId;
        PFObject *b =[_gameToPlay objectForKey:@"Board"];

        vc._boardId=b.objectId;
        NSLog(@"Id : %@", vc._boardId);
        vc._parseGame= _gameToPlay;
        vc._parseBoard = b;
        }

    }
    

}


#pragma mark - Parse

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
    //[self dismissModalViewControllerAnimated:YES]; // Dismiss the PFSignUpViewController
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
