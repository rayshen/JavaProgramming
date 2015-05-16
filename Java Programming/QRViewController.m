//
//  ViewController.m
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import "QRViewController.h"
#import "RootViewController.h"
@interface QRViewController ()

@end

@implementation QRViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    
	UIButton * scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton setTitle:@"扫一扫登录" forState:UIControlStateNormal];
    scanButton.titleLabel.font = [UIFont systemFontOfSize: 22.0];
    scanButton.frame = CGRectMake(100, 150, 120, 40);
    [scanButton addTarget:self action:@selector(setupCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton];
    
    UILabel *tips=[[UILabel alloc]initWithFrame:CGRectMake(60, 250, 200, 60)];
    tips.text=@"电脑端登陆www.java.zjut.edu.com扫一扫有惊喜";
    tips.textColor=[UIColor grayColor];
    tips.font=[UIFont systemFontOfSize: 14.0];
    tips.numberOfLines=3;
    tips.textAlignment = UITextAlignmentCenter;
    tips.lineBreakMode = UILineBreakModeWordWrap;
    [self.view addSubview:tips];
    
    UIButton * scanButton2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [scanButton2 setTitle:@"退出" forState:UIControlStateNormal];
    scanButton2.frame = CGRectMake(100, 400, 120, 40);
    [scanButton2 addTarget:self action:@selector(tocancel) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanButton2];

}

-(void)tocancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupCamera
{          
    if(IOS7)
    {
        RootViewController * rt = [[RootViewController alloc]init];
        [self presentViewController:rt animated:YES completion:^{
            NSLog(@"IOS7扫描");
        }];

    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
