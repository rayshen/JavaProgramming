//
//  TestDB.m
//  Java Programming
//
//  Created by rayshen on 4/26/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "LocalDataDB.h"
#import "Testproblem.h"

#define DBNAME    @"localdata.db"
#define QUESTION  @"question"
#define OPTION1   @"SelectA"
#define OPTION2   @"SelectB"
#define OPTION3   @"SelectC"
#define OPTION4   @"SelectD"
#define TABLENAME @"tbtestlibrary"
#define ANSWER    @"answer"


@implementation LocalDataDB

-(void)createDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //该方法可用来显示DOCUMENT文件夹内的文件信息
    NSString *documents = [paths objectAtIndex:0];
    
    database_path = [documents stringByAppendingPathComponent:DBNAME];//获取数据库文件的地址，不存在就会创建
    NSLog(@"数据库地址是:%@",database_path);

    //根据上面拼接好的路径 dbFilePath ，利用NSFileManager 类的对象的fileExistsAtPath方法来检测是否存在，返回一个BOOL值
    //1. 创建NSFileManager对象  NSFileManager包含了文件属性的方法
    NSFileManager *fm = [NSFileManager defaultManager];
    
    //2. 通过 NSFileManager 对象 fm 来判断文件是否存在，存在 返回YES  不存在返回NO
    BOOL isExist = [fm fileExistsAtPath:database_path];
    //NSLog(@"isExist =%d",isExist);

    //如果不存在 isExist = NO，拷贝工程里的数据库到Documents下
    if (!isExist)
    {
        //拷贝数据库
        //获取工程里，数据库的路径,因为我们已在工程中添加了数据库文件，所以我们要从工程里获取路径
        NSString *backupDbPath = [[NSBundle mainBundle]
                                  pathForResource:@"localdata"
                                  ofType:@"db"];
        BOOL cp = [fm copyItemAtPath:backupDbPath toPath:database_path error:nil];
        NSLog(@"找到Bundle文件：%@，已拷贝至Document",backupDbPath);
    }
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
    
    sqlite3_close(db);

}
//======================================================

-(Testproblem *)selectPro:(int)thisQuestionID{
    NSString *sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary WHERE QuestionID=%i",thisQuestionID];
    
    sqlite3_stmt * statement;
    
    Testproblem *newProblem=[Testproblem alloc];
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {

        while (sqlite3_step(statement) == SQLITE_ROW) {

            int QuestionID = sqlite3_column_int(statement, 0);
            
            int QuestionType = sqlite3_column_int(statement, 1);
            
            char *title = (char*)sqlite3_column_text(statement, 4);
            NSString *nstitleStr = [[NSString alloc]initWithUTF8String:title];
            
            NSString *nsoption1Str = [[NSString alloc]init];
            NSString *nsoption2Str = [[NSString alloc]init];
            NSString *nsoption3Str = [[NSString alloc]init];
            NSString *nsoption4Str = [[NSString alloc]init];
            char *answer = (char*)sqlite3_column_text(statement, 9);
            NSString *nsanswerStr = [[NSString alloc]initWithUTF8String:answer];
            
            if (QuestionType==1||QuestionType==2) {
                char *option1 = (char*)sqlite3_column_text(statement, 5);
                nsoption1Str = [[NSString alloc]initWithUTF8String:option1];
                char *option2 = (char*)sqlite3_column_text(statement, 6);
                nsoption2Str = [[NSString alloc]initWithUTF8String:option2];
                char *option3 = (char*)sqlite3_column_text(statement, 7);
                nsoption3Str = [[NSString alloc]initWithUTF8String:option3];
                char *option4 = (char*)sqlite3_column_text(statement, 8);
                nsoption4Str = [[NSString alloc]initWithUTF8String:option4];
                ;
            }else{
                nsoption1Str=nil;
                nsoption2Str=nil;
                nsoption3Str=nil;
                nsoption4Str=nil;
            }
            
            newProblem=[newProblem create:QuestionID valueoftype:QuestionType valueoftitle:nstitleStr valueofoption1:nsoption1Str valueofoption2:nsoption2Str valueofoption3:nsoption3Str valueofoption4:nsoption4Str as:nsanswerStr];
        }
    
    }
    return newProblem;
}

