//
//  MycollectionViewController.m
//  Java Programming
//
//  Created by way on 5/19/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "MycollectionViewController.h"

@interface MycollectionViewController ()

@property NSMutableArray *mycollection;

@end

@implementation MycollectionViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tips.text=[Examinfo gettips];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"exambg3.png"]]];
}

-(void)viewWillAppear:(BOOL)animated{
    self.mycollection=[Personinfo getcollection];
    self.Testsumobj=(int)[self.mycollection count];
    [self inittextview];
    
}

-(void)inittextview{
    //NSString *labelstring=[[NSString alloc]initWithFormat:@"该用户一共收藏了%i题\n\n",(int)[self.mycollection count]];
    NSLog(@"该用户一共收藏了%i题",(int)[self.mycollection count]);
    for (int i=0; i<[self.mycollection count]; i++) {
        //NSString *addstring2=[[NSString alloc]initWithFormat:@"该用户收藏了第%i题\n",(int)[[self.mycollection objectAtIndex:i] intValue]];
        //labelstring=[labelstring stringByAppendingString:addstring2];
        NSLog(@"该用户收藏了第%i题",(int)[[self.mycollection objectAtIndex:i] intValue]);
    }
    
    //UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 280, 480)];
    //textView.delegate=self;
    //textView.text=labelstring;
    //[self.view addSubview: textView];
    
}

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


- (IBAction)UIButton:(id)sender {
    if (self.Testsumobj==0) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有收藏过题目呢!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
        NSLog(@"一共收藏了%d题",(int)self.Testsumobj);
        [Examinfo setsumObj:self.Testsumobj];
        [Examinfo setexamType:5];
    
        ICSColorsViewController *colorsVC = [[ICSColorsViewController alloc] init];
    
        HostViewController *host = [self.storyboard instantiateViewControllerWithIdentifier:@"HostViewController"];
    
        ICSDrawerController *drawer=[self.storyboard instantiateViewControllerWithIdentifier:@"ICSDrawerController"];
    
        drawer = [[ICSDrawerController alloc] initWithLeftViewController:colorsVC centerViewController:host];
    
        colorsVC.leftdelegate=host;
    
        drawer.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
        [self presentViewController:drawer animated:YES completion:nil];
    }
}
@end
