#import "SidebarViewController.h"
#import "PhotoViewController.h"
#import "SWRevealViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"

@interface SidebarViewController ()

@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation SidebarViewController
@synthesize searchBar;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AppDelegate *delegate = (AppDelegate*)
    [[UIApplication sharedApplication] delegate];
    
    if(usingDefault)
    {
        if(inSubMenu)
        {
            inSubMenu = NO;
            if(indexPath.row == 0)
            {
                autocompleteSuggestions = [[NSMutableArray alloc] initWithArray:continentsArray copyItems:YES];
                [self.tableView reloadData];
                
                [delegate.mainView removeLastBtnFromCountryParts];
            }
            else
            {
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                searchBar.text = cell.textLabel.text;
                
                [autocompleteSuggestions removeAllObjects];
                [self.tableView reloadData];
                
                [delegate.mainView postWithParameters:[self addressBuilder] removePictures:YES];
                
                [self .revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
                
                
                [delegate.mainView addButtonToCountryParts:cell.textLabel.text];
            }
        }
        else
        {
            [delegate.mainView addButtonToCountryParts:[self.tableView cellForRowAtIndexPath:indexPath].textLabel.text];
            
            //NSLog(@"%i", indexPath.row);
            autocompleteSuggestions = [[NSMutableArray alloc] initWithArray:[countryArray objectAtIndex:indexPath.row] copyItems:YES];
            [self.tableView reloadData];
            inSubMenu = YES;
        }
    }
    else
    {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        searchBar.text = cell.textLabel.text;
        
        [autocompleteSuggestions removeAllObjects];
        [self.tableView reloadData];
        
        
        [delegate.mainView postWithParameters:[self addressBuilder] removePictures:YES];
        
        [self .revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];
    }
}

- (NSString*) addressBuilder
{
    NSArray *parameters = [searchBar.text componentsSeparatedByString:@", "];
    NSString *address = [[NSString alloc] init];
    for(int i = 0; i < parameters.count; i++)
    {
        NSString *param = [NSString stringWithFormat:@"address%i=%@&", i, (NSString*)[parameters objectAtIndex:i]];
        address = [address stringByAppendingString:param];
    }
    
    NSRange stringRange = {0, address.length-1};
    stringRange = [address rangeOfComposedCharacterSequencesForRange:stringRange];
    
    address = [address substringWithRange:stringRange];
    
    return address;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate *delegate = (AppDelegate*)
    [[UIApplication sharedApplication] delegate];
    
    delegate.sideBarView = self;
    
    //self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    //self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:50 / 255.f green:50 / 255.f blue:50 / 255.f alpha:1.f];;
    UIImage *backgroundImage = [[UIImage alloc]init];
    backgroundImage = [UIImage imageNamed:@"pozadi_menu.png"];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:backgroundImage];
    [backgroundImageView setFrame:CGRectMake(self.view.frame.size.width * 0.25 , self.view.frame.size.height * 0.15,[backgroundImage size].width * 0.3 , [backgroundImage size].height * 0.3)];
    [self.view addSubview:backgroundImageView];
    
    autocompleteSuggestions = [[NSMutableArray alloc] init];
    
    continentsArray = [[NSMutableArray alloc] init];
    countryArray = [[NSMutableArray alloc] init];
    
    [self ReadDefaultData];
    [self SetDefaultData];
    //[self.revealViewController setFrontViewPosition: FrontViewPositionRight animated: YES];
    
    
//    [self.tableView beginUpdates];
//        NSIndexPath *path1 = [NSIndexPath indexPathForRow:1 inSection:0]; //ALSO TRIED WITH indexPathRow:0
//        NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
//        [self.tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"%i",autocompleteSuggestions.count);
    return autocompleteSuggestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //NSLog(@"Row: %i", indexPath.row);
    // GUI STYLE
    cell.textLabel.text = [autocompleteSuggestions objectAtIndex:indexPath.row]; //219
    cell.textLabel.textColor = [[UIColor alloc] initWithRed: 219 / 255.f green: 219 / 255.f blue: 219 / 255.f alpha:1.f];
    
    cell.backgroundColor = [[UIColor alloc] initWithRed:50 / 255.f green:50 / 255.f blue:50 / 255.f alpha:0.f];
    
    
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = [UIColor colorWithRed:(39/255.f) green:(39/255.f) blue:(39/255.f) alpha:1.f];
    selectionColor.opaque = true;
    cell.selectedBackgroundView = selectionColor;
    
    return cell;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    //[delegate.mainView postWithParameters:[searchBar text] removePictures:YES];
    
    //[self .revealViewController setFrontViewPosition:FrontViewPositionLeft animated:YES];

    
}
- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // Set the photo if it navigates to the PhotoView
    if ([segue.identifier isEqualToString:@"showPhoto"]) {
        PhotoViewController *photoController = (PhotoViewController*)segue.destinationViewController;
        NSString *photoFilename = [NSString stringWithFormat:@"%@_photo.jpg", [_menuItems objectAtIndex:indexPath.row]];
        photoController.photoFilename = photoFilename;
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
}

