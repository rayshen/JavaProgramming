//
//  TestDB.h
//  Java Programming
//
//  Created by rayshen on 4/26/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "Testproblem.h"
#import "Examinfo.h"
@interface LocalDataDB : NSObject
{
    //本地sqlite数据库的路径和名字
    sqlite3 *db;
    NSString *database_path;
}
-(void)createDB;
//有关题目信息的接口==================
-(NSMutableArray *)selectTypePro:(BOOL)single valueofmulti:(BOOL)multi valueofjudge:(BOOL)judge;
-(NSMutableArray *)selectTypePro2:(BOOL)single valueofmulti:(BOOL)multi valueofjudge:(BOOL)judge;

-(Testproblem *)selectPro:(int)thisQuestionID;
-(int)countForPro;
//有关学校信息的接口===============
-(NSString *)selectSchool:(int)UnivID;
-(NSArray *)selectProvincelist;
-(NSArray *)selectCitylist:(NSString *)province;
-(NSArray *)selectSchoollist:(NSString *)city;
-(int)selectUnivID:(NSString *)Univname;
@end
