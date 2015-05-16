//
//  ContentViewController.h
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BGRadioView.h"
#import "Examinfo.h"
#import "Testproblem.h"
#import "SSCheckBoxView.h"

@interface ContentViewController :UIViewController<BGRadioViewDelegate>

@property Testproblem *Curpro;

@property NSString *labelString;

@property NSString *Option1String;
@property NSString *Option2String;
@property NSString *Option3String;
@property NSString *Option4String;
@property NSInteger curindex;

@property BOOL chooseA;
@property BOOL chooseB;
@property BOOL chooseC;
@property BOOL chooseD;

@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet BGRadioView *radioViewSortBy;


@property (nonatomic, retain) NSMutableArray *checkboxes;

-(void)checkBoxViewChangedState:(SSCheckBoxView*)cbv;

@end
