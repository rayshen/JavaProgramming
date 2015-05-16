//
//  ScrollViewController.h
//  Java Programming
//
//  Created by rayshen on 4/13/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "indexNavViewController.h"
#import "Personinfo.h"
#import "PersonConnection.h"
#import "RegisterViewController.h"
#import "TFIndicatorView.h"

@interface LoginViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;
- (IBAction)loginbtn:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *toRegister;
- (IBAction)toRegister:(id)sender;

@end
