//
//  Testexam.m
//  Java Programming
//
//  Created by rayshen on 5/5/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//
//该类为随机刷题的数据操作类
#import "Examinfo.h"

int thisNum=0;
int numSrand[1000];
@implementation Examinfo

int points=0;
float realpoints=0;

LocalDataDB *newDB;

+(int)getsumobj{
    return sumObj;
}

+(int)getproid:(int)index{
    return [self getProblem:index]->Tid;
}

+(void)setsumObj:(int)sum{
    sumObj=sum;
}

+(void)setexamType:(int)type{
    examType=type;
}

+(NSString *)gettesttype{
    return testtype;
}

+(int)getexamType{
    return examType;
}

//初始化测试，包括题目数量等参数================================================
+(void)initExam{
    
    isfinish=false;
    
    //载入题目数据库 必须操作-------------------------
    newDB=[[LocalDataDB alloc] init];
    [newDB createDB];
    
    //取得数据库题目总数
    DBsumObj=[newDB countForPro];
    NSLog(@"本地题库题目总数是：%d",DBsumObj);
    
    //判断是哪种测试类型-------------------------------
    switch (examType) {
        case 0: // TestOnline-40
            sumObj=40;
            testtype=@"randomtest-40";
            [self prepareForTestOnline:@"random"];
            break;
        case 1: //TestOnline-100
            sumObj=100;
            testtype=@"randomtest-100";
            [self prepareForTestOnline:@"random"];
            break;
        case 2: //TestOnline-simulate
            sumObj=200;
            testtype=@"randomtest-200";
            [self prepareForTestOnline:@"random"];
            break;
        case 3: //TestOnline-infinite
            testtype=@"randomtest-infinite";
            [self prepareForTestOnline:@"all"];
            break;
        case 4:
            testtype=@"wrongprosRetest";
            [self prepareForWrongTest];
            break;
        case 5:
            testtype=@"collectionRetest";
            [self prepareForCollectionTest];
            break;
        default:
            break;
    }
    
}
+(void)prepareForWrongTest{
    Testproblem *curPro=[[Testproblem alloc]init];
    
    NSMutableArray *Problemlist=[Personinfo getwrongpros];
    
    Problemset = [NSMutableArray arrayWithCapacity:sumObj];
    
    for (thisNum = 0; thisNum < sumObj; thisNum++) {
        
        int thisID=[[Problemlist objectAtIndex:thisNum] intValue];
        
        curPro=[newDB selectPro:thisID];
        
        [Problemset addObject:curPro];
        
        NSLog(@"载入了第%d题，数据库中第%d题，正确选项是%@！",thisNum,thisID,curPro->Tanswer);
    }
    //NSLog(@"题目信息载入完毕===================================");
}

+(void)prepareForCollectionTest{
    Testproblem *curPro=[[Testproblem alloc]init];
    
    NSMutableArray *Problemlist=[Personinfo getcollection];
    
    Problemset = [NSMutableArray arrayWithCapacity:sumObj];
    
    for (thisNum = 0; thisNum < sumObj; thisNum++) {
        
        int thisID=[[Problemlist objectAtIndex:thisNum] intValue];
        
        curPro=[newDB selectPro:thisID];
        
        [Problemset addObject:curPro];
    
        NSLog(@"载入了第%d题，数据库中第%d题，正确选项是%@！",thisNum,thisID,curPro->Tanswer);
    }
    //NSLog(@"题目信息载入完毕===================================");
}



