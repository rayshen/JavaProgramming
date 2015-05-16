//
//  LQAsynDownload.h
//  lgTest
//
//  Created by yons on 14-2-14.
//  Copyright (c) 2014年 GQ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^initProgress)(long long initValue);

typedef void (^loadedData)(long long loadedLength);

@interface LQAsynDownload : NSObject<NSURLConnectionDataDelegate>

@property (strong) NSURL *httpURL;

@property (copy) void (^initProgress)(long long initValue);

@property (copy) void (^loadedData)(long long loadedLength);

+ (LQAsynDownload *) initWithURL:(NSURL *) url;

- (void) startAsyn;

@end