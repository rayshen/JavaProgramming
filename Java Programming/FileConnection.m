//
//  FileDB.m
//  Java Programming
//
//  Created by way on 14-7-3.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import "FileConnection.h"

NSMutableData *connectionData;

@implementation FileConnection


#pragma mark - View lifecycle

-(void)tongbu{
    NSLog(@"同步");
    NSError *err;
    //定义url
    NSString *url=@"http://172.22.65.38/new/1.doc";
    //构建NSURL
    NSURL *fileUrl=[NSURL URLWithString:url];
    //构建nsurlrequest
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:fileUrl];
    //建立连接
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    if (data.length>0) {
        NSString *savePath=[[NSHomeDirectory()stringByAppendingPathComponent:@"documents"]stringByAppendingPathComponent:@"filetest.doc"];
        //当数据写入的时候
        if ([data writeToFile:savePath atomically:YES]) {
            NSLog(@"保存成功");
        }else{
            NSLog(@"保存失败");
        }
    }
    
    
}

-(void)yibu{
    NSLog(@"异步");
    NSError *err;
    //定义url
    NSString *url=@"http://www.iyi8.com/uploadfile/2013/1218/20131218115919791.jpg";
    //构建NSURL
    NSURL *fileUrl=[NSURL URLWithString:url];
    //构建nsurlrequest
    NSURLRequest *request=[[NSURLRequest alloc]initWithURL:fileUrl];
    //建立连接
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];
    
    NSURLConnection *conn=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    
    //初始化connectionData;
    connectionData=[[NSMutableData alloc]init ];
}


 //接受数据
 -(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
 //获取服务器传递的数据
     NSLog(@"正在下载");
     [connectionData appendData:data];
 }
 //接收数据成功
 -(void)connectionDidFinishLoading:(NSURLConnection *)connection{
     if (connectionData.length>0) {
         NSString *savePath=[[NSHomeDirectory()stringByAppendingPathComponent:@"documents"] stringByAppendingPathComponent:@"tangwei.jpg"];
         NSLog(@"%@",savePath);
         //当数据写入的时候
         if ([connectionData writeToFile:savePath atomically:YES]) {
             NSLog(@"保存成功");
         }else{
             NSLog(@"保存失败");
         }
     }
 }
 //接收数据失败
 -(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{}



/*
-(void)yibupost{
    //第一步，创建url
 
    NSURL *url = [NSURL URLWithString:@"http://api.hudong.com/iphonexml.do"];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    NSString *str = @"type=focus-c";
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:data];
    
    //第三步，连接服务器
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];

}
//接收到服务器回应的时候调用此方法

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response

{
    
    NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
    
    NSLog(@"%@",[res allHeaderFields]);
    
    self.receiveData = [NSMutableData data];

    
}

//接收到服务器传输数据的时候调用，此方法根据数据大小执行若干次

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data

{
    
    [self.receiveData appendData:data];
    
}

//数据传完之后调用此方法

-(void)connectionDidFinishLoading:(NSURLConnection *)connection

{
    
    NSString *receiveStr = [[NSString alloc]initWithData:self.receiveData encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",receiveStr);
    
}

//网络请求过程中，出现任何错误（断网，连接超时等）会进入此方法

-(void)connection:(NSURLConnection *)connection

 didFailWithError:(NSError *)error

{
    
    NSLog(@"%@",[error localizedDescription]);
}
*/
@end
