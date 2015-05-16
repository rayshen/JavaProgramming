//
//  DownloadViewController.h
//  Java Programming
//
//  Created by way on 14-7-3.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import "DownloadViewController.h"
#define kURL @"http://b.hiphotos.baidu.com/image/pic/item/32fa828ba61ea8d37ccb6e0e950a304e241f58ca.jpg"
@interface DownloadViewController ()

@property UIImageView *imageView;

@end

UIActivityIndicatorView* activityIndicatorView;

@implementation DownloadViewController

-(void)downloadImage:(NSString *) url{
    NSData *data = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    UIImage *image = [[UIImage alloc]initWithData:data];
    if(image == nil){
        NSLog(@"没有图片");
    }else{
        NSLog(@"刷新图片");
        [  activityIndicatorView stopAnimating ];//停止
        //通知主线程做事
        [self performSelectorOnMainThread:@selector(updateUI:) withObject:image waitUntilDone:NO];
        //如果waitUntilDone参数为YES，那么当前线程会被阻拦，直到selector运行完。
    }
}

-(void)updateUI:(UIImage*) image{
    self.imageView.image = image;
    //sleep(5);
}


-(void)showindicatior{
    activityIndicatorView = [ [ UIActivityIndicatorView  alloc ] initWithFrame:CGRectMake(250,30,30.0,30.0)];
    activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];//启动

}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.imageView=[[UIImageView alloc] initWithFrame:CGRectMake(10, 60, 300, 220)];
    
    [self.view addSubview:self.imageView];
    
    //显示菊花
    [self showindicatior];
    
    //开辟一个新的线程 2种方法
    [NSThread detachNewThreadSelector:@selector(downloadImage:) toTarget:self withObject:kURL];
    //NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(downloadImage:) object:kURL];
    //[thread start];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
