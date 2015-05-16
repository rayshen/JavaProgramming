//
//  RegisterViewController.h
//  Java Programming
//
//  Created by rayshen on 4/13/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>
#import "PersonConnection.h"
#import "TFIndicatorView.h"
@interface RegisterViewController : UIViewController
    <UITextFieldDelegate>
@property NSString *Remail;
@property NSString *Rpassword;
@property NSString *Rpassword2;
@property (weak, nonatomic) IBOutlet UIButton *toregister;

- (IBAction)toregister:(id)sender;


@end
