//
//  WrongprosbookViewController.h
//  Java Programming
//
//  Created by way on 5/21/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Personinfo.h"
#import "Examinfo.h"
#import "ICSColorsViewController.h"
#import "HostViewController.h"
@interface WrongprosbookViewController : UIViewController<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *UIButton;
- (IBAction)UIButton:(id)sender;
@property int choose;
@property int Testsumobj;
@property (weak, nonatomic) IBOutlet UILabel *tips;

@end
