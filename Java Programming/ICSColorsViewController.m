//
//  ICSColorsViewController.m
//
//  Created by Vito Modena
//
//  Copyright (c) 2014 ice cream studios s.r.l. - http://icecreamstudios.com
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of
//  this software and associated documentation files (the "Software"), to deal in
//  the Software without restriction, including without limitation the rights to
//  use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
//  the Software, and to permit persons to whom the Software is furnished to do so,
//  subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
//  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
//  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
//  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "ICSColorsViewController.h"
#import "TestCollectionCell.h"

UICollectionView *cv;

static NSString *tableCell = @"tableCell";


@interface ICSColorsViewController ()

@property(nonatomic, assign) NSInteger previousRow;


@end

@implementation ICSColorsViewController

Testproblem *curPro;

UIActivityIndicatorView* activityIndicatorView;

UIView *transView;

UIButton *handpaper;

UIButton *quit;

#pragma mark - Managing the view

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadthisView];

    [self performSelector: @selector(addalertview) withObject: nil afterDelay: 0.5];
}

-(void)viewWillAppear:(BOOL)animated{
    if ([Examinfo ifisfinish]) {
        [handpaper removeFromSuperview];
        [quit setFrame:CGRectMake(80,30,100,30)];
    }
    
    [cv reloadData];
}

-(void)loadthisView{
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"testbg"]]];
    
    [self addmenu];
    
    [self addcollectionview];
    
    [self initobserver];
}

-(void)addalertview{
    UIAlertView *alert= [[UIAlertView alloc]initWithTitle:@"提示" message:@"Are you ready?" delegate:self cancelButtonTitle:@"Go!" otherButtonTitles:nil];
    alert.tag=99;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==99&&(int)buttonIndex==0){
        [self.drawer close];
        if ([Examinfo getexamType]==0) {
            [self.leftdelegate starttimecount];
        }
    }
}

-(void)initobserver{
    //代码写的有点烂，下次再改了！SORRY！
    //标记蓝色
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changebgc:) name:@"changebgc" object:nil];
    //标记绿色
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changebgc2:) name:@"changebgc2" object:nil];
}

-(void)addmenu{
    handpaper=[[UIButton alloc]initWithFrame:CGRectMake(10,30,100,30)];
    [handpaper setTitle:@"交卷" forState:UIControlStateNormal];
    [handpaper setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [handpaper setBackgroundColor:[UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:0.5f]];
    [handpaper addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:handpaper];
    
    quit=[[UIButton alloc]initWithFrame:CGRectMake(150,30,100,30)];
    [quit setTitle:@"退出" forState:UIControlStateNormal];
    [quit setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [quit setBackgroundColor:[UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:0.5f]];
    [quit addTarget:self action:@selector(quit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:quit];
}

-(void)finish:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示?" message:@"确定要交卷吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert setTag:2];
    [alert addButtonWithTitle:@"取消"];
    [alert show];

}

-(void)showindicatior{
    transView=[[UIView alloc]initWithFrame:self.view.frame];
    [transView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:0.6]];
    
    
    activityIndicatorView = [ [ UIActivityIndicatorView  alloc ] initWithFrame:CGRectMake(self.view.frame.size.width/2-15,self.view.frame.size.height/2-15,30.0,30.0)];
    activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    //activityIndicatorView.hidesWhenStopped=NO;
    [transView addSubview:activityIndicatorView];
    //[self.view addSubview:activityIndicatorView];
    [self.view addSubview:transView];
    
    [activityIndicatorView startAnimating];//启动
}

