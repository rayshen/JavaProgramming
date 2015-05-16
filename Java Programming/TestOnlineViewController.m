//
//  TestOnlineViewController.m
//  Java Programming
//
//  Created by way on 14-6-27.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import "TestOnlineViewController.h"

@interface TestOnlineViewController ()

@end

@implementation TestOnlineViewController

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
    [self addTypechoose];
    
    self.tips.text=[Examinfo gettips];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"exambg.png"]]];

}


-(void)addTypechoose{
    SSCheckBoxView *cb = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(50, 140, 300, 30) style:kSSCheckBoxViewStyleMono checked:YES];
    [cb setText:@"单选"];
    [cb setTag:11];
    [cb setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    [self.view addSubview:cb];
    
    SSCheckBoxView *cb2 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(130, 140, 300, 30) style:kSSCheckBoxViewStyleMono checked:YES];
    [cb2 setText:@"多选"];
    [cb2 setTag:22];
    [cb2 setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    [self.view addSubview:cb2];
    
    SSCheckBoxView *cb3 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(210, 140, 300, 30) style:kSSCheckBoxViewStyleMono checked:YES];
    [cb3 setText:@"判断"];
    [cb3 setTag:33];
    [cb3 setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    [self.view addSubview:cb3];

    //默认全部选中
    [Examinfo setSingle:YES];
    [Examinfo setMulti:YES];
    [Examinfo setJudge:YES];
}


- (void) checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    NSLog(@"第%d个选项的结果被改变成%d",(int)cbv.tag,cbv.checked);
    for (SSCheckBoxView *cbv in self.checkboxes) {
        cbv.enabled = !cbv.enabled;
    }
    //以下为选中情况
    if (cbv.checked==1) {
        if (cbv.tag==11) {
            [Examinfo setSingle:YES];
        }else if (cbv.tag==22) {
            [Examinfo setMulti:YES];
        }else if (cbv.tag==33) {
            [Examinfo setJudge:YES];
        }
    }else if (cbv.checked==0){
        if (cbv.tag==11) {
            [Examinfo setSingle:NO];
        }else if (cbv.tag==22) {
            [Examinfo setMulti:NO];
        }else if (cbv.tag==33) {
            [Examinfo setJudge:NO];
        }
    }
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

- (IBAction)UIControl:(id)sender {
    switch (self.UIControl.selectedSegmentIndex) {
        case 0:
            self.choose=0;
            break;
        case 1:
            self.choose=1;
            break;
        case 2:
            self.choose=2;
            break;
        default:
            self.choose=3;
            break;
    }

}
- (IBAction)UIButton:(id)sender {
    
    //什么都不选的情况下进行测试的提示
    if ([Examinfo getexamType]!=4&&[Examinfo getexamType]!=5&&![Examinfo getSingle]&&![Examinfo getMulti]&&![Examinfo getJudge]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"蛇精病啊，什么都不选怎么测啊!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"我是蛇精病", nil];
        [alert show];
    }else{
        [self prepareForExamType];
        [self startExam];
    }
}

-(void)prepareForExamType{
    switch (self.choose) {
        case 0:
            [Examinfo setexamType:0];//TestOnline-50
            break;
        case 1:
            [Examinfo setexamType:3];//TestOnline-infinite
            //[Examinfo setexamType:1];//TestOnline-100
            break;
        case 2:
            [Examinfo setexamType:2];//TestOnline-simulate
            break;
        default:
            [Examinfo setexamType:3];//TestOnline-infinite
            break;
    }
}

-(void)startExam{
    ICSColorsViewController *colorsVC = [[ICSColorsViewController alloc] init];
    HostViewController *host = [self.storyboard instantiateViewControllerWithIdentifier:@"HostViewController"];
    ICSDrawerController *drawer=[self.storyboard instantiateViewControllerWithIdentifier:@"ICSDrawerController"];
    drawer = [[ICSDrawerController alloc] initWithLeftViewController:colorsVC centerViewController:host];
    colorsVC.leftdelegate=host;
    drawer.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:drawer animated:YES completion:nil];
}

@end
