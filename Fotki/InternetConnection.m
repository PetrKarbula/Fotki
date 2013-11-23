//
//  InternetConnection.m
//  Fotki
//
//  Created by maly Kuba on 23/11/13.
//  Copyright (c) 2013 Craneballs_Barcelona. All rights reserved.
//

#import "InternetConnection.h"
#import "FotkiBuilder.h"
#import "FotkiData.h"


@implementation InternetConnection

- (id) init
{
    if (self = [super init])
    {
        fotkis = [[NSArray alloc] init];
    }
    
    return self;
}

- (void) postWithParameters :(NSString*) parameters
{
    
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
    }
}

@end
