//
//  FotkiBuilder.m
//  Fotki
//
//  Created by maly Kuba on 23/11/13.
//  Copyright (c) 2013 Craneballs_Barcelona. All rights reserved.
//

#import "FotkiBuilder.h"
#import "FotkiData.h"

@implementation FotkiBuilder

+ (NSArray *)fotkiDataFromJSON:(NSData *)objectNotation error:(NSError **)error
{
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:objectNotation options:0 error:&localError];
    
    if (localError != nil) {
        *error = localError;
        return nil;
    }
    
    NSMutableArray *fotkis = [[NSMutableArray alloc] init];
    
    NSArray *results = [parsedObject valueForKey:@"fotki"];
    NSLog(@"Count %d", (int)results.count);
    
    for (NSDictionary *groupDic in results) {
        FotkiData *fotkiData = [[FotkiData alloc] init];
        
        for (NSString *key in groupDic) {
            if ([fotkiData respondsToSelector:NSSelectorFromString(key)]) {
                [fotkiData setValue:[groupDic valueForKey:key] forKey:key];
            }
        }
        
        [fotkis addObject:fotkiData];
    }
    
    return fotkis;
}

@end
