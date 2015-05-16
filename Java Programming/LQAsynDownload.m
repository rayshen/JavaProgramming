//
//  LQAsynDownload.m
//  lgTest
//
//  Created by yons on 14-2-14.
//  Copyright (c) 2014年 GQ. All rights reserved.
//

#import "LQAsynDownload.h"

@interface LQAsynDownload()

@property (assign) long long contentLength;

@property (assign) long long receiveLength;

@property (strong) NSMutableData *receiveData;

@property (strong) NSString *fileName;

@property (strong) NSURLConnection *theConnection;

@property (strong) NSURLRequest *theRequest;

@end

@implementation LQAsynDownload

@synthesize receiveData = _receiveData, fileName = _fileName,
theConnection=_theConnection, theRequest=_theRequest;

+ (LQAsynDownload *) initWithURL:(NSURL *) url{
    LQAsynDownload *asynDownload = [[LQAsynDownload alloc] init];
    asynDownload.theRequest=[NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:60.0];
    // create the connection with the request
    // and start loading the data
    return asynDownload;
}

- (void) startAsyn{
    _contentLength=0;
    _receiveLength=0;
    self.receiveData = [[NSMutableData alloc] init];
    self.theConnection = [[NSURLConnection alloc] initWithRequest:self.theRequest delegate:self];
}

//接收到http响应
- (void) connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    _contentLength = [response expectedContentLength];
    _fileName = [response suggestedFilename];
    if (self.initProgress != nil) {
        self.initProgress(_contentLength);
    }
    NSLog(@"data length is %lli", _contentLength);
}

//传输数据
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    _receiveLength += data.length;
    [_receiveData appendData:data];
    if (self.loadedData != nil) {
        self.loadedData(data.length);
    }
    //NSLog(@"data recvive is %lli", _receiveLength);
}

//错误
- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [self releaseObjs];
    NSLog(@"%@",error.description);
}

- (void) releaseObjs{
    self.receiveData = nil;
    self.fileName = nil;
    self.theRequest = nil;
    self.theConnection = nil;
}

//成功下载完毕
- (void) connectionDidFinishLoading:(NSURLConnection *)connection{
    //数据写入doument
    //获取完整目录名字
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *savePath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,_fileName];
    NSLog(@"%@",savePath);
    //创建文件
    [_receiveData writeToFile:savePath atomically:YES];
    [self releaseObjs];
}


@end