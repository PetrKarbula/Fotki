#import "MainViewController.h"
#import "SWRevealViewController.h"
#import "AppDelegate.h"

#import "FotkiData.h"
#import "FotkiBuilder.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = (AppDelegate*)
    [[UIApplication sharedApplication] delegate];
    
    delegate.mainView = self;
    
    self.title = @"News";
    
    fotkis = [[NSArray alloc] init];
    
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.96f alpha:0.2f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.progress.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Internet Connection

- (void) postWithParameters :(NSString*) parameters
{
    self.progress.hidden = NO;
    NSString *post = parameters;//[NSString stringWithFormat:@"bla bla bla %i",1];
    //NSLog(@"%@", post);
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
             //NSString* answer = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
             
             NSError *error = nil;
             fotkis = [FotkiBuilder fotkiDataFromJSON:data error:&error];
             
             //
             //[answer release];
             
             [self downloadAndSaveImg];
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
    for (FotkiData *data in fotkis)
    {
        NSLog(@"Downloading...");
        // Get an image from the URL below
        UIImage *image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:data.url]]];
        
        NSLog(@"%f,%f",image.size.width,image.size.height);
        
        // UKLADANI
        
        // Let's save the file into Document folder.
        // You can also change this to your desktop for testing. (e.g. /Users/kiichi/Desktop/)
        // NSString *deskTopDir = @"/Users/kiichi/Desktop";
        
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        // If you go to the folder below, you will find those pictures
        NSLog(@"%@",docDir);
        
        NSLog(@"saving jpeg");
        NSString *jpegFilePath = [NSString stringWithFormat:@"%@/%@.jpeg", docDir, data.id];
        NSData *data2 = [NSData dataWithData:UIImageJPEGRepresentation(image, 1.0f)];//1.0f = 100% quality
        [data2 writeToFile:jpegFilePath atomically:YES];
        
        NSLog(@"saving image done");
        self.progress.hidden = YES;
    }
}

@end