-(NSMutableArray *)selectTypePro:(BOOL)single valueofmulti:(BOOL)multi valueofjudge:(BOOL)judge{
    
    //NSString *sqlQuery;
    
    NSMutableArray *problemset=[[NSMutableArray alloc]init];
    Testproblem *newProblem=[Testproblem alloc];

    
    NSString *sqlQuery1 =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary where QuestionType=1 ORDER BY RANDOM() LIMIT 1"];
    NSString *sqlQuery2 =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary where QuestionType=2 ORDER BY RANDOM() LIMIT 1"];
    NSString *sqlQuery3 =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary where QuestionType=3 ORDER BY RANDOM() LIMIT 1"];

    if (single) {
        if (multi) {
            if (judge) {
            //情况1   单选+多选+判断
                [Examinfo settestkindType:@"123"];
                for (int i=0; i<10; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery1];
                    [problemset addObject:newProblem];
                }
                for (int i=0; i<10; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery2];
                    [problemset addObject:newProblem];
                }
                for (int i=0; i<20; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery3];
                    [problemset addObject:newProblem];
                }
                
            }else{
            //情况2   单选+多选
                [Examinfo settestkindType:@"12"];
                for (int i=0; i<20; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery1];
                    [problemset addObject:newProblem];
                }
                for (int i=0; i<20; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery2];
                    [problemset addObject:newProblem];
                }
            }
        }else{
            if (judge) {
            //情况3   单选+判断
                [Examinfo settestkindType:@"13"];
                for (int i=0; i<20; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery1];
                    [problemset addObject:newProblem];
                }
                for (int i=0; i<20; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery3];
                    [problemset addObject:newProblem];
                }
            }else{
            //情况4   单选
                [Examinfo settestkindType:@"1"];
                for (int i=0; i<40; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery1];
                    [problemset addObject:newProblem];
                }
            }
        }
        
    }else{
        if (multi) {
            if (judge) {
            //情况1   多选+判断
                [Examinfo settestkindType:@"23"];
                for (int i=0; i<20; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery2];
                    [problemset addObject:newProblem];
                }
                for (int i=0; i<20; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery3];
                    [problemset addObject:newProblem];
                }
            }else{
            //情况1   多选
                [Examinfo settestkindType:@"2"];
                for (int i=0; i<40; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery2];
                    [problemset addObject:newProblem];
                }
            }
        }else{
            if (judge) {
            //情况1   判断
                [Examinfo settestkindType:@"3"];
                for (int i=0; i<40; i++) {
                    newProblem=[self selectProwithSQL:sqlQuery3];
                    [problemset addObject:newProblem];
                }
            }else{
            //情况1
                [Examinfo settestkindType:@""];
                NSLog(@"什么都没选，此语句不会运行。");
            }
        }
    }
    
    return problemset;
}


-(Testproblem *)selectProwithSQL:(NSString *)sqlQuery{
    
    Testproblem *newProblem=[Testproblem alloc];

    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            int QuestionID = sqlite3_column_int(statement, 0);
            
            int QuestionType = sqlite3_column_int(statement, 1);
            
            char *title = (char*)sqlite3_column_text(statement, 4);
            NSString *nstitleStr = [[NSString alloc]initWithUTF8String:title];
            
            NSString *nsoption1Str = [[NSString alloc]init];
            NSString *nsoption2Str = [[NSString alloc]init];
            NSString *nsoption3Str = [[NSString alloc]init];
            NSString *nsoption4Str = [[NSString alloc]init];
            char *answer = (char*)sqlite3_column_text(statement, 9);
            NSString *nsanswerStr = [[NSString alloc]initWithUTF8String:answer];
            
            if (QuestionType==1||QuestionType==2) {
                char *option1 = (char*)sqlite3_column_text(statement, 5);
                nsoption1Str = [[NSString alloc]initWithUTF8String:option1];
                char *option2 = (char*)sqlite3_column_text(statement, 6);
                nsoption2Str = [[NSString alloc]initWithUTF8String:option2];
                char *option3 = (char*)sqlite3_column_text(statement, 7);
                nsoption3Str = [[NSString alloc]initWithUTF8String:option3];
                char *option4 = (char*)sqlite3_column_text(statement, 8);
                nsoption4Str = [[NSString alloc]initWithUTF8String:option4];
                ;
            }else{
                nsoption1Str=nil;
                nsoption2Str=nil;
                nsoption3Str=nil;
                nsoption4Str=nil;
            }
            
            
            newProblem=[newProblem create:QuestionID valueoftype:QuestionType valueoftitle:nstitleStr valueofoption1:nsoption1Str valueofoption2:nsoption2Str valueofoption3:nsoption3Str valueofoption4:nsoption4Str as:nsanswerStr];
            
        }
    }
    return newProblem;
    
}

