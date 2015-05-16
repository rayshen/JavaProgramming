//
//  Personinfo.h
//  Java Programming
//
//  Created by rayshen on 4/30/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonConnection.h"
#import "LocalDataDB.h"
static NSMutableArray *person;
/*
运行逻辑为：

    下载数据： 数据库---PersonConnection类--->Personinfo类变量-->其他类调用
    更新数据： 其他类---Personinfo类函数--->1.更新自身变量--PersonConnection类->更新数据库
*/
static int iuserid;
static NSString *iaccount;
static NSString *ipassword;

//用户主要信息，由updateuser.php完成更新
static NSString *iname;
static NSString *isex;
static NSString *ibirthday;
static NSString *imailbox;
static NSString *iphonenum;
static NSString *ischool;
static NSString *icredit;

static int iUnivID;

static BOOL isDownloading;
//用户使用信息，分别为收藏、错题和做题记录
static NSMutableArray *icollection;
static NSMutableArray *ididwrong;
static NSMutableArray *itestresults;

@interface Personinfo : NSObject
//用户信息----变量操作函数
+(void)initperson:(int)userid valueofaccount:(NSString *)account valueofname:(NSString *)name valueofemail:(NSString *)mailbox valueofsex:(NSString *)sex valueofunivID:(int)UnivID valueofpsw:(NSString *)psw valurofpnum:(NSString *)phonenum;

+(void)setiaccount:(NSString *)account;
+(void)setimailbox:(NSString *)email;
+(void)setipassword:(NSString *)psw;

+(void)setiname:(NSString *)name;
+(void)setipnum:(NSString *)pnum;
+(void)setisex:(NSString *)sex;
+(void)setischool:(NSString *)school;
+(void)setUnivID:(int)UnivID;
+(void)setiuserid:(int)userid;

+(int)getid;
+(NSString *)getaccount;
+(NSString *)getname;
+(NSString *)getsex;
+(NSString *)getemail;
+(NSString *)getpassword;
+(NSString *)getpnum;
+(NSString *)getschool;
+(int)getUnivID;
//用户信息----数据库操作
+(void)updatepersoninfo;


//关于收藏夹功能的函数
+(void)initcollection;
+(void)addcollect:(NSString *)pronum;
+(BOOL)removecollect:(NSString *)pronum;
+(BOOL)checkproisCollect:(int)proid;
+(NSMutableArray *)getcollection;
//关于错题本功能的函数
+(void)initwrongpros;
+(void)addwrongpro:(NSString *)pronum;
+(BOOL)checkandremove:(int)proid;
+(BOOL)removewrongpro:(NSString *)pronum;
+(BOOL)checkproiswrong:(int)proid;
+(NSMutableArray *)getwrongpros;
//关于历史成绩
+(void)inittestresults;
+(NSMutableArray *)gettestresults;
//==========
/*
+(void)setisDownloading:(BOOL)YorN;
+(BOOL)ifisDownloading;
*/
@end
