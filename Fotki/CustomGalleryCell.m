//
//  CustomGalleryCell.m
//  Fotki
//
//  Created by Marek on 24.11.13.
//  Copyright (c) 2013 Craneballs_Barcelona. All rights reserved.
//

#import "CustomGalleryCell.h"

@interface CustomGalleryCell()
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation CustomGalleryCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CustomGalleryCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    
    return self;
}

-(void)updateCell {
    [self.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [self.imageView setImage:self.image];
}

@end
