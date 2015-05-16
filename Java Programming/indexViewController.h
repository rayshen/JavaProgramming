//
//  indexViewController.h
//  Java Programming
//
//  Created by rayshen on 4/14/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyinfoViewController.h"
#import "ContentViewController.h"
#import "MycollectionViewController.h"
#import "WrongprosbookViewController.h"
#import "MytestresultsViewController.h"
#import "HostViewController.h"
#import "ICSDrawerController.h"
#import "ICSColorsViewController.h"
#import "DownloadViewController.h"
#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

//#import "TestnaviViewController.h"
@interface indexViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *CollectionView;

- (IBAction)showLeftMenuPressed:(id)sender;

@end
@interface QRViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UIGestureRecognizerDelegate>
@end

#define indexItemNum 6;

//index页面各item的名字
NSString *indexItem[6] ={
    @"我的信息",
    @"随机刷题",
    @"错题本",
    @"收藏夹",
    @"成绩曲线",
    @"PPT下载",
};