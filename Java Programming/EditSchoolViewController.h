//
//  EditSchoolViewController.h
//  Java Programming
//
//  Created by way on 14-7-22.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalDataDB.h"
#import "Personinfo.h"
#import "PersonConnection.h"
typedef enum {
    PROVINCE,
    CITY,
    AREA
} NerveSelectoreType;


@interface EditSchoolViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    NSArray *provinces, *cities, *areas;
    NSString *province, *city, *area;
    
    NSInteger selectType;//当前的选择类型，省，市，区

}

@end
