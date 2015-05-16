//
//  Personinfo.m
//  Java Programming
//
//  Created by rayshen on 4/30/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "Personinfo.h"

@implementation Personinfo
//用户信息操作函数==========================================================
+(void)initperson:(int)userid valueofaccount:(NSString *)account valueofname:(NSString *)name valueofemail:(NSString *)mailbox valueofsex:(NSString *)sex valueofunivID:(int)UnivID valueofpsw:(NSString *)psw valurofpnum:(NSString *)phonenum{
    iuserid=userid;
    iaccount=account;
    iname=name;
    imailbox=mailbox;
    isex=sex;
    iUnivID=UnivID;
    ipassword=psw;
    iphonenum=phonenum;

    LocalDataDB *newDB=[[LocalDataDB alloc]init];
    [newDB createDB];
    [Personinfo setischool:[newDB selectSchool:UnivID]];
}

+(int)getid{
    return iuserid;
}
+(NSString *)getaccount{
    return iaccount;
}
+(NSString *)getemail{
    return imailbox;
}
+(NSString *)getname{
    return iname;
}
+(NSString *)getpassword{
    return ipassword;
}
+(NSString *)getsex{
    return isex;
}
+(NSString *)getpnum{
    return iphonenum;
}
+(NSString *)getschool{
    return ischool;
}
+(int)getUnivID{
    return iUnivID;
}
//========================================================================
+(void)setiuserid:(int)userid{
    iuserid=userid;
}
+(void)setiaccount:(NSString *)account{
    iaccount=account;
}
+(void)setiname:(NSString *)name{
    iname=name;
}
+(void)setimailbox:(NSString *)email{
    imailbox=email;
}
+(void)setipassword:(NSString *)psw{
    ipassword=psw;
}
+(void)setipnum:(NSString *)pnum{
    iphonenum=pnum;
}
+(void)setisex:(NSString *)sex{
    isex=sex;
}
+(void)setischool:(NSString *)school{
    ischool=school;
}
+(void)setUnivID:(int)UnivID{
    iUnivID=UnivID;
}

//收藏夹功能函数============================================================
+(void)initcollection{
    icollection=[PersonConnection initcollection:iuserid];
}
+(BOOL)checkproisCollect:(int)proid{
    //NSLog(@"该用户，一共收藏的题目数：%i",(int)[icollection count]);
    
    for (int i=0; i<[icollection count]; i++) {
        //NSLog(@"收藏了第%i题",[[icollection objectAtIndex:i] intValue]);
        if (proid==[[icollection objectAtIndex:i] intValue]) {
            return true;
        }
    }
    return false;
}
+(void)addcollect:(NSString *)pronum{
    [icollection addObject:pronum];
    [PersonConnection insertcollection:iuserid valueofproid:[pronum intValue]];
}
+(BOOL)removecollect:(NSString *)pronum{
    for (int i=0; i<[icollection count]; i++) {
        if ([pronum isEqualToString:[icollection objectAtIndex:i]]) {
            [icollection removeObjectAtIndex:i];
            [PersonConnection deletecollection:iuserid valueofproid:[pronum intValue] ];
            return true;
        }
    }
    return false;
}
+(NSMutableArray *)getcollection{
    return icollection;
}
//========================================================================
+(void)updatepersoninfo{
    [PersonConnection editinfo:iuserid valueofname:iname valueofsex:isex valueofunivID:iUnivID valueofpnum:iphonenum];
}
//错题本功能================================================================
+(void)initwrongpros{
    ididwrong=[PersonConnection initwrongprosbook:iuserid];
}
+(BOOL)checkandremove:(int)proid{
    NSLog(@"该用户，一共错误的题目数：%i",(int)[ididwrong count]);
    
    for (int i=0; i<[ididwrong count]; i++) {

        if (proid==[[ididwrong objectAtIndex:i] intValue]) {
            [ididwrong removeObjectAtIndex:i];
            [PersonConnection deletewrongpro:iuserid valueofproid:proid];
            return true;
        }
    }
    return false;
}
+(BOOL)checkproiswrong:(int)proid{
    NSLog(@"该用户，一共错误的题目数：%i",(int)[ididwrong count]);
    
    for (int i=0; i<[ididwrong count]; i++) {
        //NSLog(@"错误了第%i题",[[icollection objectAtIndex:i] intValue]);
        if (proid!=0&&proid==[[ididwrong objectAtIndex:i] intValue]) {
            return true;
        }
    }
    return false;
}
+(void)addwrongpro:(NSString *)pronum{
    [ididwrong addObject:pronum];
    [PersonConnection insertwrongpro:iuserid valueofproid:[pronum intValue]];
}

+(NSMutableArray *)getwrongpros{
    return ididwrong;
}
//================================================================
+(void)inittestresults{
    itestresults=[PersonConnection inittestresult:iuserid];
}
+(NSMutableArray *)gettestresults{
    return itestresults;
}
//=======================
/*
+(void)setisDownloading:(BOOL)YorN{
    isDownloading=YorN;
}
+(BOOL)ifisDownloading{
    return isDownloading;
}
*/
@end


