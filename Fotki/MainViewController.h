#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{
    NSArray *fotkis;
}

@property(nonatomic, strong) IBOutlet UIProgressView *progress;

- (void) postWithParameters :(NSString*) parameters;
- (void) downloadAndSaveImg;

@end
