//
//  indexViewController.m
//  Java Programming
//
//  Created by rayshen on 4/14/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "indexViewController.h"
#import "CollectionCell.h"
#import "PageContentViewController.h"
#import "TestOnlineViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "SHRootController.h"
#import "CKCalendarView.h"
@interface indexViewController (){
    NSInteger year;
    NSInteger month;
    NSInteger day;

    
}


@end

@implementation indexViewController

UIActivityIndicatorView* activityIndicatorView;

UIButton *calendarbutton;

CKCalendarView *calendar;

UIView *transView;

BOOL calendarisshow;

- (void)viewDidLoad
{
    //每天首次登陆增加10积分================================================
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //[self.view setBackgroundColor:[UIColor colorWithRed:79.0f/255.0f green:148.0f/255.0f blue:205.0f/255.0f alpha:1]];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"indexbg.png"]]];
    
    [self.CollectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:@"CollectionCell"];
    
    [self.CollectionView setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.4]];
    
    [self.CollectionView setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-320, 320, 300)];
    
    //[self.CollectionView setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.5]];

    [self.view addSubview:self.CollectionView];
    
    [self showindicatior];

    [self addcalendarbutton];
    
    
    //获得系统时间
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  locationString=[dateformatter stringFromDate:senddate];
    NSLog(@"当前时间为:%@",locationString);
    
    //获得系统日期
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    year=[conponent year];
    month=[conponent month];
    day=[conponent day];
    
    [NSThread detachNewThreadSelector:@selector(checkPSW) toTarget:self withObject:nil];    
}
-(void)checkPSW{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *NSuseremail = [defaults objectForKey:@"NSuseremail"];
    NSString *NSpassword = [defaults objectForKey:@"NSpassword"];
    
    if(![PersonConnection checkConnect]){
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接有问题!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else if([PersonConnection checkPerson:NSuseremail valueofpsw:NSpassword]){
            [NSThread detachNewThreadSelector:@selector(initpersoninfo) toTarget:self withObject:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你的账号密码已经被修改过，请重新登陆" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        // optional - add more buttons:
        [alert setTag:100];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    LoginViewController *LoginViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([alertView tag] == 100) {    // it's the Error alert
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
- (NSString*) stringFromFomate:(NSDate*) date formate:(NSString*)formate
{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:formate];
	NSString *str = [formatter stringFromDate:date];
	//[formatter release];
	return str;
}

-(void)addcalendarbutton{
    
    calendarbutton=[[UIButton alloc]initWithFrame:CGRectMake(10, 10, 80, 40)];
    [calendarbutton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.6]];

    [calendarbutton setTitle: @"日历" forState: UIControlStateNormal];
    /*
    UILabel *datelabel=[[UILabel alloc]init];
    datelabel.text=@"日历";
    [calendarbutton addSubview:datelabel];
    */
    //[calendarbutton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    [calendarbutton addTarget:self action:@selector(addcalendar) forControlEvents:UIControlEventTouchUpInside];

    calendar = [[CKCalendarView alloc] initWithStartDay:startMonday];
    calendar.frame = CGRectMake(10, 100, 300, 470);
    
    [self.view addSubview:calendarbutton];
    
}

-(void)addcalendar{
    if(calendarisshow){
        [calendar removeFromSuperview];
        calendarisshow=NO;
        
        [calendarbutton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.6]];

    }else{
        calendarisshow=YES;
        
        transView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 578)];
        [transView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:0.6]];
        
        [self.view addSubview:transView];
        
        //添加手势，点击屏幕其他区域关闭日历的操作
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenCalendar)];
        
        [transView addGestureRecognizer:gesture];
        [self.view addSubview:calendar];
        
        [calendarbutton setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:0.75]];

    }
}

-(void)hidenCalendar{    
    calendarisshow=NO;
    
    [calendarbutton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.6]];
    
    [transView removeFromSuperview];
     [calendar removeFromSuperview];
    
}

