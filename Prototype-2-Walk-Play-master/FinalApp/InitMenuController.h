//
//  InitMenuController.h
//  FinalApp
//
//  Created by Lion User on 04/05/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GameMap.h"
#import "MapViewController.h"



@interface InitMenuController : UIViewController <UITableViewDelegate, UITableViewDataSource,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *_playTable;
@property NSCoder *_gameToSave;
@property int _entityToSave;
@property (weak, nonatomic) IBOutlet UIButton *PlayButton;
@property (weak, nonatomic) IBOutlet UIButton *ScoresButton;
@property (weak, nonatomic) IBOutlet UILabel *lastScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *userLabel;

@end
