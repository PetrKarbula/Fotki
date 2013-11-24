#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSArray *fotkis;
}

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) IBOutlet UIProgressView *progress;
@property(nonatomic, strong) IBOutlet UIImage *shitImage;
@property(nonatomic, strong) IBOutlet UIImageView *shitImageView;




- (void) postWithParameters :(NSString*) parameters;
- (void) downloadAndSaveImg;

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
