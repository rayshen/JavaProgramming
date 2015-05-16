//
//  SideMenuViewController2.m
//  Java Programming
//
//  Created by way on 14-7-24.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import "SideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "LoginViewController.h"
#import "PageContentViewController.h"
#import "RankViewController.h"

@interface SideMenuViewController ()

@property UITableView *tableView;

@end

@implementation SideMenuViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"indexleftbg.png"]]];
    
    UIView *transView=[[UIView alloc]initWithFrame:self.view.frame];
    [transView setBackgroundColor:[UIColor colorWithRed:226.0/255.0 green:231.0/255.0 blue:237.0/255.0 alpha:0.6]];
    [self.view addSubview:transView];
    [self addtableview];
    // Do any additional setup after loading the view.
}

-(void)addtableview{
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 64, 280, 400) style:UITableViewStyleGrouped];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource
/*
 - (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
 return [NSString stringWithFormat:@"Section %d", section];
 }*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    switch (indexPath.row) {
            /*case 0:
             cell.textLabel.text =@"我的排名";
             break;
             */
        case 0:
            cell.textLabel.text =@"评价应用";
            break;
        case 1:
            cell.textLabel.text =@"关于应用";
            break;
        case 2:
            cell.textLabel.text =@"教材购买";
            break;
        case 3:
            cell.textLabel.text =@"扫一扫登录";
            break;
        default:
            cell.textLabel.text =@"退出账号";
            break;
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PageContentViewController *about = [self.storyboard instantiateViewControllerWithIdentifier:@"about"];
    //RankViewController *RankViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RankViewController"];
    switch (indexPath.row) {
            /*case 0:
             [self presentViewController:RankViewController animated:YES completion:nil];
             break;
             */
        case 0:
            break;
        case 1:
            about.modalTransitionStyle=UIModalTransitionStylePartialCurl;
            [self presentViewController:about animated:YES completion:nil];
            break;
        case 2:
            [self openbookURL];
            break;
        case 3:
            [self QRstart];
            break;
        default:
             [self logout];
            break;
    }
}

-(void)QRstart{
     NSLog(@"点击扫一扫");
    QRViewController *qrvc=[[QRViewController alloc]init];
    [self presentViewController:qrvc animated:YES completion:nil];
}
-(void)openbookURL{
    NSLog(@"点击教材购买");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://m.jd.com/product/1059303980.html"]];
}

-(void)addcopyrightlabel{
    UILabel *copyright=[[UILabel alloc]initWithFrame:CGRectMake(100, 400,100, 30)];
    copyright.text=@"rayshen.net";
    copyright.textColor=[UIColor grayColor];
    //[tableView addSubview:copyright];
    
}
-(void)logout{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示?" message:@"确定要退出账号吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert setTag:1];
    [alert addButtonWithTitle:@"取消"];
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    LoginViewController *LoginViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([alertView tag] == 1) {    // it's the Error alert
        if (buttonIndex == 0) {     // and they clicked OK.
            [defaults setObject:nil forKey:@"NSuseremail"];
            [defaults setObject:nil forKey:@"NSpassword"];
            [defaults setObject:nil forKey:@"NSuserid"];
            [defaults setObject:nil forKey:@"NSusername"];
            [defaults setObject:nil forKey:@"NSusersex"];
            [defaults setObject:nil forKey:@"NSuserschool"];
            [defaults setObject:nil forKey:@"NSuserpnum"];

            [defaults setBool:NO forKey:@"Didlogin"];
            [defaults synchronize];
            [self presentViewController:LoginViewController animated:YES completion:nil];
            NSLog(@"点击退出账号！！");
        }
    }
    
}
//==============================以下二维码扫描部分


@end