-(void)quit:(id)sender{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示?" message:@"确定要退出吗?" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    // optional - add more buttons:
    [alert setTag:3];
    [alert addButtonWithTitle:@"取消"];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 2) {    // it's the Error alert
        if (buttonIndex == 0) {     // and they clicked OK.
            [self.leftdelegate handpaper];
            //[self showindicatior];
        }
    }
    if ([alertView tag] == 3) {    // it's the Error alert
        if (buttonIndex == 0) {     // and they clicked OK.
            [Examinfo setisfinish:true];
            [self.drawer poptoindexview];
        }
    }
}
//==================================================================================
-(void)addcollectionview{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(40, 40)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    
    cv=[[UICollectionView alloc]initWithFrame:CGRectMake(10,84,240,[[UIScreen mainScreen] bounds].size.height-128) collectionViewLayout:flowLayout];
    
    [cv registerClass:[TestCollectionCell class] forCellWithReuseIdentifier:@"TestCollectionCell"];
    
    [cv setBackgroundColor:[UIColor clearColor]];
    cv.delegate=self;
    cv.dataSource=self;
    [self.view addSubview:cv];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [Examinfo getsumobj];
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    TestCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestCollectionCell" forIndexPath:indexPath];
    cell.tag=[indexPath row]+1;
    cell.label.text=[NSString stringWithFormat:@"%d",(int)cell.tag];
    //NSLog(@"添加了TAG为%i的cell",(int)cell.tag);
    
    //标记大于做题
    if([Examinfo checkIfchoose:(int)[indexPath row]]){
         [cell setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:0.75]];
    }
    else{
        [cell setBackgroundColor:[UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:0.8f]];
    }
    
    if([Examinfo checkIfmark:(int)[indexPath row]]){
        [cell setBackgroundColor:[UIColor colorWithRed:118.0f/255.0f green:238.0f/255.0f blue:0/255.0f alpha:0.75f]];
    }else{

    }
    
    if ([Examinfo ifisfinish]) {
        if([Examinfo checkifisright:(int)[indexPath row]]){
            //NSLog(@"此%i题已正确",(int)[indexPath row]);
            if([Examinfo checkIfchoose:(int)[indexPath row]]){
                [cell setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:0.75]];
            }
            else{
                [cell setBackgroundColor:[UIColor colorWithRed:243.0f/255.0f green:243.0f/255.0f blue:243.0f/255.0f alpha:0.8f]];
            }
        }else{
            [cell setBackgroundColor:[UIColor redColor]];
        }
    }
    
    
    return cell;
}

#pragma mask - delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	//NSLog(@"点击了第%d题",(int)[indexPath row]+1);
    [self.drawer reloadCenterViewControllerUsingBlock:^(){}];
    [self.leftdelegate selectpro:(int)[indexPath row]];

}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
/*
//==================================================================================
//=========tablewview===============================================================
-(void)addtableview{
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,20,260,500)];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:tableCell];

    [tableView setBackgroundColor:[UIColor clearColor]];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [self.view addSubview:tableView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCell forIndexPath:indexPath];
             
    if ((long)indexPath.row==0) {
        cell.textLabel.text=@"交卷";
    }else if ((long)indexPath.row==8) {
         cell.textLabel.text=@"退出测试";
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"第%ld行", (long)indexPath.row];
    }
    cell.backgroundColor = [UIColor clearColor];

    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0){
        [self.leftdelegate handpaper];
    }else if (indexPath.row==8) {
        [self.drawer poptoindexview];
    }else{
        [self.drawer reloadCenterViewControllerUsingBlock:^(){}];
    }
    self.previousRow = indexPath.row;
}
//====================================================================================
#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}
//====================================================================================
*/


-(void)changebgc:(NSNotification *) notification{
    
    NSString *proindex = [[notification userInfo] objectForKey:@"proindex"];
    
    int intproindex=[proindex intValue];
    
    //NSLog(@"准备改变第%i题的颜色",proindex2);
    
    TestCollectionCell * thiscell= (TestCollectionCell *)[cv viewWithTag:intproindex+1];
    
    [thiscell setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:0.75]];
    
    //NSLog(@"该题是%d",(int)thiscell.tag);
    
    return ;
}

-(void)changebgc2:(NSNotification *) notification{
    
    NSString *proindex = [[notification userInfo] objectForKey:@"proindex"];
    
    int intproindex=[proindex intValue];
    
    //NSLog(@"准备改变第%i题的颜色",proindex2);
    
    TestCollectionCell * thiscell= (TestCollectionCell *)[cv viewWithTag:intproindex+1];
    
    [thiscell setBackgroundColor:[UIColor greenColor]];
    
    //NSLog(@"该题是%d",(int)thiscell.tag);
    
    return ;
}
//==================================================================================


@end
