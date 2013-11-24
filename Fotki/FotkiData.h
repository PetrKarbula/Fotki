//
//  FotkiData.h
//  Fotki
//
//  Created by maly Kuba on 23/11/13.
//  Copyright (c) 2013 Craneballs_Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FotkiData : NSObject
{
    
}

@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *lat;
@property (strong, nonatomic) NSString *lon;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) UIImage  *image;
@property (nonatomic, assign) BOOL  downloaded;


@end
