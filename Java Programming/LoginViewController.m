//
//  ScrollViewController.m
//  Java Programming
//
//  Created by rayshen on 4/13/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "LoginViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "SideMenuViewController.h"
@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;


@property NSString *username;
@property NSString *password;


@end

@implementation LoginViewController

TFIndicatorView *indicator;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadkeyboardview];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *testStr = [defaults objectForKey:@"Didlogin"];
    NSLog(@"Didlogin is: %@",testStr);
}


//登录按钮=============================================================
//连接apache用mysql验证


-(void)gotoindexviewcontroller{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    
    MFSideMenuContainerViewController *container =[storyboard instantiateViewControllerWithIdentifier:@"MFSideMenuContainerViewController"];
    
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"indexNavViewController"];
    
    SideMenuViewController *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    
    //UIViewController *rightSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"rightSideMenuViewController"];
    
    [container setLeftMenuViewController:leftSideMenuViewController];
    //[container setRightMenuViewController:rightSideMenuViewController];
    [container setCenterViewController:navigationController];
    
    [self presentViewController:container animated:YES completion:nil];
}


- (IBAction)loginbtn:(id)sender {
    
    [self setUpActivityIndicatorView];
    
    self.view.userInteractionEnabled=NO;
    
    [NSThread detachNewThreadSelector:@selector(logincheck) toTarget:self withObject:nil];
}

-(void)setUpActivityIndicatorView{
    indicator = [[TFIndicatorView alloc]initWithFrame:CGRectMake(135, 275, 50, 50)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
}

-(void)gotoindex{
    [indicator stopAnimating];
    
    //通过邮箱，全局初始化改用户信息（建立缓存）
    //[self initpersoninfo];
    
    
    //把用户登录信息存到NSUserDefaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setObject:self.username forKey:@"NSuseremail"];
    [defaults setObject:self.password forKey:@"NSpassword"];
    
    [defaults setBool:YES forKey:@"Didlogin"];
    
    [defaults synchronize];
    
    //NSString *testStr = [defaults objectForKey:@"myTest"];
    //NSLog(@"testStr is: %@",testStr);
    //跳转到index菜单界面
    [self gotoindexviewcontroller];

}

-(void)logincheck{
    self.username=self.usernameField.text;
    self.password=self.passwordField.text;
    if(![PersonConnection checkConnect]){
        self.view.userInteractionEnabled=YES;

        [indicator stopAnimating];
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接有问题!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }
    else if([PersonConnection checkPerson:self.username valueofpsw:self.password]){
        [self performSelectorOnMainThread:@selector(gotoindex) withObject:nil waitUntilDone:YES];
    
    }else{
        self.view.userInteractionEnabled=YES;
        [indicator stopAnimating];
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"账号或密码错误!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"账号或密码错误！！");
    }
}

-(void)hideindicator{
    [indicator stopAnimating];
}
//===========================================================================

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.scrollview=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
    [self.scrollview setContentSize:CGSizeMake(320, 960)];
}

//设置键盘函数===================================================================
-(void)loadkeyboardview{
    //关于scrollView的大小设置
    //[self.scrollview setContentSize:CGSizeMake(320, 960)];

    //[self.view setBackgroundColor:[UIColor whiteColor]];
    
    [_loginbtn setBackgroundColor:[UIColor colorWithRed:34.0f/255.0f green:98.0f/255.0f blue:216.0f/255.0f alpha:0.75]];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bg1.png"]]];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    //指定编辑时键盘的return键类型
    self.usernameField.returnKeyType = UIReturnKeyNext;
    self.passwordField.returnKeyType = UIReturnKeyDefault;
    
    //注册键盘响应事件方法
    [self.usernameField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.passwordField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];

}

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移45个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-45,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
    return YES;
}

//恢复原始视图位置
-(void)resumeView
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    //float Y = 20.0f;
    CGRect rect=CGRectMake(0.0f,0,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}
//隐藏键盘的方法
-(void)hidenKeyboard
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self resumeView];
}
//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if (sender == self.usernameField) {
        [self.passwordField becomeFirstResponder];
    }else if (sender == self.passwordField){
        [self hidenKeyboard];
    }
}
//============================================================================
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//注册按钮
- (IBAction)toRegister:(id)sender {
    RegisterViewController *rvc=[self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    //rvc.newpersonDB=self.newpersonDB;
    [self presentViewController:rvc animated:YES completion:nil];

}

@end
