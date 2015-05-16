//
//  AboutViewController.m
//  Java Programming
//
//  Created by rayshen on 4/14/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initview];
    // Do any additional setup after loading the view.
}

-(void)initview{
    //UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, 640)];
    //[scrollView setContentSize:CGSizeMake(640, 0)];
    //[scrollView setPagingEnabled:YES];  //视图整页显示
    [self.scrollview setFrame:CGRectMake(0, 0, 320, 900)];
    //[self.scrollview setContentSize:CGSizeMake(0, 900)];

    [self.view setBackgroundColor:[UIColor whiteColor]];
    //UITextView *text=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 370, 322, 200)];
    [imageview setImage:[UIImage imageNamed:@"jiaocai"]];
    [self.view addSubview:imageview];
    
    //[self.view addSubview:scrollView];
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