+(void)prepareForTestOnline:(NSString *)type{
    if ([type isEqualToString:@"random"]) {
        //10+10+20

        //根据题目总数载入每道题目，并放入Problemset数组中
        //Testproblem *curPro=[[Testproblem alloc]init];
        
        NSMutableArray *DBProblemset=[newDB selectTypePro:[Examinfo getSingle] valueofmulti:[Examinfo getMulti] valueofjudge:[Examinfo getJudge]];
        
        Problemset=DBProblemset;
        
        NSLog(@"题目总数：%i",[Problemset count]);
        /*
        Prosetsumobj=(int)[DBProblemset count];
        
        NSLog(@"%i",Prosetsumobj);
        
        Problemset=[NSMutableArray arrayWithCapacity:sumObj];
        
        for (thisNum = 0; thisNum < sumObj; thisNum++) {
            
            int thisindex = arc4random() % Prosetsumobj;
            
            curPro=[DBProblemset objectAtIndex:thisindex];
            
            [Problemset addObject:curPro];
        }*/
        NSLog(@"题目信息载入完毕===================================");

    }else if ([type isEqualToString:@"all"]){
        //根据题目总数载入每道题目，并放入Problemset数组中
        //Testproblem *curPro=[[Testproblem alloc]init];
        
        NSMutableArray *DBProblemset=[newDB selectTypePro2:[Examinfo getSingle] valueofmulti:[Examinfo getMulti] valueofjudge:[Examinfo getJudge]];
        
        Problemset=DBProblemset;
        
        Prosetsumobj=(int)[DBProblemset count];
        
        NSLog(@"加载题目数：%i",Prosetsumobj);

        sumObj=Prosetsumobj;
        
        /*
        NSLog(@"加载题目数：%i",Prosetsumobj);
        
        Problemset=[NSMutableArray arrayWithCapacity:Prosetsumobj];
        
        for (thisNum = 0; thisNum < Prosetsumobj; thisNum++) {
            
            int thisindex = arc4random() % Prosetsumobj;
            
            curPro=[DBProblemset objectAtIndex:thisindex];
            
            [Problemset addObject:curPro];
        }*/
        NSLog(@"题目信息载入完毕===================================");
    }
   
}

//================================================================================


//检测题目是否重复出现========================================================
-(BOOL)isNew:(int)newNum{
    for(int i=0; i<sumObj; i++) {
        if(numSrand[i] == newNum)
            return true;
    }
    return false;
}
//========================================================================

+(Testproblem *)getProblem:(int)index{
    
    return [Problemset objectAtIndex:index];
    
}

//记录用户选择的题目选项============================================================
+(void)setProblem:(int)index setchoose:(NSString *)option{
    Testproblem *curPro=[Problemset objectAtIndex:index];
    curPro->Chooce=option;
    curPro->ismark=false;
    NSLog(@"答了第%d题：选择的是%@选项 正确选项是%@选项",index,curPro->Chooce,curPro->Tanswer);
    [Problemset replaceObjectAtIndex:index withObject:curPro];
}

+(void)markProblem:(int)index{
    Testproblem *curPro=[Problemset objectAtIndex:index];
    curPro->ismark=true;
    NSLog(@"标记了第%d题",index);
    [Problemset replaceObjectAtIndex:index withObject:curPro];
}
+(void)cancelmarkPro:(int)index{
    Testproblem *curPro=[Problemset objectAtIndex:index];
    curPro->ismark=false;
    NSLog(@"取消标记了第%d题",index);
    [Problemset replaceObjectAtIndex:index withObject:curPro];
}

//交卷时对答题的情况进行计算========================================================
+(int)getPoints{
    //加分制==================
    points=0;
    realpoints=0;
    Testproblem *curPro=[[Testproblem alloc]init];
    for (int i = 0; i < sumObj; i++) {
        curPro=[Problemset objectAtIndex:i];
        //NSLog(@"正在提交第%d题：选择的是%@选项 正确选项是%@选项",i,curPro->Chooce,curPro->Tanswer);
        
        //此情况下作对了（加分）
        if([(curPro->Chooce) isEqualToString:(curPro->Tanswer)]){
            
            curPro->ifright=true;
            [Problemset replaceObjectAtIndex:i withObject:curPro];

            points++;
            realpoints+=2.5;
            /*
            //把重新做对的题目从错题数据库删掉,会联网，重新做对几次连几次。。卧槽。。
            if (   [Personinfo checkandremove:curPro->Tid]  ) {
                NSLog(@"该用户重新最对了第%i题:",curPro->Tid);
            }
            */
        //此情况下做错了，1未做,选T  2选错
        }else{
            //未做的算答题错误（不加分），但不加入错题本
            curPro->ifright=false;
            [Problemset replaceObjectAtIndex:i withObject:curPro];
            /*
            //不是选T的，做错的情况下
            if (![(curPro->Chooce) isEqualToString:@"Z"]&&curPro->Chooce!=NULL){
                NSString *proid=[NSString stringWithFormat:@"%d",curPro->Tid];
                
                
                if ( ![Personinfo checkproiswrong:curPro->Tid]  ) {
                    //把出错的题目加入数据库，会联网,错几次连几次。。。卧槽。。
                    [Personinfo addwrongpro:proid];
                    NSLog(@"该用户做错了第%i题:",curPro->Tid);
                }
            }
            */
        }
    }
    return points;
}

