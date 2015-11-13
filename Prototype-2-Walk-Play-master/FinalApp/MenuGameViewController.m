//
//  MenuGameViewController.m
//  FinalApp
//
//  Created by CatMac on 5/4/14.
//
//

#import "MenuGameViewController.h"

@interface MenuGameViewController (){
    NSString *_appFile;
}

@end


@implementation MenuGameViewController

@synthesize _menuGameTable;
@synthesize _map;

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
    
    //Delegate
    _menuGameTable.delegate = self;
    _menuGameTable.dataSource = self;

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self._menuGameTable=nil;
    self._map = nil;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"MenuGameCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UIButton * button = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [button setEnabled:YES]; // disables
    [button setFrame:CGRectMake(20, 300, 100, 30)];
    
    
    // Configure the cell
    switch (indexPath.row){
        case 0:
            [button setTitle:@"Quit" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(exitGame:) forControlEvents:UIControlEventTouchUpInside];// sets text
            cell.textLabel.text = @"Quit";
            break;
        case 1:
            [button setTitle:@"See" forState:UIControlStateNormal]; // sets text
            cell.textLabel.text = @"Score";
            break;
            
    }
    cell.accessoryView = button;
    return cell;
    
}

-(IBAction)exitGame: (id) sender{
    [self performSegueWithIdentifier:@"exitGame" sender:self];
}

//Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //If pressing QUIT: Save and go to menu
    if ([[segue identifier] isEqualToString:@"exitGame"]){
        // Get reference to the destination view controller
        InitMenuController *vc = [segue destinationViewController];
        NSLog(@"Mensaje de Exit");
        
        //Save the context
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        _appFile = [documentsDirectory stringByAppendingPathComponent:@"set.txt"];
        
        //Save in file
        //NSMutableArray *myObject=[NSMutableArray array];
        NSCoder *mapEncoder;
        NSCoder *idEncoder;
        int entity;
        entity = [_map encodeWithCoder:mapEncoder];
        
        //Pass parameters to initMenu
        vc._gameToSave = idEncoder;
        vc._entityToSave = entity;
        
        //And to parse
        [self saveMapToParse];
       
        
        
    }
    
    
}

//Save to parse
-(void) saveMapToParse{
    //Save Parse object
    PFObject *gameParameters =[PFObject objectWithClassName:@"Game"];
    //NSCoder *encoder =[[NSCoder alloc] init];
    //[_map encodeWithCoder:encoder];
    //NSLog(@"%@", encoder);
    //gameParameters[@"parameters"]=[NSString stringWithFormat:@"%@", encoder] ;

    gameParameters[@"entity"] = [NSString stringWithFormat:@"%d", _map._entity];
    gameParameters[@"score"] = [NSString stringWithFormat:@"%d", _map._score];
    gameParameters[@"level"] = [NSString stringWithFormat:@"%@", [_map._currentLevel objectAtIndex:0]];
    NSArray *keys = [_map._playableLocations allKeys];
    int i = 0;
    for (NSString* value in keys){
        NSString *category = [NSString stringWithFormat:@"%@%d", @"play", i];
        gameParameters [category] = value;
        NSLog(@"%@  %d", category, i);
        i++;
    }


    
    //Save the parse object
    //NSLog(@"Game id: %@",[gameParameters objectId]);

    [gameParameters saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error){
           
        }
        else{
            NSLog (@"Error: %@", error);
        }
    }];
    
    //Make a fi
    
    while (![gameParameters objectId]){
        NSLog(@"... Waiting for Parse.com ");
        
    }
    //Link it to the current user
    PFUser *user = [PFUser currentUser];
    PFRelation *relation = [user relationforKey:@"maps"];
    //[relation addObject:gameParameters];
    [user saveEventually];
    

}

+(void)addArrayToPFObject: (PFObject *) pf :(NSDictionary *) array and :(NSString *) param{

    
}


@end
