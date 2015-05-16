//
//  MyinfoViewController.m
//  Java Programming
//
//  Created by rayshen on 5/12/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "MyinfoViewController.h"
#import "PicCollectionCell.h"
@interface MyinfoViewController ()


@end

@implementation MyinfoViewController

UITableView *tview;

UICollectionView *cv;

UIButton *closebutton;

UIView *transView;

BOOL flagShuaxin;

UIActivityIndicatorView* activityIndicatorView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSString *testStr = [defaults objectForKey:@"NSusername"];
    //NSLog(@"NSusername is: %@",testStr);
    
    if ([[UIScreen mainScreen] bounds].size.height==480) {
        [self.TXimgView setFrame:CGRectMake(0,88, 320, 130)];
    }else{
        [self.TXimgView setFrame:CGRectMake(0,0, 320, 130)];
    }
    
    
    self.TXimgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addCollectionview)];
    [self.TXimgView addGestureRecognizer:singleTap1];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *txtype;
    if ([defaults objectForKey:@"NSTXtype"]==NULL) {
        txtype=@"tx1";
    } else {
        txtype=[defaults objectForKey:@"NSTXtype"];
    }
    self.TXimgView.image=[UIImage imageNamed:txtype];
}

-(void)viewWillAppear:(BOOL)animated{
    [self initappear];
    //NSLog(@"%d",[Personinfo getUnivID]);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSLog(@"%d",[[defaults objectForKey:@"NSuserid"] intValue]);
    NSLog(@"%@",[defaults objectForKey:@"NSuseremail"]);
    NSLog(@"%@",[defaults objectForKey:@"NSusername"]);
    NSLog(@"%@",[defaults objectForKey:@"NSusersex"]);
    NSLog(@"%@",[defaults objectForKey:@"NSuserschool"]);
    NSLog(@"%@",[defaults objectForKey:@"NSuserpnum"]);

}

-(void)initappear{
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self drawTableView];
    
    //[self addCollectionview];
}

-(void)addCloseButton{
    closebutton=[[UIButton alloc]initWithFrame:CGRectMake(0, 65, 30, 30)];
    [closebutton setBackgroundColor:[UIColor colorWithRed:200.0f/255.0f green:200.0f/255.0f blue:200.0f/255.0f alpha:0.6]];
    
    [closebutton setTitle: @"X" forState: UIControlStateNormal];
    /*
     UILabel *datelabel=[[UILabel alloc]init];
     datelabel.text=@"日历";
     [calendarbutton addSubview:datelabel];
     */
    //[calendarbutton setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    
    [closebutton addTarget:self action:@selector(closetxview) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view insertSubview:closebutton aboveSubview:cv];

}

-(void)addCollectionview{
    //self.view.userInteractionEnabled = NO;
    
    transView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 578)];
    
    [transView setBackgroundColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:0.6]];
    
    [self.view addSubview:transView];
    
    //添加手势，点击屏幕其他区域关闭日历的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closetxview)];
    
    [transView addGestureRecognizer:gesture];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    [flowLayout setItemSize:CGSizeMake(225, 110)];//设置cell的尺寸
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];//设置其布局方向
    
    cv=[[UICollectionView alloc]initWithFrame:CGRectMake(15,80,290,315) collectionViewLayout:flowLayout];
    
    [cv registerClass:[PicCollectionCell class] forCellWithReuseIdentifier:@"PicCollectionCell"];
    
    [cv setBackgroundColor:[UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:0.75]];
    cv.delegate=self;
    cv.dataSource=self;
    [self.view insertSubview:cv aboveSubview:transView];
    
    //[self addCloseButton];
}

-(void)closetxview{
    
    //[closebutton removeFromSuperview];
    
    [cv removeFromSuperview];
    
    [transView removeFromSuperview];
    
    //self.view.userInteractionEnabled = YES;

}

//设置index界面的ITEM个数，文字和图片===========================================
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 8;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PicCollectionCell *cell = (PicCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PicCollectionCell" forIndexPath:indexPath];
    
    //图片名称
    NSString *imageToLoad = [NSString stringWithFormat:@"tx%i.png", (int)indexPath.row];
    //加载图片
    cell.imageView.image = [UIImage imageNamed:imageToLoad];
    
    return cell;
}
//===========================================================================


//collectionView的点击接口函数实现=============================================
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell #%ld was selected", indexPath.row);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *txtype=[NSString stringWithFormat:@"tx%ld",indexPath.row];
    [defaults setObject:[NSString stringWithFormat:@"tx%ld",indexPath.row] forKey:@"NSTXtype"];
    
    [defaults synchronize];
    
    self.TXimgView.image=[UIImage imageNamed:txtype];

    [closebutton removeFromSuperview];

    [collectionView removeFromSuperview];
    
    [transView removeFromSuperview];

    return;
}


