//
//  ChallengeViewController.h
//  FinalApp
//
//  Created by CatMac on 5/5/14.
//
//

#import <UIKit/UIKit.h>
#import "GameMap.h"
#import "MapViewController.h"



@interface ChallengeViewController : UIViewController<UITextFieldDelegate>

@property NSDictionary *_locChallenge;
@property GameMap *_game;
@property NSString *_locationID;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
@property (weak, nonatomic) IBOutlet UITextField *answerField;
@property (weak, nonatomic) IBOutlet UIButton *endButton;
@property (weak, nonatomic) IBOutlet UILabel *questionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *answerTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *okButton;


- (IBAction)endQuestionEditing:(id)sender;
- (IBAction)pressEndButton:(id)sender;

@end
