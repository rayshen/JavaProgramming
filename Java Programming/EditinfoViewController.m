//
//  EditinfoViewController.m
//  Java Programming
//
//  Created by rayshen on 5/13/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "EditinfoViewController.h"

@interface EditinfoViewController ()

@end

@implementation EditinfoViewController

UITableView *tview;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initappear];
}

-(void)initappear{
    [self.view setBackgroundColor:[UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1]];
    
    
    switch (self.edittype) {
        case 1:
            [self addtextfield];
            [self addbutton];
            break;
        case 2:
            break;
        case 3:
            [self addsexchoose];
            break;
        default:
            break;
    }
    
}

-(void)addbutton{
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain
                                                                      target:self action:@selector(cancel:)];
    self.navigationItem.leftBarButtonItem = leftButtonItem;
  
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain
                                                                       target:self action:@selector(save:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;

}

-(void)addtextfield{
    self.textfield=[[UITextField alloc]initWithFrame:CGRectMake(0, 22, 320, 44)];
    self.textfield.backgroundColor=[UIColor whiteColor];
    self.textfield.borderStyle=3;
    self.textfield.text=self.editvalue;

    [self.view addSubview:self.textfield];
}
/*
-(void)addlongtestfield{
    self.textfield=[[UITextField alloc]initWithFrame:CGRectMake(0, 22, 270, 44)];
    self.textfield.backgroundColor=[UIColor whiteColor];
    self.textfield.text=self.editvalue;
    
    [self.view addSubview:self.textfield];
}
*/

-(void)addsexchoose{
    tview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 110) style:UITableViewStylePlain];
    tview.bounces=NO;
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
    if([self.editkey isEqualToString:@"sex"]){
        return 2;
    }else{
        return 0;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        switch ([indexPath row]) {
            case 0:
                cell.textLabel.text=@"男生";
                break;
            default:
                cell.textLabel.text=@"女生";
                break;
        }
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *thisCell = (UITableViewCell *)[tview viewWithTag:indexPath.row];
    thisCell.backgroundColor=[UIColor blueColor];
    if ([self.editkey isEqualToString:@"sex"]) {
        if (indexPath.row==0) {
            self.editvalue=@"男";
        }else{
            self.editvalue=@"女";
        }
        [Personinfo setisex:self.editvalue];
        //更新数据库的信息
        [NSThread detachNewThreadSelector:@selector(updateDBinfo) toTarget:self withObject:nil];
        [self.navigationController popViewControllerAnimated:YES];
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

- (void)cancel:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender{
    if ([self.editkey isEqualToString:@"name"]) {
        self.editvalue=self.textfield.text;
        NSLog(@"修改了名字,%@",self.editvalue);
        [Personinfo setiname:self.editvalue];
    }else if([self.editkey isEqualToString:@"phonenum"]){
        self.editvalue=self.textfield.text;
        [Personinfo setipnum:self.editvalue];
    }
    //更新数据库的信息
    [NSThread detachNewThreadSelector:@selector(updateDBinfo) toTarget:self withObject:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)updateDBinfo{
    [Personinfo updatepersoninfo];
}

//[self setUpForDismissKeyboard];
/*
 //有关键盘的设置==============
 - (void)setUpForDismissKeyboard {
 
 NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
 UITapGestureRecognizer *singleTapGR =
 [[UITapGestureRecognizer alloc] initWithTarget:self
 action:@selector(tapAnywhereToDismissKeyboard:)];
 NSOperationQueue *mainQuene =[NSOperationQueue mainQueue];
 [nc addObserverForName:UIKeyboardWillShowNotification
 object:nil
 queue:mainQuene
 usingBlock:^(NSNotification *note){
 [self.view addGestureRecognizer:singleTapGR];
 }];
 [nc addObserverForName:UIKeyboardWillHideNotification
 object:nil
 queue:mainQuene
 usingBlock:^(NSNotification *note){
 [self.view removeGestureRecognizer:singleTapGR];
 }];
 }
 
 - (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
 //此method会将self.view里所有的subview的first responder都resign掉
 [self.view endEditing:YES];
 
 }
 */
@end