-(void)initpersoninfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *NSuseremail = [defaults objectForKey:@"NSuseremail"];
    NSString *NSpassword = [defaults objectForKey:@"NSpassword"];
    NSLog(@"该用户ID:%@,NSuseremail is: %@,NSpassword is: %@",[defaults objectForKey:@"NSuserid"],NSuseremail,NSpassword);
    
    //读取近期存储的信息
    if ([defaults objectForKey:@"NSuserid"]!=NULL) {
        [Personinfo setiuserid:[[defaults objectForKey:@"NSuserid"] intValue]];
        [Personinfo setimailbox:[defaults objectForKey:@"NSuseremail"]];
        [Personinfo setiname:[defaults objectForKey:@"NSusername"]];
        [Personinfo setisex:[defaults objectForKey:@"NSusersex"]];
        [Personinfo setischool:[defaults objectForKey:@"NSuserschool"]];
        [Personinfo setipnum:[defaults objectForKey:@"NSuserpnum"]];
    }
    
    [PersonConnection setPerson:NSuseremail valueofpsw:NSpassword];
    [Personinfo initcollection];
    [Personinfo initwrongpros];
    [Personinfo inittestresults];
    
    NSLog(@"初始化用户信息成功,菊花应该不见拉");

    //把用户登录信息存到NSUserDefaults
    [defaults setObject:[NSString stringWithFormat:@"%d",[Personinfo getid]] forKey:@"NSuserid"];
    [defaults setObject:[Personinfo getname] forKey:@"NSusername"];
    [defaults setObject:[Personinfo getsex] forKey:@"NSusersex"];
    [defaults setObject:[Personinfo getschool] forKey:@"NSuserschool"];
    [defaults setObject:[Personinfo getpnum] forKey:@"NSuserpnum"];
    
    [defaults synchronize];
    
    [activityIndicatorView stopAnimating];//菊花停止
}

-(void)showindicatior{
    activityIndicatorView = [ [ UIActivityIndicatorView  alloc ] initWithFrame:CGRectMake(270,25,30.0,30.0)];
    activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    //activityIndicatorView.hidesWhenStopped=NO;
    [self.navigationController.view addSubview:activityIndicatorView];
    //[self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];//菊花启动
}



//设置index界面的ITEM个数，文字和图片===========================================
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return indexItemNum;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CollectionCell *cell = (CollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    //图片名称
    NSString *imageToLoad = [NSString stringWithFormat:@"%ld.png", (long)indexPath.row];
    //加载图片
    cell.imageView.image = [UIImage imageNamed:imageToLoad];
    
    //从数组根据每个项目导入label文字，数组在.h文件中
    cell.label.text =indexItem[(long)indexPath.row];
    cell.label.textColor=[UIColor whiteColor];
    
    return cell;
}
//===========================================================================


//collectionView的点击接口函数实现=============================================
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell #%ld was selected", indexPath.row);
    [self gotoNext:(int)indexPath.row];
    
    return;
}

-(void)gotoNext:(int)options{
    //根据每个view的identifier ，取得storyboard上设计的view
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    MyinfoViewController *myinfo = [storyBoard instantiateViewControllerWithIdentifier:@"myinfo"];
    PageContentViewController *about = [storyBoard instantiateViewControllerWithIdentifier:@"about"];
    MycollectionViewController *mycollection=[storyBoard instantiateViewControllerWithIdentifier:@"MycollectionViewController"];
    WrongprosbookViewController *wrongprosbook=[storyBoard instantiateViewControllerWithIdentifier:@"WrongprosbookViewController"];
    //MytestresultsViewController *testresults=[storyBoard instantiateViewControllerWithIdentifier:@"MytestresultsViewController"];
    //=====================================================================
    TestOnlineViewController *TestOnline=[storyBoard instantiateViewControllerWithIdentifier:@"TestOnlineViewController"];

    ICSColorsViewController *colorsVC = [[ICSColorsViewController alloc] init];
    
    HostViewController *host = [self.storyboard instantiateViewControllerWithIdentifier:@"HostViewController"];
    
    ICSDrawerController *drawer=[self.storyboard instantiateViewControllerWithIdentifier:@"ICSDrawerController"];
    
    drawer = [[ICSDrawerController alloc] initWithLeftViewController:colorsVC centerViewController:host];
    
    colorsVC.leftdelegate=host;
    
    DownloadViewController *PPTDownloadViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"PPTDownloadViewController"];
    
    SHRootController *SHRootController=[self.storyboard instantiateViewControllerWithIdentifier:@"SHRootController"];
    
    //====================================================================================

    //typedef enum { UIModalTransitionStyleCoverVertical = 0, UIModalTransitionStyleFlipHorizontal, UIModalTransitionStyleCrossDissolve, UIModalTransitionStylePartialCurl,} UIModalTransitionStyle;
    //====================================================================================
    
    
    switch (options)
    {
        case 0:
            [self.navigationController pushViewController:myinfo animated:YES];
            break;
        case 1:
            [self.navigationController pushViewController:TestOnline animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:wrongprosbook animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:mycollection animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:SHRootController animated:YES];
            break;
        case 5:
            [self.navigationController pushViewController:PPTDownloadViewController animated:YES];
            break;
        default:

            break;
    }
}
//================================================================================

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

- (MFSideMenuContainerViewController *)menuContainerViewController {
    return (MFSideMenuContainerViewController *)self.navigationController.parentViewController;
}


- (IBAction)showLeftMenuPressed:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

@end
