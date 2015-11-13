//
//  MapViewController.h
//  FinalApp
//
//  Created by Lion User on 03/05/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "GameMap.h"
#import "ChallengeViewController.h"
#import "MenuGameViewController.h"




@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>

@property GameMap *_gameMap;
@property (weak, nonatomic) IBOutlet MKMapView *_gameView;
@property (weak, nonatomic) IBOutlet UIButton *menuButton;


@end
