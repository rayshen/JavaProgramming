//
//  HostViewController.m
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "HostViewController.h"
#import "ContentViewController.h"
#import "ViewPagerController.h"
#import "BGRadioView.h"
#import "IOSTimeLabel.h"
#import "ResultBoardViewController.h"
#import "ICSDrawerController.h"

//在此类中实现ViewPager类中的函数的委托:Viewpager自己不执行，让HostViewController执行（比如一些翻页修改参数的函数）
//该类专门用于控制题目数据，对于不用考试类型进行参数修改即可完成
@interface HostViewController()<ViewPagerDataSource, ViewPagerDelegate,BGRadioViewDelegate,MZTimerLabelDelegate,ICSDrawerControllerChild, ICSDrawerControllerPresenting>{
    IOSTimeLabel *stopwatch;
}

@property int points;

@property Testproblem *curPro;

@end

@implementation HostViewController

UIActivityIndicatorView* activityIndicatorView2;

ResultBoardViewController  *RB;

BOOL ClickGoto=false;
BOOL Collect=false;
UIView *transView2;

- (void)viewDidLoad {
    
    [Examinfo initExam];
    
    self.dataSource = self;
    self.delegate = self;
    
    _curindex=[self getcurindex];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

    // 在ios7中设置Tabbar在NavigationBar下面
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [_Tabbar setDelegate:self];
    
    [_Tabbar setFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-50, 320, 44)];
    
    [super viewDidLoad];

    [self settabbaritemfont];

    [self addmenu];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(back) name:@"backback" object:nil];
    

    
    [self draweropen];
    
    NSLog(@"需要加载的题目有：单选:%i,多选:%i,判断:%i",[Examinfo getSingle],[Examinfo getMulti],[Examinfo getJudge]);
}


-(void)back
 
{
    [self dismissModalViewControllerAnimated:YES];
    
}

-(void)settabbaritemfont{
    //设置选中时的文字颜色：
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor blackColor] }
                                             forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:@{ UITextAttributeTextColor : [UIColor blackColor] }
                                             forState:UIControlStateNormal];
    
    //设置选中时的图片
    [_item2 setFinishedSelectedImage:[UIImage imageNamed:@"thumbs-up"] withFinishedUnselectedImage:[UIImage imageNamed:@"thumbs-up"]];
    [_jumpitem setFinishedSelectedImage:[UIImage imageNamed:@"th-list-outline"] withFinishedUnselectedImage:[UIImage imageNamed:@"th-list-outline"]];
    
    [_preitem setFinishedSelectedImage:[UIImage imageNamed:@"arrow-left-outline"] withFinishedUnselectedImage:[UIImage imageNamed:@"arrow-left-outline"]];
    
    [_nextitem setFinishedSelectedImage:[UIImage imageNamed:@"arrow-right-outline"] withFinishedUnselectedImage:[UIImage imageNamed:@"arrow-right-outline"]];


}

-(void)reloadappear{
    if (Collect==false){
        [_collectitem setFinishedSelectedImage:[UIImage imageNamed:@"heart-outline"] withFinishedUnselectedImage:[UIImage imageNamed:@"heart-outline"]];
    } else {
        [_collectitem setFinishedSelectedImage:[UIImage imageNamed:@"heart"] withFinishedUnselectedImage:[UIImage imageNamed:@"heart"]];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//完成ViewPager的Datasource：主要用于控制显示
#pragma mark - ViewPagerDataSource
//完成ViewPager的委托：设置题目的总数
- (NSUInteger)numberOfTabsForViewPager:(ViewPagerController *)viewPager {
    return 0;
}

//完成ViewPager的委托：翻页对页下脚的TabView进行设置，并返回一个label
- (UIView *)viewPager:(ViewPagerController *)viewPager viewForTabAtIndex:(NSUInteger)index {
    //NSLog(@"viewForTabAtIndex被执行,当前第%d页",index);

    UILabel *label = [UILabel new];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13.0];
    label.text = [NSString stringWithFormat:@"第 %i 题",(int)index+1];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blackColor];
    [label sizeToFit];
    return label;
}

//完成ViewPager的委托：主要用于界面展现的参数
#pragma mark - ViewPagerDelegate
//显示该页的题目数据=============================================================
- (UIViewController *)viewPager:(ViewPagerController *)viewPager contentViewControllerForTabAtIndex:(NSUInteger)index {
    
    ContentViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContentViewController"];
    
    self.curPro=[Examinfo getProblem:(int)index];
    cvc.curindex=index;
    cvc.Curpro=self.curPro;
    
    //取得题目===》判断类型==》加载相应ContentView
    NSLog(@"当前题目的类型是：%i",self.curPro->Ttype);
    
    /*
    //label显示当前题目类型
    switch (self.curPro->Ttype) {
        case 1:
            self.Typelabel.text=@"单项选择";
            break;
        case 2:
            self.Typelabel.text=@"多项选择";
            break;
        case 3:
            self.Typelabel.text=@"判断题";
            break;
        default:
            break;
    }
    */
    
    return cvc;
}

