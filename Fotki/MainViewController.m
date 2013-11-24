#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

#import "FotkiData.h"
#import "FotkiBuilder.h"

#import "CustomGalleryCell.h"
#import "UIImageView+WebCache.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) UIImageView* backgroundView;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = (AppDelegate*)
    [[UIApplication sharedApplication] delegate];
    
    delegate.mainView = self;
    
    [self setupCollectionView];
        
    fotkis = [[NSMutableArray alloc] init];
    currectSearch = [[NSString alloc] init];
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.5f alpha:1.0f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.progress.hidden = YES;
    self.collectionView.hidden = YES;
    

    [self.revealViewController revealToggleAnimated:YES];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:[[UIColor alloc] initWithRed: 219 / 255.f green: 219 / 255.f blue: 219 / 255.f alpha:1.f]];

    
    countryParts = [[NSMutableArray alloc] init];
    
    [countryParts addObject: _sidebarButton];
    
    UIImage *originalImage = [UIImage imageNamed:@"Logo_lista.png"];
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[originalImage CGImage]
                        scale:(originalImage.scale * 2.0)
                  orientation:(originalImage.imageOrientation)];
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:[[UIImageView alloc] initWithImage:scaledImage]];
    
    _navItem.rightBarButtonItem = item;

    self.collectionView.delegate = self;
    
    UIImage *fake = [UIImage imageNamed:@"fotki_ipad_mapa.png"];

    
    fakemap = [[UIImageView alloc] initWithImage:fake];
    
    // Swipe Left
    UISwipeGestureRecognizer * Swipeup=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeup:)];
    Swipeup.direction=UISwipeGestureRecognizerDirectionUp;
    [self.view addGestureRecognizer:Swipeup];
    
    
    // SwipeRight
    UISwipeGestureRecognizer * Swipedown=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipedown:)];
    Swipedown.direction=UISwipeGestureRecognizerDirectionDown;
    [self.view addGestureRecognizer:Swipedown];
    [fakemap setFrame:CGRectMake( 0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)]; //notice this is OFF screen!
   
        [self.view addSubview:fakemap];
}


-(void)swipeup:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(state == 1)
        return;
    [fakemap setFrame:CGRectMake( 0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    [fakemap setFrame:CGRectMake( 0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)]; //notice this is ON screen!
    [UIView commitAnimations];
    state = 1;
    //Do what you want here

}

-(void)swipedown:(UISwipeGestureRecognizer*)gestureRecognizer
{
    if(state == 0)
        return;
    [fakemap setFrame:CGRectMake( 0.0f, 0, self.view.frame.size.width, self.view.frame.size.height)]; //notice this is OFF screen!
    [UIView beginAnimations:@"animateTableView" context:nil];
    [UIView setAnimationDuration:0.2];
    [fakemap setFrame:CGRectMake( 0.0f, self.view.frame.size.height, self.view.frame.size.width, self.view.frame.size.height)]; //notice this is ON screen!
    [UIView commitAnimations];
    state = 0;
    //Do what you want here
    //[fakemap removeFromSuperview];
    
}

-(void)setupCollectionView {
    [self.collectionView registerClass:[CustomGalleryCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:0.0f];
    [flowLayout setMinimumLineSpacing:0.0f];

    [self.collectionView setPagingEnabled:YES];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    UIImage *backgroundImage = [[UIImage alloc]init];
    backgroundImage = [UIImage imageNamed:@"backdrop.png"];
    
    self.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    [self.backgroundView setFrame:CGRectMake(0, 0,[backgroundImage size].width, [backgroundImage size].height)];
    [self.view addSubview:self.backgroundView];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.collectionView.frame.size;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)likeClicked:(id)sender
{
    int photo_id;
    for (UICollectionViewCell *cell in [self.collectionView visibleCells])
    {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
        FotkiData *f =  [fotkis objectAtIndex:[indexPath indexAtPosition:1]];
        photo_id = [f.photo_id intValue];
    }
    [self photoAction:[NSString stringWithFormat:@"action=like&photo_id=%i",photo_id]];
}
#pragma mark Internet Connection


- (void) photoAction :(NSString*) params
{

    NSString *post = params;//[NSString stringWithFormat:@"%@&set=%i",parameters,set];
    NSLog(@"%@", post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    [req setURL:[NSURL URLWithString:@"http://division.craneballs.com/fotki/photo_action.php"]];
    [req setHTTPMethod:@"POST"];
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil)
         {
             NSString* answer = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             NSLog(@"Server Answer: %@",answer);
         }
         else if ([data length] == 0 && error == nil)
         {
             
             
         }
         else if (error != nil)
         {
             NSLog(@"%@",error.description);
             
         }
         
     }];
    
    
}


