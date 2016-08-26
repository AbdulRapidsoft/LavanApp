//
//  ImageDownloader.m
//  ClassicPhotos
//
//  Created by Soheil M. Azarpour on 8/11/12.
//  Copyright (c) 2012 iOS Developer. All rights reserved.
//

#import "ImageDownloader.h"


// 1: Declare a private interface, so you can change the attributes of instance variables to read-write.
@interface ImageDownloader ()

@property (nonatomic, readwrite, strong) NSURL * url;
@property (nonatomic, readwrite, strong) id info;
@property (nonatomic, readwrite, strong) UIImage * image;

@end

@implementation ImageDownloader

@synthesize delegate = _delegate;
@synthesize url = _url;
@synthesize info = _info;
@synthesize image = _image;

#pragma mark -
#pragma mark - Life Cycle

- (id)initWithInfo:(id)info url:(NSURL *)url delegate:(id<ImageDownloaderDelegate>) theDelegate
{
    if (self = [super init])
    {
        // 2: Set the properties.
        self.delegate = theDelegate;
        self.url = url;
        self.info = info;
    }
    return self;
}

#pragma mark -
#pragma mark - Downloading image

// 3: Regularly check for isCancelled, to make sure the operation terminates as soon as possible.
- (void)main
{
    // 4: Apple recommends using @autoreleasepool block instead of alloc and init NSAutoreleasePool, because blocks are more efficient. You might use NSAuoreleasePool instead and that would be fine.
    @autoreleasepool {
        
        if (self.isCancelled)
            return;
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:30.0];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        //[request setValue:@"VHlwZSAob3IgcGFzdGUpIGhlcmUuLi4=" forHTTPHeaderField:@"Authorization"];
        //[request setValue:@"application/json" forHTTPHeaderField:@"Accept"];

        NSURLResponse * response = [[NSURLResponse alloc] init];
        NSError * error = nil;
        NSData * imageData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (self.isCancelled)
        {
            imageData = nil;
            return;
        }
        
        if (imageData && !error)
        {
            UIImage * downloadedImage = [UIImage imageWithData:imageData];
            self.image = downloadedImage;
        }
        else
        {
            self.image = nil;
        }
        imageData = nil;
        
        if (self.isCancelled)
            return;
        
        // 5: Cast the operation to NSObject, and notify the caller on the main thread.
        [(NSObject *)self.delegate performSelectorOnMainThread:@selector(imageDownloaderDidFinish:) withObject:self waitUntilDone:NO];
    }
}

@end


