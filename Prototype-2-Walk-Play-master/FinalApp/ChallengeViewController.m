//
//  ChallengeViewController.m
//  FinalApp
//
//  Created by CatMac on 5/5/14.
//
//

#import "ChallengeViewController.h"

@interface ChallengeViewController ()

@end



@implementation ChallengeViewController{
    NSDictionary *_allChallenges;
    NSString *_question;
    NSString *_rightAnswer;
    int _pointsForQuestion;
}

@synthesize _locChallenge;
@synthesize _game;
@synthesize _locationID;
@synthesize questionLabel;
@synthesize answerField;
@synthesize endButton;
@synthesize questionTitleLabel;
@synthesize answerTitleLabel;
@synthesize okButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //Load all challenges
        _allChallenges = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]       pathForResource:@"Challenges" ofType:@"plist"]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //All challenges
    _allChallenges = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle]       pathForResource:@"Challenges" ofType:@"plist"]];

    
	// Get challenge information
    NSString *challID = [_locChallenge objectForKey:@"ID"];
    _question =[[_allChallenges objectForKey:challID] objectForKey:@"Question"];
    _rightAnswer =[[_allChallenges objectForKey:challID] objectForKey:@"Answer"];
    //Label and field
    self.questionLabel.text = _question;
    self.answerField.delegate=self;
    self.questionTitleLabel.text = @"Question";
    //NSLog(@"Map chal load(challengeView): %@", _game);
    //NSLog(@"pLAYABLE chal load(challengeView): %@", _game._playableLocations);
    
    //Background
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Compass On Old Map.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];

    //Set Label colors
    self.questionTitleLabel.textColor = [UIColor whiteColor];
    self.answerTitleLabel.textColor = [UIColor whiteColor];
    self.okButton.titleLabel.textColor = [UIColor whiteColor];
    
    [questionTitleLabel setFont:[UIFont fontWithName:@"Papyrus" size:20]];
    [answerTitleLabel setFont:[UIFont fontWithName:@"Papyrus" size:20]];
    [okButton.titleLabel setFont:[UIFont fontWithName:@"Papyrus" size:25]];
    

}

-(void)viewDidUnload{
    [self viewDidUnload];
    
    self._locChallenge=nil;
    self.questionLabel=nil;
    self.answerField=nil;
    self.endButton=nil;
    self._game =nil;
    self.okButton=nil;
    self.questionTitleLabel=nil;
    self.answerTitleLabel=nil;

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)endQuestionEditing:(id)sender {
    [answerField resignFirstResponder];

}

- (IBAction)pressEndButton:(id)sender {
    /*//Check and points
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End of challenge" message:@"eND" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil ];


    if ([self checkAnswer]){
        NSLog(@"PLAYABLE ants finish: (mapView) %@", _game._playableLocations);
        [self increaseScore];
        NSLog(@"PLAYABLE after score finish: (mapView) %@", _game._playableLocations);

        [_game finishChallengeAtLocation:[_locChallenge objectForKey:@"ID"]];
        alert.message=@"Correct!!!";
    }
    else{
    //User should try again later
        alert.message=@"Wrong answer";

    }
    [alert show];
    //Go back to map
    [answerField resignFirstResponder];*/
    
}

-(BOOL)checkAnswer{
    if([_rightAnswer isEqualToString:answerField.text]){
        return YES;
    }
    else{
        return NO;
    }
}

-(void)increaseScore{
    [_game increaseScore:10];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([[segue identifier] isEqualToString:@"challengeEnd"]){
        //Check and points
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"End of challenge" message:@"eND" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil ];
        
        
        if ([self checkAnswer]){
            [self increaseScore];
            //NSLog(@"Location: %@, %@", [[_allChallenges objectForKey:[_locChallenge objectForKey:@"ID"]] objectForKey:@"Location" ], _locationID);
            [_game finishChallengeAtLocation:_locationID];
            alert.message=@"Correct!!!";
        }
        else{
            //User should try again later
            alert.message=@"Wrong answer";
            
        }
        [alert show];
        //Go back to map

        // Get reference to the destination view controller
        MapViewController *vc = [segue destinationViewController];
        
        //Create a new Game and pass it to gameView
        vc._gameMap = [GameMap startANewGame:*(_game._entity)];
        [vc._gameMap initWithAnotherMap:_game];
        
        NSLog(@"Playable locations segue (challenge): %@", _game._playableLocations);

        
        //[vc setMyObjectHere:object];
    }

    
}
@end
