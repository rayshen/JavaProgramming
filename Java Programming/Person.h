//
//  Person.h
//  Java Programming
//
//  Created by way on 14-7-18.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
{
    @public int iuserid;
    
    //用户主要信息，由updateuser.php完成更新
    @public NSString *iname;
    @public NSString *isex;
    @public NSString *ibirthday;
    @public NSString *imailbox;
    @public NSString *iphonenum;
    @public NSString *ischool;
    @public int icredit;

}
@end
