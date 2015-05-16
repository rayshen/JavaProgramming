//
//  PersonDB.h
//  Java Programming
//
//  Created by rayshen on 5/11/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Personinfo.h"
#import "Testresult.h"
#import "Person.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access


//默认服务器主机IP（WWW根目录）
//#define HOSTIP      @"rayshen.vipsinaapp.com"
//#define HOSTIP      @"localhost"
#define HOSTIP      @"www.java.zjut.edu.cn/Mobilescript"

//默认PPT下载URL地址（到文件夹）
//#define DEFAULTURL @"http://localhost/zjut_java_ios/ppt/"
//#define DEFAULTURL @"http://rayshen.net/zjut_java_ios/ppt/"
#define DEFAULTURL @"http://www.java.zjut.edu.cn/Mobilescript/ppt/"


@interface PersonConnection : NSObject <NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    NSMutableData *connectionData;
}

@property (nonatomic,retain) NSMutableData *connectionData;

+(BOOL)checkConnect;
//============================================================
+(BOOL)checkPerson:(NSString *)email valueofpsw:(NSString *)psw;
+(void)setPerson:(NSString *)email valueofpsw:(NSString *)psw;
+(BOOL)checkPersonwithemail:(NSString *)email;
+(BOOL)insertNewuser:(NSString *)email valueofpsw:(NSString *)psw;
+(BOOL)editinfo:(int)userid valueofname:(NSString *)name valueofsex:(NSString *)sex valueofunivID:(int)UnivID valueofpnum:(NSString *)pnum;
//============================================================
+(NSMutableArray *)initcollection:(int)userid;
+(BOOL)insertcollection:(int)userid valueofproid:(int)proid;
+(BOOL)deletecollection:(int)userid valueofproid:(int)proid;
//============================================================
+(NSMutableArray *)initwrongprosbook:(int)userid;
+(BOOL)insertwrongpro:(int)userid valueofproid:(int)proid;
+(BOOL)deletewrongpro:(int)userid valueofproid:(int)proid;
//============================================================
+(NSMutableArray *)inittestresult:(int)userid;
+(int)insettestresult:(Testresult *)newtestresult;
+(BOOL)insertpro:(NSMutableArray *)proset;
//============================================================
+(BOOL)addCredit:(int)userid valueofnum:(int)num;
+(NSMutableArray *)getCredit:(int)userid;
//============================================================
+(void)loginwithQRcode:(NSString *)url;
@end