//完成ViewPager的委托： 运行时设置基本参数，从第几页开始、TabBAR的位置等
- (CGFloat)viewPager:(ViewPagerController *)viewPager valueForOption:(ViewPagerOption)option withDefault:(CGFloat)value {
    
    switch (option) {
        case ViewPagerOptionStartFromSecondTab:
            return 0.0;
            break;
        case ViewPagerOptionCenterCurrentTab:
            return 0.0;
            break;
        case ViewPagerOptionTabLocation:
            return 0.0;
            break;
        default:
            break;
    }
    
    return value;
}


-(void)startTime{
    [_Timelabel setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:0.75]];
    stopwatch = [[IOSTimeLabel alloc] initWithLabel:_Timelabel andTimerType:MZTimerLabelTypeTimer];
    [stopwatch setCountDownTime:2400];
    [stopwatch startWithEndingBlock:^(NSTimeInterval countTime) {
        NSLog(@"时间到");
        [self finishExam];
    }];
    stopwatch.timeLabel.font = [UIFont systemFontOfSize:22.0f];
    stopwatch.delegate=self;
    [stopwatch start];
}
/*
//点击交卷结束告示：
- (IBAction)FinishTest:(id)sender {
    ResultBoardViewController  *RB=[self.storyboard instantiateViewControllerWithIdentifier:@"ResultBoard"];
    RB.points=[Examinfo getPoints];
    RB.sumObj=[Examinfo getsumobj];
    RB.usingtime=[stopwatch getTimeCounted];
    
    //交卷后对本地收藏夹重新进行更新下
    [Personinfo initcollection];

    [self presentViewController:RB animated:YES completion:nil];

}*/

- (IBAction)clickmenu:(id)sender {
    NSLog(@"menu按钮被点击！！！");
}

//tabbar的各种点击选择事件================================================================
#pragma mark -- UITabBarDelegate
-(void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)Item{
    switch (Item.tag) {
        case 0:
            [self Gotopre];
            break;
        case 1:
            [self markpro];
            break;
        case 2:
            [self Jumpto];
            break;
        case 3:
            [self tocollect];
            break;
        case 4:
            [self Gotonext];
            break;
        default:
            
            break;
    }
}

-(void)markpro{
   
        //未标记，进行标记
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已标记该题!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    
        [Examinfo markProblem:(int)[self getcurindex]];
    
        NSString *proindex=[NSString stringWithFormat:@"%i",(int)[self getcurindex]];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:proindex forKey:@"proindex"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changebgc2" object:self userInfo:dictionary];
    
}

- (void)Gotopre{
    BOOL canDo=[self gotoprepage];
    if(canDo==false){
    }else{
    }
}

- (void)Gotonext{
    BOOL canDo=[self gotonextpage];
    if(canDo==false){
    }else{
    }
}

- (void)Jumpto{
    if (ClickGoto==false) {
        [self insertTabsView];
        ClickGoto=true;
        [_jumpitem setFinishedSelectedImage:[UIImage imageNamed:@"th-list"] withFinishedUnselectedImage:[UIImage imageNamed:@"th-list"]];

    }
    else{
        [self hideTabsView];
        ClickGoto=false;
        [_jumpitem setFinishedSelectedImage:[UIImage imageNamed:@"th-list-outline"] withFinishedUnselectedImage:[UIImage imageNamed:@"th-list-outline"]];

    }
}

-(void)tocollect{
    NSString *newproclt=[NSString stringWithFormat:@"%i",[self getcurproid]];
    UIAlertView *alert;
    if (Collect==false) {
        //点击了收藏 1检测是否已经收藏  2加到数据库 3加到本地icollection
        [NSThread detachNewThreadSelector:@selector(addcollect:) toTarget:self withObject:newproclt];
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已收藏该题!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        //NSLog(@"收藏了第%@题",newproclt);
        //并增加到数据库
        Collect=true;
        [self reloadappear];
    } else {
        [NSThread detachNewThreadSelector:@selector(removecollect:) toTarget:self withObject:newproclt];
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"已经取消收藏!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        //NSLog(@"取消收藏第%@题",newproclt);
        Collect=false;
        [self reloadappear];
    }
}

