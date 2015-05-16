//
//  EditinfoViewController.h
//  Java Programming
//
//  Created by rayshen on 5/13/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PersonConnection.h"
#import "Personinfo.h"
#import "LocalDataDB.h"
@interface EditinfoViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property int edittype;
@property NSString *editkey;
@property UITextField *textfield;
@property NSString *editvalue;


@end
