//
//  ContentViewController.m
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "ContentViewController.h"
#import "LocalDataDB.h"

@interface ContentViewController ()

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.labelString=[NSString stringWithFormat:@"%i.%@",(int)self.curindex+1,self.Curpro->Ttitle];
    self.label.text=self.labelString;
    
    if(self.Curpro->Ttype==1){
        self.Option1String=[NSString stringWithFormat:@"A.%@",self.Curpro->Toption1];
        self.Option2String=[NSString stringWithFormat:@"B.%@",self.Curpro->Toption2];
        self.Option3String=[NSString stringWithFormat:@"C.%@",self.Curpro->Toption3];
        self.Option4String=[NSString stringWithFormat:@"D.%@",self.Curpro->Toption4];
        [self allocRadioView];
    }else if (self.Curpro->Ttype==2){
        self.Option1String=[NSString stringWithFormat:@"A.%@",self.Curpro->Toption1];
        self.Option2String=[NSString stringWithFormat:@"B.%@",self.Curpro->Toption2];
        self.Option3String=[NSString stringWithFormat:@"C.%@",self.Curpro->Toption3];
        self.Option4String=[NSString stringWithFormat:@"D.%@",self.Curpro->Toption4];

        [self addMultichoose];
    }else if (self.Curpro->Ttype==3){
        [self addJudgechoose];
    }
}

//加载单选视图
-(void) allocRadioView {
    NSMutableArray *sortByItemsArray;

    sortByItemsArray = [[NSMutableArray alloc] init];
    // Setup 1st radio list with 4 items
    [sortByItemsArray addObject:_Option1String];
    [sortByItemsArray addObject:_Option2String];
    [sortByItemsArray addObject:_Option3String];
    [sortByItemsArray addObject:_Option4String];
    
    self.radioViewSortBy.rowItems =  sortByItemsArray;
    self.radioViewSortBy.maxRow =(int) [sortByItemsArray count];
    self.radioViewSortBy.delegate = self;
    self.radioViewSortBy.editable = NO;
    self.radioViewSortBy.tag = 1;
    
    if ([self.Curpro->Chooce isEqualToString:@"A"]) {
        self.radioViewSortBy.optionNo = 0;
    }else if([self.Curpro->Chooce isEqualToString:@"B"]){
        self.radioViewSortBy.optionNo = 1;
    }else if([self.Curpro->Chooce isEqualToString:@"C"]){
        self.radioViewSortBy.optionNo = 2;
    }else if([self.Curpro->Chooce isEqualToString:@"D"]){
        self.radioViewSortBy.optionNo = 3;
    }else{
        self.radioViewSortBy.optionNo = -1;
    }

    if ([self.Curpro->Tanswer isEqualToString:@"A"]) {
        self.radioViewSortBy.answerNo = 0;
    }else if([self.Curpro->Tanswer isEqualToString:@"B"]){
        self.radioViewSortBy.answerNo = 1;
    }else if([self.Curpro->Tanswer isEqualToString:@"C"]){
        self.radioViewSortBy.answerNo = 2;
    }else{
        self.radioViewSortBy.answerNo = 3;
    }

    // set defult optionNo = -1 to select none
}

