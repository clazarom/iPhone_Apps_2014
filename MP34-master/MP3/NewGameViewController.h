//
//  NewGameViewController.h
//  MP3
//
//  Created by CatMac on 5/10/14.
//
//

#import <UIKit/UIKit.h>
#import "GameViewController.h"
#import "BoardGame.h"
#import <Parse/Parse.h>

@interface NewGameViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *_userField;
- (IBAction)endEditing:(id)sender;

@end
