//
//  Testexam.h
//  Java Programming
//
//  Created by rayshen on 5/5/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalDataDB.h"
#import "Testproblem.h"
#import "Personinfo.h"
#import "Testresult.h"
static  NSMutableArray *Problemset;


static BOOL isfinish;

static int DBsumObj;
static int Prosetsumobj;
static int sumObj;
//以下两个type变量均用作为测试类型：如不同题量随机、收藏夹、错题
static NSString *testtype;
static int examType;

//================
static int TestID;
//此次测试的单多选题型情况
static NSString *testkindType;

NSString *starttime;
NSString *finishtime;
//以下为选择题类型：单选多选和判断
static BOOL Single;
static BOOL Multi;
static BOOL Judge;

static NSString *tips[8]={
    @"小贴士：我们的征途是星辰大海 Y^o^Y ",
    @"小贴士：错题集中的题目重新作对就会自动消失哦~",
    @"小贴士：在任何答题界面都可以把经典的题目添加到收藏夹~",
    @"小贴士：模拟40题测试会提交到云端哦~你还可以在网站上查询详细的答题记录",
    @"小贴士：学习曲线能很好的帮助你掌握自己的学习情况",
    @"小贴士：扫一扫二维码登录的功能你玩过了嘛？还挺好玩的吧",
    @"小贴士：如果你是Java的初学者的话，希望App推荐的教材能够帮到你",
    @"小贴士：你有试过单选多选判断三个都不勾的情况吗？...",
};

@interface Examinfo : UIViewController


+(void)initExam;
+(Testproblem *)getProblem:(int)index;
+(void)setProblem:(int)index setchoose:(NSString *)option;
+(void)markProblem:(int)index;
+(void)cancelmarkPro:(int)index;
+(int)getPoints;
+(int)getsumobj;
+(int)getproid:(int)index;
+(void)setsumObj:(int)sum;
+(void)setexamType:(int)type;
+(NSString *)gettesttype;
+(BOOL)checkIfchoose:(int)proindex;
+(BOOL)checkIfmark:(int)proindex;
//=====================================
+(void)setstarttime:(NSString *)time;
+(void)setfinishtime:(NSString *)time;
+(NSString *)getstarttime;
+(NSString *)getfinishtime;
//======================================
+(void)setSingle:(BOOL)YorN;
+(void)setMulti:(BOOL)YorN;
+(void)setJudge:(BOOL)YorN;

+(BOOL)getSingle;
+(BOOL)getMulti;
+(BOOL)getJudge;

+(int)getexamType;
+(int)gettestID;

+(void)settestkindType:(NSString *)type;
+(NSString *)gettestkindType;
//=====================================
+(void)updateWrongprobook;
+(void)updateCredit;
+(void)uploadresult;
//====================
+(void)setisfinish:(BOOL)TorF;
+(BOOL)ifisfinish;
//====================
+(BOOL)checkifisright:(int)proindex;

+(NSString *)gettips;
@end
