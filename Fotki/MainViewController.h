#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
{
    NSMutableArray *fotkis;
    NSString *currectSearch;
    BOOL downloadInProgress;
    int set;
}

@property(nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property(nonatomic, strong) IBOutlet UIProgressView *progress;
@property(nonatomic, strong) IBOutlet UIButton *btnLike;

@property (nonatomic) int currentIndex;

- (void) postWithParameters :(NSString*) parameters removePictures:(BOOL)remove;
- (void) downloadAndSaveImg;

-(IBAction)likeClicked:(id)sender;

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