#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView:(NSIndexPath *)indexPath {
    searchBar.text = [autocompleteSuggestions objectAtIndex:indexPath.row];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if(searchText.length > 0)
    {
        usingDefault = NO;
        [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        NSURL *url = [NSURL URLWithString:@"https://maps.googleapis.com/maps/api/place/autocomplete/"];
        
        NSDictionary *params = @{@"input" : [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"],
                                 //@"location" : [NSString stringWithFormat:@"%f,%f", searchCoordinate.latitude, searchCoordinate.longitude],
                                 @"sensor" : @"false",
                                 //                           @"language" : @"pt_BR",
                                 //@"types" : @"(cities)",
                                 //@"components" : @"",
                                 @"key" : @"AIzaSyDxGJ0un1MY7TmxzqYujcTcSfQAxrjVKKU"};
        
        AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
        [httpClient setParameterEncoding:AFFormURLParameterEncoding];
        
        [httpClient getPath:@"json"
                 parameters:params
                    success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                        
                        
                        [autocompleteSuggestions removeAllObjects];
                        
                        NSArray* array = [JSON objectForKey:@"predictions"];
                        for(int i = 0; i < [array count]; i++)
                        {
                            [autocompleteSuggestions addObject:[[array objectAtIndex:i] valueForKey:@"description"]]; //componentsSeparatedByString:@","] objectAtIndex:0]];
                            
                            NSLog(@"%@", [autocompleteSuggestions objectAtIndex:i]);
                        }
                        
                        
                        [self.tableView reloadData];
                    }
                    failure:^(AFHTTPRequestOperation *operation, NSError *errorResponse) {
                        NSLog(@"[HTTPClient Error]: %@ for URL %@", [errorResponse localizedDescription], [[[operation request] URL] path]);
                    }];
    }
    else
    {
        [autocompleteSuggestions removeAllObjects];
        [self SetDefaultData];
        [self.tableView reloadData];
    }
}

- (void) SetDefaultData
{
    usingDefault = YES;
    inSubMenu = NO;
    autocompleteSuggestions = [[NSMutableArray alloc] initWithArray:continentsArray copyItems:YES];
}

- (void) ReadDefaultData {
    NSString* continentsPath = [[NSBundle mainBundle] pathForResource:@"Continents" ofType:@""];
    NSString *fileContents = [NSString stringWithContentsOfFile:continentsPath encoding:NSUTF8StringEncoding error:NULL];
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        [continentsArray addObject:line];
    }
    
    NSMutableArray* tmpArray = [[NSMutableArray alloc] init];
    
    continentsPath = [[NSBundle mainBundle] pathForResource:@"Asia" ofType:@""];
    fileContents = [NSString stringWithContentsOfFile:continentsPath encoding:NSUTF8StringEncoding error:NULL];
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        [tmpArray addObject:line];
    }
    
    [countryArray addObject:tmpArray];
//    [tmpArray removeAllObjects];
    tmpArray = [[NSMutableArray alloc] init];
    
    continentsPath = [[NSBundle mainBundle] pathForResource:@"Africa" ofType:@""];
    fileContents = [NSString stringWithContentsOfFile:continentsPath encoding:NSUTF8StringEncoding error:NULL];
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        [tmpArray addObject:line];
    }
    
    [countryArray addObject:tmpArray];
    //[tmpArray removeAllObjects];
    tmpArray = [[NSMutableArray alloc] init];
    
    continentsPath = [[NSBundle mainBundle] pathForResource:@"Europe" ofType:@""];
    fileContents = [NSString stringWithContentsOfFile:continentsPath encoding:NSUTF8StringEncoding error:NULL];
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        [tmpArray addObject:line];
    }
    
    [countryArray addObject:tmpArray];
//    [tmpArray removeAllObjects];
    tmpArray = [[NSMutableArray alloc] init];
    
    continentsPath = [[NSBundle mainBundle] pathForResource:@"North America" ofType:@""];
    fileContents = [NSString stringWithContentsOfFile:continentsPath encoding:NSUTF8StringEncoding error:NULL];
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        [tmpArray addObject:line];
    }
    
    [countryArray addObject:tmpArray];
//    [tmpArray removeAllObjects];
    tmpArray = [[NSMutableArray alloc] init];
    
    continentsPath = [[NSBundle mainBundle] pathForResource:@"Oceania" ofType:@""];
    fileContents = [NSString stringWithContentsOfFile:continentsPath encoding:NSUTF8StringEncoding error:NULL];
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        [tmpArray addObject:line];
    }
    
    [countryArray addObject:tmpArray];
    //[tmpArray removeAllObjects];
    tmpArray = [[NSMutableArray alloc] init];
    
    continentsPath = [[NSBundle mainBundle] pathForResource:@"South America" ofType:@""];
    fileContents = [NSString stringWithContentsOfFile:continentsPath encoding:NSUTF8StringEncoding error:NULL];
    for (NSString *line in [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]]) {
        [tmpArray addObject:line];
    }
    
    [countryArray addObject:tmpArray];
    //[tmpArray removeAllObjects];
    
    
}



@end