- (void) postWithParameters :(NSString*) parameters removePictures:(BOOL)remove
{
    if(remove)
    {
        
        [fotkis removeAllObjects];
        [self.collectionView reloadData];
    }
    spinner = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5f, self.view.bounds.size.height * 0.5f, 0, 0)];
    spinner.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    [spinner startAnimating];
   
    [self.view addSubview:spinner];
    currectSearch = parameters;
    downloadInProgress = YES;
    //self.progress.hidden = NO;
    NSString *post = [NSString stringWithFormat:@"%@&set=%i",parameters,set];
    NSLog(@"%@", post);
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] init];
    [req setURL:[NSURL URLWithString:@"http://division.craneballs.com/fotki/index.php"]];
    [req setHTTPMethod:@"POST"];
    [req setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [req setValue:@"application/x-www-form-urlencoded"forHTTPHeaderField:@"Content-Type"];
    [req setHTTPBody:postData];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         if ([data length] > 0 && error == nil)
         {             
             NSError *error = nil;

             [fotkis addObjectsFromArray:[FotkiBuilder fotkiDataFromJSON:data error:&error]];
             [self downloadAndSaveImg];
             downloadInProgress = NO;
         }
         else if ([data length] == 0 && error == nil)
         {
             
             
         }
         else if (error != nil)
         {
             NSLog(@"%@",error.description);
             
         }
         
     }];
    
    
}

- (void) downloadAndSaveImg
{
    for (FotkiData *dataFotki in fotkis) //FotkiData *data in fotkis
    {
        if(dataFotki.downloaded)
            continue;
        //FotkiData *data = [fotkis objectAtIndex:i];
        NSLog(@"Downloading...");
        // Get an image from the URL below
        //UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:data.url]]];
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadWithURL:[NSURL URLWithString:dataFotki.url]
                         options:0
                        progress:^(NSUInteger receivedSize, long long expectedSize)
         {
             // progression tracking code
         }
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (image)
             {
                 NSLog(@"%f,%f",image.size.width,image.size.height);
                 dataFotki.image = image;
                 // do something with image
                 
                 // UKLADANI
                 
                 // Let's save the file into Document folder.
                 // You can also change this to your desktop for testing. (e.g. /Users/kiichi/Desktop/)
                 // NSString *deskTopDir = @"/Users/kiichi/Desktop";
                 
                 NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                 
                 // If you go to the folder below, you will find those pictures
                 NSLog(@"%@",docDir);
                 
                 NSLog(@"saving jpeg");
                 //NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@.jpeg", docDir, dataFotki.id];
                 //NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
                 //[data2 writeToFile:jpegFilePath atomically:YES];
                 
                 NSLog(@"saving image done");
                 self.progress.hidden = YES;
                 self.collectionView.hidden = NO;
                 [spinner removeFromSuperview];
                 [self.backgroundView removeFromSuperview];
                 [self.collectionView reloadData];
             }
         }];
        
        
        
        
        
        

    }
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [fotkis count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CustomGalleryCell *cell = (CustomGalleryCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    FotkiData *data = [fotkis objectAtIndex:indexPath.row];
    [cell setImage:data.image];
    
    [cell updateCell];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (UICollectionViewCell *cell in [self.collectionView visibleCells]) {
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        NSLog(@"%@ z %i",indexPath,[fotkis count]);
        if([indexPath indexAtPosition:1] >= ([fotkis count]-1))//(int)([fotkis count]/2))
        {
            if(!downloadInProgress) {
                set++;
                [self postWithParameters:currectSearch removePictures:YES];
            }
        }
        
        if([indexPath indexAtPosition:1] > 6)
        {
            //[fotkis removeObjectAtIndex:0];
            //[self.collectionView reloadData];
        }
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:
(NSTimeInterval)duration {
    
    // Fade the collectionView out
    [self.collectionView setAlpha:0.0f];
    
    // Suppress the layout errors by invalidating the layout
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    // Calculate the index of the item that the collectionView is currently displaying
    CGPoint currentOffset = [self.collectionView contentOffset];
    self.currentIndex = currentOffset.x / self.collectionView.frame.size.width;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    // Force realignment of cell being displayed
    CGSize currentSize = self.collectionView.bounds.size;
    float offset = self.currentIndex * currentSize.width;
    [self.collectionView setContentOffset:CGPointMake(offset, 0)];
    
    // Fade the collectionView back in
    [UIView animateWithDuration:0.125f animations:^{
        [self.collectionView setAlpha:1.0f];
    }];
    
}

- (void) addButtonToCountryParts:(NSString *)btnName
{
    UIBarButtonItem *tmpBtn = [[UIBarButtonItem alloc] initWithTitle:btnName
                                                                     style:UIBarButtonItemStyleDone target:nil action:nil];
    
    tmpBtn.tintColor =[[UIColor alloc] initWithRed: 0 green: 0 blue: 0 alpha:1.f];
    
    [countryParts addObject:tmpBtn];
    
    // pridani pomlcky do predchozi cesty
    int count = [countryParts count];
    
    
    
    if (count > 2)
    {
        NSString *tmp = [[NSString alloc] init];
        tmp = [(UIBarButtonItem*)[countryParts objectAtIndex:[countryParts count] - 2] title];
        tmp = [tmp stringByAppendingString:@"  -> "];
        
        [(UIBarButtonItem*)[countryParts objectAtIndex:[countryParts count] - 2] setTitle: tmp];
    }
    
    _navItem.leftBarButtonItems = (NSArray*)countryParts;
}

- (void) removeLastBtnFromCountryParts
{
    if ([countryParts count] > 0)
    {
        [countryParts removeLastObject];
        
        _navItem.leftBarButtonItems = (NSArray*)countryParts;
    }
}

- (void) removeAllFromCountryParts
{
    [countryParts removeAllObjects];
    
    [countryParts addObject:_sidebarButton];
    
    _navItem.leftBarButtonItems = (NSArray*)countryParts;
}

@end
