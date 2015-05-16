//
//  FileDB.h
//  Java Programming
//
//  Created by way on 14-7-3.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileConnection : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property NSMutableData *receiveData;

-(void)yibu;

@end
