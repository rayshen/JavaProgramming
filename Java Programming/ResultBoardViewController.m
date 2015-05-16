//
//  ResultBoardViewController.m
//  Java Programming
//
//  Created by rayshen on 5/4/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "ResultBoardViewController.h"

@interface ResultBoardViewController (){

    IOSTimeLabel *timedisplay;
}

@end

@implementation ResultBoardViewController


- (void)viewDidLoad
{
    
    self.sumobjlabel.text=[NSString stringWithFormat:@"%d",self.sumObj];
    self.pointslabel.text=[NSString stringWithFormat:@"%d",self.points];
    
    //设置时间
    timedisplay = [[IOSTimeLabel alloc] initWithLabel:self.timelabel];
    [timedisplay setCountDownTime:self.usingtime];
    [timedisplay start];
    [timedisplay pause];
    
    //设置正确率
    float correctPer=(float)self.points/self.sumObj;
    self.CP.text=[NSString stringWithFormat:@"%.1f%%",correctPer*100];

    [self addmenu];
    [super viewDidLoad];
}

-(void)addmenu{
    UILabel *status=[[UILabel alloc]initWithFrame:CGRectMake(0,0,320, 20)];
    status.backgroundColor=[UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    [self.view addSubview:status];
    
    UILabel *head=[[UILabel alloc]initWithFrame:CGRectMake(0,20,320, 44)];
    head.backgroundColor=[UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    head.text=@"测试结果";
    head.font=[UIFont boldSystemFontOfSize:18];
    head.textAlignment =NSTextAlignmentCenter;
    [self.view addSubview:head];
    
    // Initialize and add the openDrawerButton

    UIButton *backButton=[[UIButton alloc]initWithFrame:CGRectMake(10.0f, 20, 44.0f, 44.0f)];
    [backButton setTitle: @"回顾" forState: UIControlStateNormal];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //[backButton setBackgroundColor: [UIColor blueColor]];
    [backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}

-(void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //[self dismissModalViewControllerAnimated:NO];//注意一定是NO！！
    //[[NSNotificationCenter  defaultCenter]postNotificationName:@"backback" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
