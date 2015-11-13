//
//  MenuGameViewController.h
//  FinalApp
//
//  Created by CatMac on 5/4/14.
//
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GameMap.h"
#import "InitMenuController.h"



@interface MenuGameViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property GameMap *_map;
@property (weak, nonatomic) IBOutlet UITableView *_menuGameTable;
+(void)addArrayToPFObject: (PFObject *) pf :(NSDictionary *) array and :(NSString *) param;

@end
