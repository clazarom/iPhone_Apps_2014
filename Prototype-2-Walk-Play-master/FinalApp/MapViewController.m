//
//  MapViewController.m
//  FinalApp
//
//  Created by Lion User on 03/05/2014.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "MapViewController.h"
#import "ChallengeViewController.h"

#define METERS_PER_MILE 1609.344

@interface MapViewController (){
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocation *oldLocation;
    NSDictionary *playLocations;
    
}

@end



@implementation MapViewController

@synthesize _gameMap;
@synthesize _gameView;
@synthesize menuButton;

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
    
    //Location Manager
    locationManager=[[CLLocationManager alloc] init ];
    
    //Background
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Compass On Old Map.jpg"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    //Set Label colors
    [menuButton.titleLabel setFont:[UIFont fontWithName:@"Papyrus" size:20]];
    [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //No back button
    self.navigationItem.hidesBackButton = YES;
    

    


}

- (void)viewWillAppear:(BOOL)animated {
    //Set map configuration
    //[self configureMapView];
    //Set Locations in the map
    [self initiateLocations];
    [self configureMapView];
    
    //Track position
    [self monitorUsersPosition];
    

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self._gameMap=nil;
    self._gameView=nil;
    self.menuButton=nil;


}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Locations to play in the map
-(void)initiateLocations{
    playLocations = _gameMap._playableLocations;
    for (NSString* location in playLocations){
        //NSLog(@"Locaodnsdf: %@", location);
        if (![location isEqualToString:@"Center"]){
            NSDictionary *point =[playLocations objectForKey:location];
            CLLocationCoordinate2D koor = CLLocationCoordinate2DMake([[point objectForKey:@"Latitude"] doubleValue],[[point objectForKey:@"Longitude"] doubleValue]);
            //NSLog(@"Positionng: %f", [[point objectForKey:@"Latitude"] doubleValue]);
            //CGPoint loc1 = [MapView convertCoordinate:koor toPointToView:self.MapView];
            MKPointAnnotation *anot1 = [[MKPointAnnotation alloc] init];
            [anot1 setCoordinate:koor];
            [anot1 setTitle:location];
            [_gameView addAnnotation:anot1];
        }

    }

}

//Set the center and other properties for the map
-(void)configureMapView{
    // The center of the map at the begining: IIT
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [[[_gameMap._playableLocations objectForKey:@"Center"] objectForKey:@"Latitude"] doubleValue];
    zoomLocation.longitude= [[[_gameMap._playableLocations objectForKey:@"Center"] objectForKey:@"Longitude"] doubleValue];
    //NSLog(@"Map dict: %@", _gameMap);
    //NSLog(@"Center: %f", zoomLocation.latitude);
    
    // The region around the point
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2*METERS_PER_MILE, 2*METERS_PER_MILE);
    
    // Set the mapView
    [_gameView setRegion:viewRegion animated:YES];
    _gameView.showsUserLocation = YES;
    [_gameView regionThatFits:viewRegion];
    [_gameView setDelegate:self];
    [_gameView setScrollEnabled:YES];

    [self.view addSubview:_gameView];
}

//Go to challenge
-(void)startAChallenge: (NSString *) location{
    //Get challenge
    
    //Segue for Challenge view
    ChallengeViewController *myController =[self.storyboard instantiateViewControllerWithIdentifier:@"Challenge"];
    //ChallengeViewController *myController =[[ChallengeViewController alloc] initWithNibName:@"MainWindow" bundle:nil];
    myController._locChallenge=[[_gameMap._playableLocations objectForKey:location] objectForKey:@"Challenge"];
    myController._game = [GameMap startANewGame:*(_gameMap._entity)];
    [myController._game initWithAnotherMap:_gameMap];
    NSLog (@"Game main map for challenge(mapView): %@",myController._game);

    myController._locationID=location;
    [myController setTitle:@"Challenge"];
    [myController awakeFromNib];
    [self.navigationController pushViewController:myController animated:YES];
    //[self performSegueWithIdentifier:@"startChallenge" sender:self];
}

//Monitor users position
-(void) monitorUsersPosition{
    //Initiate manager
    if (nil == locationManager){
        locationManager = [[CLLocationManager alloc] init];
    }
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    
    // Set a movement threshold for new events.
    locationManager.distanceFilter = 50; // meters
    
    //Initiate locations
    currentLocation = [[CLLocation alloc] init];
    oldLocation = [[CLLocation alloc] init];

    //Location updates
    [locationManager startUpdatingLocation];
    /*if ([locationManager regionMonitoringAvailable]){
        
    }*/

}



//Detect change in location

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"**********didUpdateLocations");
    currentLocation = [locations objectAtIndex:0];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (!(error))
         {
             CLPlacemark *placemark = [placemarks objectAtIndex:0];
             NSLog(@"\nCurrent Location Detected\n");
             NSLog(@"placemark %@",placemark);
             // NSString *locatedAt = [[placemark.addressDictionary valueForKey:@"FormattedAddressLines"] componentsJoinedByString:@", "];
             // NSString *Address = [[NSString alloc]initWithString:locatedAt];
             NSString *Area = [[NSString alloc]initWithString:placemark.locality];
             NSString *Country = [[NSString alloc]initWithString:placemark.country];
             NSString *CountryArea = [NSString stringWithFormat:@"%@, %@", Area,Country];
             NSLog(@"%@",CountryArea);
             
         }
         else
         {
             NSLog(@"Geocode failed with error %@", error);
             NSLog(@"\nCurrent Location Not Detected\n");
             //return;
             //CountryArea = NULL;
         }
         
     }];
    for (NSString* loc in playLocations) {
        if (![loc isEqualToString:@"Center"]){
            NSDictionary *point =[playLocations objectForKey:loc];
            CLLocation *playLoc = [[CLLocation alloc] initWithLatitude:[[point objectForKey:@"Latitude"] doubleValue] longitude:[[point objectForKey:@"Longitude"] doubleValue]];
            if ([currentLocation distanceFromLocation:playLoc]<50){
                [self startAChallenge:loc];
                NSLog(@"Challenge Time!");
            }
        }

        
    }
}


//Detect when entering a region
-(void) locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sende{
    if ([[segue identifier] isEqualToString:@"Game Menu"]){
        // Get reference to the destination view controller
        MenuGameViewController *vc = [segue destinationViewController];
        vc._map = [GameMap startANewGame:*(_gameMap._entity)];
        [vc._map initWithAnotherMap:_gameMap];
        [vc setTitle:@"Menu"];
    }

}




@end
