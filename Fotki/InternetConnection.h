//
//  InternetConnection.h
//  Fotki
//
//  Created by maly Kuba on 23/11/13.
//  Copyright (c) 2013 Craneballs_Barcelona. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InternetConnection : NSObject
{
    NSArray *fotkis;
}

- (void) postWithParameters :(NSString*) parameters;
- (void) downloadAndSaveImg;

@end
