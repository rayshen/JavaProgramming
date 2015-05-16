//
//  RegisterViewController.m
//  Java Programming
//
//  Created by rayshen on 4/13/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "RegisterViewController.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *RmailField;
@property (weak, nonatomic) IBOutlet UITextField *RpasswordField;
@property (weak, nonatomic) IBOutlet UITextField *RpasswordField2;


@end

@implementation RegisterViewController

TFIndicatorView *indicator;


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    

    self.RpasswordField.delegate = self;
    self.RmailField.delegate = self;
    self.RpasswordField2.delegate = self;
    
    //指定编辑时键盘的return键类型
    self.RmailField.returnKeyType = UIReturnKeyNext;
    self.RpasswordField.returnKeyType = UIReturnKeyNext;
    self.RpasswordField2.returnKeyType = UIReturnKeyDefault;
    
    //注册键盘响应事件方法
    [self.RmailField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.RpasswordField addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.RpasswordField2 addTarget:self action:@selector(nextOnKeyboard:) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    //[self.toregister setBackgroundColor:[UIColor colorWithRed:140.0f/255.0f green:0/255.0f blue:211.0f/255.0f alpha:1]];

}

//UITextField的协议方法，当开始编辑时监听
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移75个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-75,width,height);
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
    [self.RmailField resignFirstResponder];
    [self.RpasswordField resignFirstResponder];
    [self.RpasswordField2 resignFirstResponder];
    [self resumeView];
}

//点击键盘上的Return按钮响应的方法
-(IBAction)nextOnKeyboard:(UITextField *)sender
{
    if (sender == self.RmailField){
        [self.RpasswordField becomeFirstResponder];
    }else if (sender == self.RpasswordField){
        [self.RpasswordField2 becomeFirstResponder];
    }else if (sender == self.RpasswordField2){
        [self hidenKeyboard];
    }
}


-(IBAction)btnClicGoBack:(UIButton *)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];

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

- (IBAction)toregister:(id)sender {
    
    [self setUpActivityIndicatorView];
    
    [NSThread detachNewThreadSelector:@selector(registcheck) toTarget:self withObject:nil];
    
}

-(void)registcheck{
    self.Remail=self.RmailField.text;
    self.Rpassword=self.RpasswordField.text;
    self.Rpassword2=self.RpasswordField2.text;
    NSLog(@"%@",self.Rpassword);
    if([self.Remail isEqualToString:@""]||[self.Rpassword isEqualToString:@""]||[self.Rpassword2 isEqualToString:@""]){
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 
                 initWithTitle:@"提示" message:@"请填写完整的信息!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"请填写完整的信息！");
    }
    else if (![self validateEmail:self.Remail]) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请填写正确的邮箱格式哦亲!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else if([self.Rpassword length]<6){
            UIAlertView *alert;
            alert = [[UIAlertView alloc]
                     
                     initWithTitle:@"提示" message:@"密码长度请保持6位以上!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];

    
    }else if(![self.Rpassword isEqualToString:self.Rpassword2]){
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 
                 initWithTitle:@"提示" message:@"两次密码不一样!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        NSLog(@"两次密码不一样！");
    }
    //checkihaveregistered
    else if([PersonConnection checkPersonwithemail:self.Remail]){
        //alertView的使用方法
        UIAlertView *alert;
        alert = [[UIAlertView alloc]
                 initWithTitle:@"提示" message:@"账号已经存在!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert show];
        NSLog(@"账号已经存在！您的账号为:%@",self.Remail);
    }
    else{
        //返回值为true时可以注册
        BOOL ifsuccess=[PersonConnection insertNewuser:self.Remail valueofpsw:self.Rpassword];
        UIAlertView *alert;
        if(ifsuccess){
            alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"注册成功！您的账号为:%@",self.Remail);
            self.RmailField.text=@"";
            self.RpasswordField.text=@"";
            self.RpasswordField2.text=@"";
        }
        else{
            alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接有问题注册不成功！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
            NSLog(@"注册失败！您的账号为:%@",self.Remail);
        }
    }
     [indicator stopAnimating];
}

-(void)setUpActivityIndicatorView{
    indicator = [[TFIndicatorView alloc]initWithFrame:CGRectMake(135, 275, 50, 50)];
    [self.view addSubview:indicator];
    [indicator startAnimating];
}

- (BOOL) validateEmail: (NSString *) candidate
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}
@end