-(void)addcollect:(NSString *)newproclt{
    [Personinfo addcollect:newproclt];
    NSLog(@"第%@题收藏完毕",newproclt);
}
-(void)removecollect:(NSString *)newproclt{
    [Personinfo removecollect:newproclt];
    NSLog(@"第%@题取消收藏完毕",newproclt);
}
//========================================================================================

//每次刷新页面检测该题是否被收藏，对图标进行设置=================================================
- (void)viewPager:(ViewPagerController *)viewPager collected:(bool)iscollected{
    Collect=iscollected;
    [self reloadappear];
    NSLog(@"此处被执行，该题是否被收藏：%d",Collect);
}

//========================================================================================

-(void)addmenu{
    UILabel *status=[[UILabel alloc]initWithFrame:CGRectMake(0,0,320, 20)];
    status.backgroundColor=[UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    [self.view addSubview:status];
    
    UILabel *head=[[UILabel alloc]initWithFrame:CGRectMake(0,20,320, 44)];
    head.backgroundColor=[UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:1.0f];
    head.text=@"随机刷题";
    head.font=[UIFont boldSystemFontOfSize:18];
    head.textAlignment =NSTextAlignmentCenter;
    [self.view addSubview:head];
    
    // Initialize and add the openDrawerButton
    UIImage *hamburger = [UIImage imageNamed:@"menu-icon"];
    NSParameterAssert(hamburger);
    UIButton *openDrawerButton;
    openDrawerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    openDrawerButton.frame = CGRectMake(10.0f, 20, 44.0f, 44.0f);
    [openDrawerButton setImage:hamburger forState:UIControlStateNormal];
    [openDrawerButton addTarget:self action:@selector(openDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:openDrawerButton];
    
    /*
    //==============================================================================
    UIButton *handpaper=[[UIButton alloc]initWithFrame:CGRectMake(250,20,44, 44)];
    [handpaper setTitle:@"交卷" forState:UIControlStateNormal];
    [handpaper setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [handpaper addTarget:self action:@selector(FinishTest:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:handpaper];
    */

}
#pragma mark - Configuring the view’s layout behavior

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

#pragma mark - Open drawer button
-(void)showindicatior{
    transView2=[[UIView alloc]initWithFrame:CGRectMake(-320,0,640,self.view.frame.size.height)];
    [transView2 setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:0.6]];
    
    
    activityIndicatorView2 = [ [ UIActivityIndicatorView  alloc ] initWithFrame:CGRectMake(200,self.view.frame.size.height/2-15,30.0,30.0)];
    activityIndicatorView2.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    //activityIndicatorView.hidesWhenStopped=NO;
    [transView2 addSubview:activityIndicatorView2];
    //[self.view addSubview:activityIndicatorView];
    [self.view addSubview:transView2];
    
    [activityIndicatorView2 startAnimating];//启动
}


- (void)openDrawer:(id)sender
{
    [self.drawer open];
}

-(void)finishExam{
    [stopwatch pause];
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  finishtime=[dateformatter stringFromDate:senddate];
    [Examinfo setfinishtime:finishtime];
    
    [Examinfo setisfinish:true];
    
    [self showindicatior];
    
    RB=[self.storyboard instantiateViewControllerWithIdentifier:@"ResultBoard"];
    RB.points=[Examinfo getPoints];
    RB.sumObj=[Examinfo getsumobj];
    RB.usingtime=[stopwatch getTimeCounted];
    
    [self performSelector:@selector(presentToNext) withObject:nil afterDelay:1];

    if([Examinfo getexamType]==0){
        //40题上传成绩和具体成绩
        //子线程上传成绩
        [NSThread detachNewThreadSelector:@selector(uploadresult) toTarget:self withObject:nil];
    }else{
        [NSThread detachNewThreadSelector:@selector(updatewrongbook) toTarget:self withObject:nil];

        NSLog(@"不是40题测试，不上传成绩，但更新错题本");
    }
}
-(void)presentToNext{
    [self presentViewController:RB animated:YES completion:^{
        [transView2 removeFromSuperview];
    }];
}

-(void)uploadresult{
    [Examinfo uploadresult];
    //[Examinfo updateCredit];
    [Examinfo updateWrongprobook];
    NSLog(@"答题结果及错题本更新完毕");
}

-(void)updatewrongbook{
    [Examinfo updateWrongprobook];
}

- (IBAction)FinishTest:(id)sender {
    [self finishExam];
}

-(void)handpaper{
    [self finishExam];
}

-(void)selectpro:(int)proindex{
    [self jumptoindex:proindex];
}

-(void)starttimecount{
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *  starttime=[dateformatter stringFromDate:senddate];
    [Examinfo setstarttime:starttime];
   [self startTime];
}

-(void)draweropen{
    [self.drawer open];
}

@end