//更新错题本=====================================
+(void)updateWrongprobook{
    Testproblem *curPro=[[Testproblem alloc]init];
    for (int i = 0; i < sumObj; i++) {
        curPro=[Problemset objectAtIndex:i];
        //NSLog(@"正在提交第%d题：选择的是%@选项 正确选项是%@选项",i,curPro->Chooce,curPro->Tanswer);
        
        //此情况下作对了（加分），检查是否错过，重新做对就从错题本去掉
        if([(curPro->Chooce) isEqualToString:(curPro->Tanswer)]){
            //把重新做对的题目从错题数据库删掉,会联网，重新做对几次连几次。。卧槽。。
            if ([Personinfo checkandremove:curPro->Tid]) {
                NSLog(@"该用户重新最对了第%i题:",curPro->Tid);
            }
        //此情况下做错了，1未做,选T  2选错
        }else{
            //未做的算答题错误（不加分），但不加入错题本
            
            //不是选T的，做错的情况下（不加分），检查是否错过，没错过就加入错题
            if (![(curPro->Chooce) isEqualToString:@"NoAnswer"]&&curPro->Chooce!=NULL){
                NSString *proid=[NSString stringWithFormat:@"%d",curPro->Tid];
                if (![Personinfo checkproiswrong:curPro->Tid]) {
                    //把出错的题目加入数据库，会联网,错几次连几次。。。卧槽。。
                    [Personinfo addwrongpro:proid];
                    NSLog(@"该用户做错了第%i题:",curPro->Tid);
                }
            }
        }
    }
    NSLog(@"已更新错题本");
}

+(void)updateCredit{
    [PersonConnection addCredit:[Personinfo getid] valueofnum:points];
}

+(void)uploadresult{
    [self uploadtestresult];
    [Personinfo inittestresults];
}

+(BOOL)checkIfchoose:(int)proindex{
    Testproblem *curPro=[[Testproblem alloc]init];
    curPro=[Problemset objectAtIndex:proindex];
    if (![(curPro->Chooce) isEqualToString:@"NoAnswer"]&&curPro->Chooce!=NULL){
        return true;
    }else{
        return false;
    }
}

+(BOOL)checkifisright:(int)proindex{
    Testproblem *curPro=[[Testproblem alloc]init];
    curPro=[Problemset objectAtIndex:proindex];
    if ([curPro->Chooce isEqualToString:curPro->Tanswer]||[curPro->Chooce isEqualToString:@"NoAnswer"]){
        return true;
    }else{
        return false;
    }
}


+(BOOL)checkIfmark:(int)proindex{
    Testproblem *curPro=[[Testproblem alloc]init];
    curPro=[Problemset objectAtIndex:proindex];
    if (curPro->ismark){
        return true;
    }else{
        return false;
    }
}

+(void)uploadtestresult{
    Testresult *newtestresult=[[Testresult alloc]init];
    newtestresult=[newtestresult inittestresult:[Personinfo getid] vfaccount:[Personinfo getaccount] vftestkindType:testkindType vfscore:realpoints vfstarttime:starttime vffinishtime:finishtime];
    TestID=[PersonConnection insettestresult:newtestresult];
    
    [PersonConnection insertpro:Problemset];
}

//===========================================================================
+(BOOL)getSingle{
    return Single;
}
+(BOOL)getMulti{
    return Multi;
}
+(BOOL)getJudge{
    return Judge;
}
+(void)setSingle:(BOOL)YorN{
    Single=YorN;
}
+(void)setMulti:(BOOL)YorN{
    Multi=YorN;
}
+(void)setJudge:(BOOL)YorN{
    Judge=YorN;
}
//有关时间
+(void)setstarttime:(NSString *)time{
    starttime=time;
}
+(NSString *)getstarttime{
    return starttime;
}

+(void)setfinishtime:(NSString *)time{
    finishtime=time;
}
+(NSString *)getfinishtime{
    return finishtime;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//========
+(void)settestkindType:(NSString *)type{
    testkindType=type;
}
+(NSString *)gettestkindType{
    return testkindType;
}

+(int)gettestID{
    return TestID;
}
//========
+(void)setisfinish:(BOOL)TorF{
    isfinish=TorF;
}
+(BOOL)ifisfinish{
    return isfinish;
}

+(NSString *)gettips{
    int n = arc4random() % 8;
    return tips[n];
}

@end
