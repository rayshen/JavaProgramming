//
//  RankViewController.m
//  Java Programming
//
//  Created by way on 14-7-18.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import "RankViewController.h"

@interface RankViewController ()

@end

NSMutableArray *irank;

@implementation RankViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    irank=[PersonConnection getCredit:[Personinfo getid]];
    Person *me=[irank objectAtIndex:0];
    NSLog(@"我=》ID：%i,邮箱：%@,名字：%@,性别：%@,电话：%@,积分：%i",me->iuserid,me->imailbox,me->iname,me->isex,me->iphonenum,me->icredit);
    //界面显示，自己积分信息
    //前5名信息
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
