//
//  WrongprosbookViewController.m
//  Java Programming
//
//  Created by way on 5/21/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "WrongprosbookViewController.h"

@interface WrongprosbookViewController ()
@property NSMutableArray *wrongprosbook;

@end

@implementation WrongprosbookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tips.text=[Examinfo gettips];

    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"exambg2.png"]]];

}
-(void)viewWillAppear:(BOOL)animated{
    self.wrongprosbook=[Personinfo getwrongpros];
    self.Testsumobj=(int)[self.wrongprosbook count];
    [self inittextview];
}


-(void)inittextview{
   // NSString *labelstring=[[NSString alloc]initWithFormat:@"该用户一共做错过%i题\n\n",(int)[self.wrongprosbook count]];
    NSLog(@"该用户一共错误了%i题",(int)[self.wrongprosbook count]);
    for (int i=0; i<[self.wrongprosbook count]; i++) {
        //NSString *addstring2=[[NSString alloc]initWithFormat:@"该用户做错过第%i题\n",(int)[[self.wrongprosbook objectAtIndex:i] intValue]];
        //labelstring=[labelstring stringByAppendingString:addstring2];
        NSLog(@"该用户错误了第%i题",(int)[[self.wrongprosbook objectAtIndex:i] intValue]);
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
}



- (IBAction)UIButton:(id)sender {
    if (self.Testsumobj==0) {
        UIAlertView *alert;
        alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有作错过题目呢!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    } else {
    //NSLog(@"一共错误了%d题",(int)self.Testsumobj);
    [Examinfo setsumObj:self.Testsumobj];
    [Examinfo setexamType:4];
    
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
