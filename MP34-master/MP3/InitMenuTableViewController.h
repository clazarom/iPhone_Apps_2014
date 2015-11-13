//
//  InitMenuTableViewController.h
//  MP3
//
//  Created by CatMac on 5/10/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GameViewController.h"


@interface InitMenuTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource,PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *_menuTableView;

@end