-(NSMutableArray *)selectTypePro2:(BOOL)single valueofmulti:(BOOL)multi valueofjudge:(BOOL)judge{
    
    NSString *sqlQuery;
    
    NSMutableArray *problemset=[[NSMutableArray alloc]init];
    
    if (single) {
        if (multi) {
            if (judge) {
                //情况1   单选+多选+判断
                [Examinfo settestkindType:@"123"];
                sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary ORDER BY RANDOM()"];
            }else{
                //情况2   单选+多选
                [Examinfo settestkindType:@"12"];
                sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary where QuestionType=1 or QuestionType=2 ORDER BY RANDOM()"];
            }
        }else{
            if (judge) {
                //情况3   单选+判断
                [Examinfo settestkindType:@"13"];
                sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary where QuestionType=1 or QuestionType=3 ORDER BY RANDOM()"];
            }else{
                //情况4   单选
                [Examinfo settestkindType:@"1"];
                sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary where QuestionType=1 ORDER BY RANDOM()"];
            }
        }
        
    }else{
        if (multi) {
            if (judge) {
                //情况1   多选+判断
                [Examinfo settestkindType:@"23"];
                sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary where QuestionType=2 or QuestionType=3 ORDER BY RANDOM()"];
            }else{
                //情况1   多选
                [Examinfo settestkindType:@"2"];
                sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary where QuestionType=2 ORDER BY RANDOM()"];
            }
        }else{
            if (judge) {
                //情况1   判断
                [Examinfo settestkindType:@"3"];
                sqlQuery =[[NSString alloc]initWithFormat:@"SELECT * FROM tbtestlibrary where QuestionType=3 ORDER BY RANDOM()"];
            }else{
                //情况1
                [Examinfo settestkindType:@""];
                NSLog(@"什么都没选，此语句不会运行。");
            }
        }
    }
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            int QuestionID = sqlite3_column_int(statement, 0);
            
            int QuestionType = sqlite3_column_int(statement, 1);
            
            char *title = (char*)sqlite3_column_text(statement, 4);
            NSString *nstitleStr = [[NSString alloc]initWithUTF8String:title];
            
            NSString *nsoption1Str = [[NSString alloc]init];
            NSString *nsoption2Str = [[NSString alloc]init];
            NSString *nsoption3Str = [[NSString alloc]init];
            NSString *nsoption4Str = [[NSString alloc]init];
            char *answer = (char*)sqlite3_column_text(statement, 9);
            NSString *nsanswerStr = [[NSString alloc]initWithUTF8String:answer];
            
            if (QuestionType==1||QuestionType==2) {
                char *option1 = (char*)sqlite3_column_text(statement, 5);
                nsoption1Str = [[NSString alloc]initWithUTF8String:option1];
                char *option2 = (char*)sqlite3_column_text(statement, 6);
                nsoption2Str = [[NSString alloc]initWithUTF8String:option2];
                char *option3 = (char*)sqlite3_column_text(statement, 7);
                nsoption3Str = [[NSString alloc]initWithUTF8String:option3];
                char *option4 = (char*)sqlite3_column_text(statement, 8);
                nsoption4Str = [[NSString alloc]initWithUTF8String:option4];
                ;
            }else{
                nsoption1Str=nil;
                nsoption2Str=nil;
                nsoption3Str=nil;
                nsoption4Str=nil;
            }
            
            Testproblem *newProblem=[Testproblem alloc];
            
            newProblem=[newProblem create:QuestionID valueoftype:QuestionType valueoftitle:nstitleStr valueofoption1:nsoption1Str valueofoption2:nsoption2Str valueofoption3:nsoption3Str valueofoption4:nsoption4Str as:nsanswerStr];
            
            [problemset addObject:newProblem];
        }
        
    }
    
    //NSLog(@"共有题目数：%i",(int)[problemset count]);
    
    return problemset;
}

