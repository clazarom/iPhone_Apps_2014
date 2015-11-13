//
//  DetailViewController.h
//  MP2
//
//  Created by Lion User on 03/04/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
