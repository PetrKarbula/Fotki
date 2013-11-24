//
//  CustomGalleryCell.h
//  Fotki
//
//  Created by Marek on 24.11.13.
//  Copyright (c) 2013 Craneballs_Barcelona. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomGalleryCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

-(void)updateCell;

@end
