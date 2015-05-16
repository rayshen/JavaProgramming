//
//  HostViewController.h
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"
#import "ContentViewController.h"
#import "IOSTimeLabel.h"
#import "ICSDrawerController.h"
#import "ICSColorsViewController.h"

@protocol Hostdelegate <NSObject>

-(void)setprodid:(int)proindex;

@end


@interface HostViewController : ViewPagerController  <UITabBarDelegate,MZTimerLabelDelegate,ICSDrawerControllerChild, ICSDrawerControllerPresenting,leftdelegate>


@property int curindex;

@property(nonatomic, weak) ICSDrawerController *drawer;

@property (weak, nonatomic) IBOutlet UILabel *Timelabel;


@property (weak, nonatomic) IBOutlet UITabBar *Tabbar;

@property (weak, nonatomic) IBOutlet UITabBarItem *preitem;

@property (weak, nonatomic) IBOutlet UITabBarItem *item2;

@property (weak, nonatomic) IBOutlet UITabBarItem *jumpitem;
@property (weak, nonatomic) IBOutlet UITabBarItem *collectitem;

@property (weak, nonatomic) IBOutlet UITabBarItem *nextitem;

@property (weak, nonatomic) IBOutlet UIButton *FinishTest;

-(void)finishExam;

- (IBAction)FinishTest:(id)sender;

- (IBAction)clickmenu:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *clickmenu;


- (void)Gotopre;
- (void)Gotonext;
- (void)Jumpto;

@end






