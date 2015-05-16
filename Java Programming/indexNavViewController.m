//
//  indexNavViewController.m
//  Java Programming
//
//  Created by rayshen on 4/15/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "indexNavViewController.h"

@interface indexNavViewController ()

@end

@implementation indexNavViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //导航条的设置  (X坐标,Y坐标,长,宽)
    [[UINavigationBar appearance] setBackgroundColor:[UIColor grayColor]];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
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
