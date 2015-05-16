//
//  PPTDownloadViewController.m
//  Java Programming
//
//  Created by way on 14-7-3.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import "PPTDownloadViewController.h"
#import "PersonConnection.h"
@interface PPTDownloadViewController ()

@property long long sum;

@property long long rcv;

@property UIProgressView *pv;

@property UIWebView *myWebview;

@property NSMutableArray *dirArray;

@property (nonatomic, strong) UIDocumentInteractionController *docInteractionController;

@end

UITableView *tview;

UIActivityIndicatorView* activityIndicatorView;

UIView *transView;

BOOL isDownload[13];

BOOL isDowloading;

NSString *PPTindex[13] ={
    @"第01章 Java语言概述.ppt",
    @"第02章 Java基础语法.ppt",
    @"第03章 类和对象.ppt",
    @"第04章 类的封装性、继承性、多态性与接口.ppt",
    @"第05章 数组、字符串和枚举.ppt",
    @"第06章 数组、字符串和枚举.ppt",
    @"第07章 异常处理.ppt",
    @"第08章 文件和流.ppt",
    @"第09章 图形用户界面编程.ppt",
    @"第10章 多线程.ppt",
    @"第11章 网络编程.ppt",
    @"第12章 数据库编程.ppt",
    @"第13章 XML及程序打包.ppt",
};

NSString *PPTSourcename[13]={
    @"Chapter01.ppt",
    @"Chapter02.ppt",
    @"Chapter03.ppt",
    @"Chapter04.ppt",
    @"Chapter05.ppt",
    @"Chapter06.ppt",
    @"Chapter07.ppt",
    @"Chapter08.ppt",
    @"Chapter09.ppt",
    @"Chapter10.ppt",
    @"Chapter11.ppt",
    @"Chapter12.ppt",
    @"Chapter13.ppt",
};

@implementation PPTDownloadViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addbackbutton];
    [self drawTableView];
    //[self checkisdown];
    //[self showfiles];
    [self drawimageview];

    //if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    //self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)addbackbutton{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain
                                                                      target:self action:@selector(popview)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
    
}

-(void)popview{
    if (isDowloading) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示?" message:@"正在下载，直接退出吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alert setTag:99];
        [alert show];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    
    //self.automaticallyAdjustsScrollViewInsets = NO;
}

-(void)drawimageview{
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0,0, 320, 132)];
    imageView.image = [UIImage imageNamed:@"jiaocaippt.png"];
    [self.view addSubview:imageView];
}

-(void)drawTableView{
    tview = [[UITableView alloc] initWithFrame:CGRectMake(0, 142, 320, [[UIScreen mainScreen] bounds].size.height-221) style:UITableViewStyleGrouped];
    [tview setBackgroundColor:[UIColor clearColor]];
    [tview setDelegate:self];
    [tview setDataSource:self];
    [self.view addSubview:tview];
}


