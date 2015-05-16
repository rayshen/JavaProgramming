//
//  MytestresultsViewController.m
//  Java Programming
//
//  Created by way on 5/21/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "MytestresultsViewController.h"
#import "SHLineGraphView.h"
#import "SHPlot.h"

@interface MytestresultsViewController ()

@end

@implementation MytestresultsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

/*
-(void)inittextview{
    self.itestresults=[Personinfo gettestresults];
    int testsum=(int)[self.itestresults count];
    NSString *labelstring=[[NSString alloc]initWithFormat:@"该用户一共进行过%i次测试\n",testsum];
    for (int i=0; i<[self.itestresults count]; i++) {
        Testresult *thisresult=[self.itestresults objectAtIndex:i];
        NSString *addstring2;
        addstring2=[[NSString alloc]initWithFormat:@"\n#第%i次测试情况：\n",testsum-i];
        labelstring=[labelstring stringByAppendingString:addstring2];
        addstring2=[[NSString alloc]initWithFormat:@"    测试类型：%@\n",thisresult->itesttype];
        labelstring=[labelstring stringByAppendingString:addstring2];
        addstring2=[[NSString alloc]initWithFormat:@"    题目总数：%i\n",thisresult->iprossum];
        labelstring=[labelstring stringByAppendingString:addstring2];
        addstring2=[[NSString alloc]initWithFormat:@"    答对总数：%i\n",thisresult->icrtsum];
        labelstring=[labelstring stringByAppendingString:addstring2];
        addstring2=[[NSString alloc]initWithFormat:@"    正确率：%@\n",thisresult->ipercent];
        labelstring=[labelstring stringByAppendingString:addstring2];
        addstring2=[[NSString alloc]initWithFormat:@"    测试时间：%@\n",thisresult->ifinishtime];
        labelstring=[labelstring stringByAppendingString:addstring2];
    }
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 480)];
    textView.delegate=self;
    textView.text=labelstring;
    textView.font = [UIFont fontWithName:@"Arial"size:15.0];//设置字体名字和字体大小
    [self.view addSubview: textView];

}
*/
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView isFirstResponder]){
        return YES;
    }
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