//加载多选视图
-(void)addMultichoose{
    int y=204;
    
    SSCheckBoxView *cb = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, y, 300, 60) style:kSSCheckBoxViewStyleMono checked:NO];
    [cb setText:_Option1String];
    [cb setTag:1];
    [cb setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    
    SSCheckBoxView *cb2 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, y+60, 300, 60) style:kSSCheckBoxViewStyleMono checked:NO];
    [cb2 setText:_Option2String];
    [cb2 setTag:2];
    [cb2 setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    
    SSCheckBoxView *cb3 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, y+120, 300, 60) style:kSSCheckBoxViewStyleMono checked:NO];
    [cb3 setText:_Option3String];
    [cb3 setTag:3];
    [cb3 setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    
    SSCheckBoxView *cb4 = [[SSCheckBoxView alloc] initWithFrame:CGRectMake(10, y+180, 300, 60) style:kSSCheckBoxViewStyleMono checked:NO];
    [cb4 setText:_Option4String];
    [cb4 setTag:4];
    [cb4 setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    
    if([self.Curpro->Tanswer isEqualToString:@"AB"]){
        cb.isAnwser=true;
        cb2.isAnwser=true;
        
        if ([Examinfo ifisfinish]) {
            [cb setChecked:YES];
            [cb2 setChecked:YES];
        }
    }else if([self.Curpro->Tanswer isEqualToString:@"AC"]){
        cb.isAnwser=true;
        cb3.isAnwser=true;
        
        if ([Examinfo ifisfinish]) {
            [cb setChecked:YES];
            [cb3 setChecked:YES];
        }
        
    }else if([self.Curpro->Tanswer isEqualToString:@"AD"]){
        cb.isAnwser=true;
        cb4.isAnwser=true;
        
        if ([Examinfo ifisfinish]) {
            [cb setChecked:YES];
            [cb4 setChecked:YES];
        }
    }else if([self.Curpro->Tanswer isEqualToString:@"BC"]){
        cb2.isAnwser=true;
        cb3.isAnwser=true;
        
        if ([Examinfo ifisfinish]) {
            [cb2 setChecked:YES];
            [cb3 setChecked:YES];
        }
    }else if([self.Curpro->Tanswer isEqualToString:@"BD"]){
        cb2.isAnwser=true;
        cb4.isAnwser=true;
        
        if ([Examinfo ifisfinish]) {
            [cb2 setChecked:YES];
            [cb4 setChecked:YES];
        }
    }else if([self.Curpro->Tanswer isEqualToString:@"CD"]){
        cb3.isAnwser=true;
        cb4.isAnwser=true;
        
        if ([Examinfo ifisfinish]) {
            [cb3 setChecked:YES];
            [cb4 setChecked:YES];
        }
    }else if([self.Curpro->Tanswer isEqualToString:@"ABC"]){
        cb.isAnwser=true;
        cb2.isAnwser=true;
        cb3.isAnwser=true;

        if ([Examinfo ifisfinish]) {
            [cb setChecked:YES];
            [cb2 setChecked:YES];
            [cb3 setChecked:YES];
        }
    }else if([self.Curpro->Tanswer isEqualToString:@"ABD"]){
        cb.isAnwser=true;
        cb2.isAnwser=true;
        cb4.isAnwser=true;
        
        if ([Examinfo ifisfinish]) {
            [cb setChecked:YES];
            [cb2 setChecked:YES];
            [cb4 setChecked:YES];
        }
    }else if([self.Curpro->Tanswer isEqualToString:@"ACD"]){
        cb.isAnwser=true;
        cb3.isAnwser=true;
        cb4.isAnwser=true;
        
        if ([Examinfo ifisfinish]) {
            [cb setChecked:YES];
            [cb3 setChecked:YES];
            [cb4 setChecked:YES];
        }
    }else if([self.Curpro->Tanswer isEqualToString:@"BCD"]){
        cb2.isAnwser=true;
        cb3.isAnwser=true;
        cb4.isAnwser=true;
        
        if ([Examinfo ifisfinish]) {
            [cb2 setChecked:YES];
            [cb3 setChecked:YES];
            [cb4 setChecked:YES];
        }
    }else if([self.Curpro->Tanswer isEqualToString:@"ABCD"]){
        cb.isAnwser=true;
        cb2.isAnwser=true;
        cb3.isAnwser=true;
        cb4.isAnwser=true;

        if ([Examinfo ifisfinish]) {
            [cb setChecked:YES];
            [cb2 setChecked:YES];
            [cb3 setChecked:YES];
            [cb4 setChecked:YES];
        }
    }
    

    [self.view addSubview:cb];
    [self.view addSubview:cb2];
    [self.view addSubview:cb3];
    [self.view addSubview:cb4];
    
    
}


-(void)addJudgechoose{
    NSMutableArray *sortByItemsArray;
    
    sortByItemsArray = [[NSMutableArray alloc] init];
    // Setup 1st radio list with 4 items
    [sortByItemsArray addObject:@"A.T"];
    [sortByItemsArray addObject:@"B.F"];
    
    self.radioViewSortBy.rowItems =  sortByItemsArray;
    self.radioViewSortBy.maxRow =(int) [sortByItemsArray count];
    self.radioViewSortBy.delegate = self;
    self.radioViewSortBy.editable = NO;
    self.radioViewSortBy.tag = 2;
    
    if ([self.Curpro->Chooce isEqualToString:@"T"]) {
        self.radioViewSortBy.optionNo = 0;
    }else if([self.Curpro->Chooce isEqualToString:@"F"]){
        self.radioViewSortBy.optionNo = 1;
    }else{
        self.radioViewSortBy.optionNo = -1;
    }
    
    if ([self.Curpro->Tanswer isEqualToString:@"T"]) {
        self.radioViewSortBy.answerNo = 0;
    }else if([self.Curpro->Tanswer isEqualToString:@"F"]){
        self.radioViewSortBy.answerNo = 1;
    }
    // set defult optionNo = -1 to select none
}

- (void)viewDidUnload {
    [self setRadioViewSortBy:nil];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//选择选项的监听函数
#pragma mark Radio List Delegate
-(void)radioView:(BGRadioView *)radioView didSelectOption:(int)optionNo{
    if (radioView.tag==1) {
        switch (optionNo) {
            case 0:
                self.Curpro->Chooce=@"A";
                break;
            case 1:
                self.Curpro->Chooce=@"B";
                break;
            case 2:
                self.Curpro->Chooce=@"C";
                break;
            case 3:
                self.Curpro->Chooce=@"D";
                break;
            default:
                break;
        }
    }else if(radioView.tag==2) {
        switch (optionNo) {
            case 0:
                 self.Curpro->Chooce=@"T";
                break;
            case 1:
                 self.Curpro->Chooce=@"F";
                break;
            default:
                break;
        }
    }
    
    [Examinfo setProblem:(int)_curindex setchoose:self.Curpro->Chooce];
    
    
    NSString *proindex=[NSString stringWithFormat:@"%i",(int)_curindex];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:proindex forKey:@"proindex"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changebgc" object:self userInfo:dictionary];

}
//多选按钮组的监听函数
- (void) checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    NSLog(@"第%d个选项的结果被改变成%d",(int)cbv.tag,cbv.checked);
    
    for (SSCheckBoxView *cbv in self.checkboxes) {
        cbv.enabled = !cbv.enabled;
    }
    
    switch (cbv.tag) {
        case 1:
            switch ((int)cbv.checked) {
                case 0:
                    self.chooseA=NO;
                    break;
                case 1:
                    self.chooseA=YES;
                    break;
                default:
                    break;
            }
            break;
        case 2:
            switch ((int)cbv.checked) {
                case 0:
                    self.chooseB=NO;
                    break;
                case 1:
                    self.chooseB=YES;
                    break;
                default:
                    break;
            }
            break;
        case 3:
            switch ((int)cbv.checked) {
                case 0:
                    self.chooseC=NO;
                    break;
                case 1:
                    self.chooseC=YES;
                    break;
                default:
                    break;
            }
            break;
        case 4:
            switch ((int)cbv.checked) {
                case 0:
                    self.chooseD=NO;
                    break;
                case 1:
                    self.chooseD=YES;
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    self.Curpro->Chooce=@"";
    //通过选项对所答答案进行设置，默认为NoAnswer
    if (self.chooseA) {
        self.Curpro->Chooce=@"A";
    }
    if (self.chooseB){
        self.Curpro->Chooce=[self.Curpro->Chooce stringByAppendingString:@"B"];
    }
    if (self.chooseC){
        self.Curpro->Chooce=[self.Curpro->Chooce stringByAppendingString:@"C"];
    }
    if (self.chooseD){
        self.Curpro->Chooce=[self.Curpro->Chooce stringByAppendingString:@"D"];
    }
    
    [Examinfo setProblem:(int)_curindex setchoose:self.Curpro->Chooce];
        
    NSString *proindex=[NSString stringWithFormat:@"%i",(int)_curindex];
    NSDictionary *dictionary = [NSDictionary dictionaryWithObject:proindex forKey:@"proindex"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changebgc" object:self userInfo:dictionary];
}

@end
