//
//  MyinfoViewController.h
//  Java Programming
//
//  Created by rayshen on 5/12/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Personinfo.h"
#import "Myinfocell.h"
#import "EditinfoViewController.h"
#import "EditSchoolViewController.h"
#import "LocalDataDB.h"
@interface MyinfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *myinfos;
@property (weak, nonatomic) IBOutlet UIImageView *TXimgView;


@end