-(int)countForPro{
    int rows = 0;//记录题目总数
    if (sqlite3_open([self->database_path UTF8String], &db) == SQLITE_OK)
    {
        //NSLog(@"此处执行===========");
        const char* sqlStatement = "SELECT COUNT(*) FROM tbtestlibrary";
        sqlite3_stmt* statement;
        
        if( sqlite3_prepare_v2(db, sqlStatement, -1, &statement, NULL) == SQLITE_OK )
        {
            if( sqlite3_step(statement) == SQLITE_ROW )
                rows  = sqlite3_column_int(statement, 0);
                //NSLog(@"题目总数是：%d",rows);
        }
        else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) );
        }
        
        //sqlite3_finalize(statement);
        //sqlite3_close(db);
    }
    
    return rows;
}

//==========================================================
-(NSString *)selectSchool:(int)UnivID{
    NSString *UnivName;
    NSString *sqlQuery =[[NSString alloc]initWithFormat:@"SELECT UnivName FROM tbuniversity where UnivID=%d",UnivID];
    if (sqlite3_open([self->database_path UTF8String], &db) == SQLITE_OK)
    {
        sqlite3_stmt * statement;
    
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
            while (sqlite3_step(statement) == SQLITE_ROW) {
                char *row0 = (char*)sqlite3_column_text(statement, 0);
                UnivName = [[NSString alloc]initWithUTF8String:row0];
            }
        }else
        {
            NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) );
        }
    }
    return UnivName;

}

-(NSArray *)selectProvincelist{
    NSMutableArray *selectProvincelist=[[NSMutableArray alloc]init];
    NSArray *provincelist=[[NSArray alloc]init];
    
    if (sqlite3_open([self->database_path UTF8String], &db) == SQLITE_OK){

    NSString *sqlQuery =@"SELECT province FROM tbuniversity group by province";
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *row0 = (char*)sqlite3_column_text(statement, 0);
            NSString *strrow0 = [[NSString alloc]initWithUTF8String:row0];
            [selectProvincelist addObject:strrow0];
            
        }
        NSLog(@"执行省份查询，并添加");
    }else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) );
    }
    
        provincelist=[selectProvincelist copy];
    }
    return provincelist;
}

-(NSArray *)selectCitylist:(NSString *)province{
    NSMutableArray *selectCitylist=[[NSMutableArray alloc]init];
    NSString *sqlQuery =[[NSString alloc]initWithFormat:@"SELECT city FROM tbuniversity where province='%@' group by city ",province];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *row0 = (char*)sqlite3_column_text(statement, 0);
            NSString *strrow0 = [[NSString alloc]initWithUTF8String:row0];
            [selectCitylist addObject:strrow0];
        }
    }
    NSArray *citylist=[selectCitylist copy];
    
    return citylist;
}

-(NSArray *)selectSchoollist:(NSString *)city{
    NSMutableArray *selectSchoollist=[[NSMutableArray alloc]init];
     NSString *sqlQuery =[[NSString alloc]initWithFormat:@"SELECT Univname FROM tbuniversity where city='%@' ",city];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *row0 = (char*)sqlite3_column_text(statement, 0);
            NSString *strrow0 = [[NSString alloc]initWithUTF8String:row0];
            [selectSchoollist addObject:strrow0];
        }
    }
    NSArray *schoollist=[selectSchoollist copy];
    
    return schoollist;
}

-(int)selectUnivID:(NSString *)Univname{
    int UnivID;
    NSString *sqlQuery =[[NSString alloc]initWithFormat:@"SELECT UnivID FROM tbuniversity where Univname='%@' ",Univname];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        
        while (sqlite3_step(statement) == SQLITE_ROW) {
            UnivID = sqlite3_column_int(statement, 0);
        }
    }
    return UnivID;
}


-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }else
    {
        NSLog( @"Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) );
    }
}

//创建表
/*
 NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS tbtestlibrary (QuestionID INTEGER PRIMARY KEY AUTOINCREMENT, QuestionType int(20),QuestionSection varchar(40),Difficulty varchar(10),Question TEXT,SelectA TEXT,SelectB TEXT,SelectC  TEXT,SelectD TEXT,Answer TEXT)";
 [self execSql:sqlCreateTable];
 */
/*
 //插入数据
 NSString *sql1 = [NSString stringWithFormat:
 @"INSERT INTO '%@' ('%@', '%@', '%@', '%@', '%@','%@') VALUES ('%@', '%@', '%@', '%@','%@','%@')",
 TABLENAME, QUESTION, OPTION1, OPTION2, OPTION3,OPTION4,ANSWER,@"编译Java  Applet 源程序文件产生的字节码文件的扩展名为( )。", @"java", @"class",@"html",@"exe",@"B"];
 [self execSql:sql1];
 */

@end