-(void)checkisdown{
    for (int i=0; i<13; i++) {
        if([self searchFile:PPTSourcename[i]]){
            isDownload[i]=true;
        }
        else{
            isDownload[i]=false;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 13;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"PPTDownloadTableCell";
    
    PPTDownloadTableCell *cell = (PPTDownloadTableCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell= (PPTDownloadTableCell *)[[[NSBundle  mainBundle]  loadNibNamed:@"PPTDownloadTableCell" owner:self options:nil]  lastObject];
    }
    // 自己的一些设置
    cell.tag=(int)indexPath.row+1;
    
    cell.label.text=PPTindex[indexPath.row];
    
    //利用button传递的tag参数来下载相应的文件
    cell.DownloadButton.tag=(int)indexPath.row+1;
    
    [cell.DownloadButton addTarget:self action:@selector(DownloadButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //根据cell对应的tag设置label的颜色
    NSLog(@"加载第%d个cell",(int)indexPath.row);
    
    if([self searchFile:PPTSourcename[indexPath.row]]){
        cell.isDown=TRUE;
        //如果文件已经下载，就修改BUTTON图案为勾
        cell.label.textColor=[UIColor colorWithRed:79.0f/255.0f green:148.0f/255.0f blue:205.0f/255.0f alpha:1];
        //[cell.DownloadButton setImage:[UIImage imageNamed:@"input-checked"] forState:UIControlStateNormal];
        [cell.DownloadButton setBackgroundImage:[UIImage imageNamed:@"input-checked"] forState:UIControlStateNormal];
        NSLog(@"此文件已下载,%d",(int)indexPath.row);
    }else{
        //如果文件已经下载，就修改BUTTON图案为勾
        cell.isDown=FALSE;
        cell.label.textColor=[UIColor blackColor];
        [cell.DownloadButton setBackgroundImage:[UIImage imageNamed:@"arrow-down-thick"] forState:UIControlStateNormal];
        NSLog(@"此文件未下载,%d",(int)indexPath.row);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)DownloadButtonClick:(id)sender{
    int i = (int)[sender tag];
    PPTDownloadTableCell *thisCell = (PPTDownloadTableCell *)[tview viewWithTag:i];
    //NSLog(@"TAG IS %d",i);
    
    NSLog(@"是否正在下载:%i",isDownloading);
    
    if(thisCell.isDown){
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该章节已下载!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else if(isDowloading) {
            NSLog(@"有文件正在下载中");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"有章节正在下载中，请等待。" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
    } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要进行下载吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
            [alert setTag:i];
            //[alert addButtonWithTitle:@"取消"];
            [alert show];
    }
    
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag==99) {
        if (buttonIndex == 1) {     // and they clicked OK.
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        if (buttonIndex == 1) {     // and they clicked OK.
            [self Download:(int)alertView.tag];
        }
    }
    
}
-(void)Download:(int)i{
    isDowloading=true;
    [self showprogressview];
    [self todownload:[NSString stringWithFormat:@"%@%@",DEFAULTURL,PPTSourcename[i-1]] indexValue:i];
}


-(BOOL)searchFile:(NSString *)Filename{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //该方法可用来显示DOCUMENT文件夹内的文件信息
    NSString *documents = [paths objectAtIndex:0];
    NSString *file_path = [documents stringByAppendingPathComponent:Filename];//获取数据库文件的地址，不存在就会创建
    //NSLog(@"数据库地址是:%@",database_path);
    
    //根据上面拼接好的路径 dbFilePath ，利用NSFileManager 类的对象的fileExistsAtPath方法来检测是否存在，返回一个BOOL值
    //1. 创建NSFileManager对象  NSFileManager包含了文件属性的方法
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //2. 通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
    BOOL isExist = [fm fileExistsAtPath:file_path];
    
    //如果不存在 isExist = NO，提示下载
    if (!isExist)
    {
        return false;
    }else{
        //NSLog(@"%@",Filename);
        return true;
    }
}


-(void)showfiles{
    NSFileManager *fileManager = [NSFileManager defaultManager];
	//在这里获取应用程序Documents文件夹里的文件及文件夹列表
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
	NSString *documentDir = [documentPaths objectAtIndex:0];
    
	NSError *error = nil;
    
    
	NSArray *fileList = [[NSArray alloc] init];
	//fileList便是包含有该文件夹下所有文件的文件名及文件夹名的数组
	fileList = [fileManager contentsOfDirectoryAtPath:documentDir error:&error];
	
	//    以下这段代码则可以列出给定一个文件夹里的所有子文件夹名
	//	NSLog(@"------------------------%@",fileList);
	self.dirArray = [[NSMutableArray alloc] init];
    
    for (NSString *file in fileList)
	{
		[self.dirArray addObject:file];
	}
    NSLog(@"Every Thing in the dir:%@",fileList);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"点击了第%i个section，第%i个选项!",(int)indexPath.section,(int)indexPath.row);
    NSLog(@"加载第%d个文件",(int)indexPath.row);
    if(![self searchFile:PPTSourcename[(int)indexPath.row]]){
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"该章节未下载!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }else{
        
        [self showindicator];
        
        [NSThread detachNewThreadSelector:@selector(gotopreview:) toTarget:self withObject:[NSString stringWithFormat:@"%i",(int)indexPath.row]];
    }
}
-(void)gotopreview:(int)index{
    QLPreviewController *previewController = [[QLPreviewController alloc] init];
    //QLPreviewController *previewController=[self.storyboard instantiateViewControllerWithIdentifier:@"QLPreviewController"];
    previewController.dataSource = self;
    previewController.delegate = self;
    // start previewing the document at the current section index
    previewController.currentPreviewItemIndex = index;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeQuickLookAction:)];
    previewController.navigationItem.leftBarButtonItem = backButton;
    //[self.navigationController pushViewController:previewController animated:YES];
    [activityIndicatorView stopAnimating];
    [transView removeFromSuperview];
    [self presentViewController:previewController animated:YES completion:nil];
}

- (IBAction)closeQuickLookAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showprogressview{
    self.pv=[[UIProgressView alloc]initWithFrame:CGRectMake(20,[[UIScreen mainScreen] bounds].size.height-88,280,30)];
    [self.pv setProgressViewStyle:UIProgressViewStyleDefault]; //设置进度条类型
    [self.view addSubview:self.pv];
}

-(void)showindicator{
    transView=[[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-25, self.view.frame.size.height/2-25, 50, 50)];
    [transView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:0.6]];
    
    //activityIndicatorView = [ [ UIActivityIndicatorView  alloc ] initWithFrame:CGRectMake(self.view.frame.size.width/2-15,self.view.frame.size.height/2-15,30.0,30.0)];
    [activityIndicatorView setFrame:CGRectMake(10,10,30,30)];

    activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    //activityIndicatorView.hidesWhenStopped=NO;
    [transView addSubview:activityIndicatorView];
    //[self.view addSubview:activityIndicatorView];
    [self.view addSubview:transView];
    
    [activityIndicatorView startAnimating];//启动
}


-(void)todownload:(NSString *)url indexValue:(int)i{
    
    LQAsynDownload *dwn = [LQAsynDownload initWithURL:[[NSURL alloc] initWithString:url]];
    
    dwn.initProgress = ^(long long initValue){
        _sum = initValue;
        NSLog(@"%lli",initValue);
        _rcv = 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            self.pv.progress = 0.0;
            self.pv.hidden = NO;
        });
    };
    
    dwn.loadedData = ^(long long loadedLength){
        dispatch_async(dispatch_get_main_queue(), ^{
            _rcv += loadedLength;
            if (self.rcv==self.sum) {
                NSLog(@"已经完成下载!");
                [self complete:i];
                [activityIndicatorView stopAnimating];
                self.pv.hidden = YES;
            }else {
                self.pv.progress=(float)_rcv/_sum;
                //NSLog(@"正在下载,rcv/sum=%lli/%lli",_rcv,_sum);
            }
        });
    };
    
    [dwn startAsyn];
}

-(void)complete:(int)i{
    isDowloading=false;
    PPTDownloadTableCell *thisCell = (PPTDownloadTableCell *)[tview viewWithTag:i];
    NSLog(@"下载完成");
    //下载完后修改BUTTON图案
    [thisCell.DownloadButton setBackgroundImage:[UIImage imageNamed:@"input-checked"] forState:UIControlStateNormal];
    thisCell.isDown=true;
    [thisCell.label setTextColor:[UIColor colorWithRed:79.0f/255.0f green:148.0f/255.0f blue:205.0f/255.0f alpha:1]];
}

#pragma mark - QLPreviewControllerDataSource

// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
	return 1;
}

- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}

// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{

    NSURL *fileURL = nil;
    
    NSIndexPath *selectedIndexPath = [tview indexPathForSelectedRow];
    
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentDir = [documentPaths objectAtIndex:0];
    
	NSString *path = [documentDir stringByAppendingPathComponent:PPTSourcename[selectedIndexPath.row]];
    
	fileURL = [NSURL fileURLWithPath:path];
    
    return fileURL;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end



