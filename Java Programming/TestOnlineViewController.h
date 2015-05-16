//
//  TestOnlineViewController.h
//  Java Programming
//
//  Created by way on 14-6-27.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Examinfo.h"
#import "ICSColorsViewController.h"
#import "HostViewController.h"
#import "SSCheckBoxView.h"
@interface TestOnlineViewController : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *UIControl;
- (IBAction)UIControl:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *UIButton;
- (IBAction)UIButton:(id)sender;
@property int choose;
@property int Testsumobj;


@property (nonatomic, retain) NSMutableArray *checkboxes;

-(void)checkBoxViewChangedState:(SSCheckBoxView*)cbv;

@property (weak, nonatomic) IBOutlet UILabel *tips;

@end