-(void)drawTableView{
    tview = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, 320, [[UIScreen mainScreen] bounds].size.height-174) style:UITableViewStyleGrouped];
    [tview setDelegate:self];
    [tview setDataSource:self];
    [self.view addSubview:tview];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        default:
            return 0;
            break;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //NSLog(@"信息重载");
    int section = (int)indexPath.section;
    int row = (int)indexPath.row;
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch (section) {
            case 0:
                switch (row) {
                    case 0:
                        cell.accessoryType =UITableViewCellAccessoryNone;
                        cell.textLabel.text =  @"全宇宙唯一のID";
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.detailTextLabel.text =[NSString stringWithFormat:@"%i",[Personinfo getid]];
                        break;
                    case 1:
                        cell.textLabel.text = @"名字";
                        //NSLog(@"mingzi shi ：%@",[Personinfo getname]);
                        if ([[Personinfo getname] isEqualToString:@""]){
                            //cell.detailTextLabel.text=@"未填写";
                        }else{
                            cell.detailTextLabel.text=[Personinfo getname];
                        }
                        break;
                    case 2:
                        //cell.textLabel.text =  @"个性签名";
                        break;
                    default:
                        break;
                }
                break;
            case 1:
                switch (row) {
                    case 0:
                        cell.textLabel.text =  @"性别";
                        if ([[Personinfo getsex] isEqualToString:@""]) {
                            //cell.detailTextLabel.text=@"未填写";
                        } else {
                            cell.detailTextLabel.text=[Personinfo getsex];
                        }
                        break;
                    case 1:
                        cell.textLabel.text =  @"学校";
                        if ([Personinfo getschool]==NULL) {
                            //cell.detailTextLabel.text=@"未填写";

                        } else {
                            cell.detailTextLabel.text=[Personinfo getschool];

                        }
                        break;
                    default:
                        break;
                }
                break;
            case 2:
                switch (row) {
                    case 0:
                        cell.textLabel.text =  @"联系电话";
                        if ([[Personinfo getpnum] isEqualToString:@""]) {
                            //cell.detailTextLabel.text=@"未填写";
                        } else {
                            cell.detailTextLabel.text=[Personinfo getpnum];

                        }
                        break;
                    case 1:
                        cell.accessoryType =UITableViewCellAccessoryNone;
                        cell.selectionStyle = UITableViewCellSelectionStyleNone;
                        cell.textLabel.text =  @"登录邮箱";
                        cell.detailTextLabel.text=[Personinfo getemail];
                        break;
                    }
                break;
            default:
                break;
        }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了第%i个section，第%i个选项!",(int)indexPath.section,(int)indexPath.row);
    EditinfoViewController *editinfo=[self.storyboard instantiateViewControllerWithIdentifier:@"EditinfoViewController"];
    
    EditSchoolViewController *editschool=[[EditSchoolViewController alloc]init];
    switch ((int)indexPath.section) {
        case 0:
            switch ((int)indexPath.row) {
                case 0:
                    //editinfo.editvalue=[NSString stringWithFormat:@"%i",[Personinfo getid]];
                    break;
                case 1:
                    editinfo.edittype=1; //修改string：名字
                    editinfo.editkey=@"name";
                    editinfo.editvalue=[Personinfo getname];
                    [self.navigationController pushViewController:editinfo animated:YES];
                    break;
                case 2:
                    editinfo.edittype=2; //更改个性签名
                    editinfo.editkey=@"introduce";
                    [self.navigationController pushViewController:editinfo animated:YES];
                default:
                    break;
            }
            break;
        case 1:
            switch ((int)indexPath.row) {
                case 0:
                    editinfo.edittype=3; //性别选择
                    editinfo.editkey=@"sex";
                    editinfo.editvalue=[Personinfo getsex];
                    [self.navigationController pushViewController:editinfo animated:YES];
                    break;
                case 1:
            
                    [self.navigationController pushViewController:editschool animated:YES];
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch ((int)indexPath.row) {
                case 0:
                    editinfo.edittype=1;//修改string：电话
                    editinfo.editkey=@"phonenum";
                    editinfo.editvalue=[Personinfo getpnum];

                    [self.navigationController pushViewController:editinfo animated:YES];
                    break;
                case 1:
                    //editinfo.edittype=1;
                    //editinfo.editkey=@"email";
                    //editinfo.editvalue=[Personinfo getemail];
                    //[self.navigationController pushViewController:editinfo animated:YES];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //康海涛测试Ok的
    CGPoint offset1 = scrollView.contentOffset;
    CGRect bounds1 = scrollView.bounds;
    CGSize size1 = scrollView.contentSize;
    UIEdgeInsets inset1 = scrollView.contentInset;
    float y1 = offset1.y + bounds1.size.height - inset1.bottom;
    float h1 = size1.height;
    //NSLog(@"%f----%f---%f",y1,h1,tview.frame.size.height);
    if (y1 > tview.frame.size.height) {
        flagShuaxin = YES;
    }
    else if (y1 < tview.frame.size.height) {
        flagShuaxin = NO;
    }
    else if (y1 == tview.frame.size.height) {
        if (!flagShuaxin) {
            NSLog(@"下拉刷新");
            [self showindicatior];
            [NSThread detachNewThreadSelector:@selector(refreshuserinfo) toTarget:self withObject:nil];
        }
    }
}

-(void)showindicatior{
    activityIndicatorView = [ [ UIActivityIndicatorView  alloc ] initWithFrame:CGRectMake(270,25,30.0,30.0)];
    activityIndicatorView.activityIndicatorViewStyle= UIActivityIndicatorViewStyleGray;
    //activityIndicatorView.hidesWhenStopped=NO;
    [self.navigationController.view addSubview:activityIndicatorView];
    //[self.view addSubview:activityIndicatorView];
    [activityIndicatorView startAnimating];//菊花启动
}

-(void)refreshuserinfo{
    if(![PersonConnection checkConnect]){
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"网络连接有问题!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
        
    }else{
        [PersonConnection setPerson:[Personinfo getemail] valueofpsw:[Personinfo getpassword]];
    }
    [activityIndicatorView stopAnimating];
    [tview reloadData];
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


@end
