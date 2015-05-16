//
//  PersonDB.m
//  Java Programming
//
//  Created by rayshen on 5/11/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "PersonConnection.h"

#define DBNAME      @"personinfo.sqlite"
#define TABLENAME   @"personinfo"
#define MAILBOX     @"mailbox"
#define PASSWORD    @"password"
#define NAME        @"name"
#define SEX         @"sex"
#define PHONENUM    @"phonenum"


@implementation PersonConnection
@synthesize connectionData;

//===================================================================
+(BOOL)checkConnect{
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/checkconnect.jsp",HOSTIP];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    //[request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:nil];
    
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"检测联网jsp返回结果:%@",returnstr);
    
    if([returnstr isEqualToString:@"connect"]){
        NSLog(@"联网检测成功!");
        return true;
    }else{
        NSLog(@"联网检测失败!");
        return false;
    }

}
//================================================================
//通过邮箱对用户信息进行初始化
+(void)setPerson:(NSString *)email valueofpsw:(NSString *)psw{
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *MD5psw=[self md5:psw];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/selectUser.jsp?email=%@&psw=%@",HOSTIP,email,MD5psw];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    //[request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"取得用户jsp返回结果:%@",returnstr);

    NSArray *splitArray = [[NSArray alloc] init];
    splitArray = [returnstr componentsSeparatedByString:@"#"];
   //返回顺序为：ID，账号，邮箱，密码(MD5加密)，姓名，性别，电话，大学编号
    [Personinfo initperson:[splitArray[0] intValue] valueofaccount:splitArray[1] valueofname:splitArray[4] valueofemail:splitArray[2] valueofsex:splitArray[5] valueofunivID:[splitArray[7] intValue] valueofpsw:psw valurofpnum:splitArray[6]];
}

//登录时通过账号密码对用户进行验证
+(BOOL)checkPerson:(NSString *)email valueofpsw:(NSString *)psw{
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

    NSString *MD5psw=[self md5:psw];

    NSLog(@"psw:%@,MD5psw:%@",psw,MD5psw);
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/login.jsp?email=%@&psw=%@",HOSTIP,email,MD5psw];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    //[request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];

    NSLog(@"登陆验证jsp返回结果:%@",returnstr);
    
    if([returnstr isEqualToString:@"true"]){
        NSLog(@"已经进行完账户验证，通过!");
        return true;
    }else{
        NSLog(@"已经进行完账户验证，不通过!");
        return false;
    }
}

//注册时验证账号是否存在
+(BOOL)checkPersonwithemail:(NSString *)email{
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/checkemail.jsp?email=%@",HOSTIP,email];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    NSLog(@"注册验证jsp返回结果:%@",returnstr);
    
    if([returnstr isEqualToString:@"true"]){
        return true;
    }else{
        return false;
    }
}

//添加新的用户
+(BOOL)insertNewuser:(NSString *)email valueofpsw:(NSString *)psw{
    
    NSString *MD5psw=[self md5:psw];

    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    NSString *post = [NSString stringWithFormat:@"email=%@&psw=%@",email,MD5psw];
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/zjut_java_ios/insertNewuser.jsp",HOSTIP]]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    //定义
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //将NSData类型的返回值转换成NSString类型
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"注册jsp返回结果:%@",result);
    
    if([result isEqualToString:@"true"]){
        NSLog(@"注册成功");
        return true;
    }else{
        NSLog(@"注册失败");
        return false;
    }
}

//修改信息
+(BOOL)editinfo:(int)userid valueofname:(NSString *)name valueofsex:(NSString *)sex valueofunivID:(int)UnivID valueofpnum:(NSString *)pnum
{
    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    NSString *post = [NSString stringWithFormat:@"userid=%i&name=%@&sex=%@&UnivID=%i&pnum=%@",userid,name,sex,UnivID,pnum];
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/zjut_java_ios/updateUser.jsp",HOSTIP]]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    //定义
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //将NSData类型的返回值转换成NSString类型
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"信息更新jsp返回结果:%@",result);
    
    if([result isEqualToString:@"true"]){
        NSLog(@"更新信息成功");
        return true;
    }else{
        NSLog(@"更新信息出错");
        return false;
    }
}

//===================================================================
//===================================================================
+(NSMutableArray *)initcollection:(int)userid{
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/getcollection.jsp?userid=%i",HOSTIP,userid];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    BOOL isnew=false;
    int sumItem;
    if([returnstr isEqualToString:@""]){
        isnew=true;
    }
    NSArray *splitArray = [[NSArray alloc] init];
    splitArray = [returnstr componentsSeparatedByString:@"#"];
    NSMutableArray *collection=[[NSMutableArray alloc]initWithCapacity:splitArray.count];
    if (isnew) {
        sumItem=0;
    }else{
        sumItem=(int)splitArray.count;
    }

    for (int i=0; i<sumItem; i++) {
        [collection addObject:splitArray[i]];
    }
    return collection;
}

//添加收藏
+(BOOL)insertcollection:(int)userid valueofproid:(int)proid{
    
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/insertCollection.jsp?userid=%i&proid=%i",HOSTIP,userid,proid];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if([returnstr isEqualToString:@"true"]){
        return true;
    }else{
        return false;
    }
    
}

+(BOOL)deletecollection:(int)userid valueofproid:(int)proid{
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/deletecollection.jsp?userid=%i&proid=%i",HOSTIP,userid,proid];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"注册jsp返回结果:%@",returnstr);
    if([returnstr isEqualToString:@"true"]){
        return true;
    }else{
        return false;
    }
}
//===================================================================
//===================================================================

+(NSMutableArray *)initwrongprosbook:(int)userid{
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/getwrongprosbook.jsp?userid=%i",HOSTIP,userid];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
   
    BOOL isnew=false;
    int sumItem;
    if([returnstr isEqualToString:@""]){
        isnew=true;
    }
                           
    NSArray *splitArray = [[NSArray alloc] init];
    splitArray = [returnstr componentsSeparatedByString:@"#"];
    NSMutableArray *wrongprosbook=[[NSMutableArray alloc]initWithCapacity:splitArray.count];
                           
    if (isnew) {
       sumItem=0;
    }else{
       sumItem=(int)splitArray.count;
    }
    for (int i=0; i<sumItem; i++) {
        [wrongprosbook addObject:splitArray[i]];
        //NSLog(@"初始化错题本：该用户做错过第%i题\n",[splitArray[i] intValue]);
    }
    return wrongprosbook;
}

//添加收藏
+(BOOL)insertwrongpro:(int)userid valueofproid:(int)proid{
    
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/insertwrongpro.jsp?userid=%i&proid=%i",HOSTIP,userid,proid];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if([returnstr isEqualToString:@"true"]){
        return true;
    }else{
        return false;
    }
    
}

+(BOOL)deletewrongpro:(int)userid valueofproid:(int)proid{
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/deletewrongpro.jsp?userid=%i&proid=%i",HOSTIP,userid,proid];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    if([returnstr isEqualToString:@"true"]){
        return true;
    }else{
        return false;
    }
}
//===================================================================
+(NSMutableArray *)inittestresult:(int)userid{
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/gettestresult.jsp?userid=%i",HOSTIP,userid];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    BOOL isnew=false;
    int sumItem;
    if([returnstr isEqualToString:@""]){
        isnew=true;
    }

    NSArray *everyresult = [[NSArray alloc] init];
    NSArray *everyitem = [[NSArray alloc] init];

    everyresult = [returnstr componentsSeparatedByString:@"*"];
    
    NSMutableArray *itestresults=[[NSMutableArray alloc]init];
    
    if (isnew) {
        sumItem=0;
    }else{
        sumItem=(int)everyresult.count;
    }
    
    for (int i=0; i<sumItem; i++) {
        everyitem=[everyresult[i] componentsSeparatedByString:@"#"];
        Testresult *newtestresult=[[Testresult alloc]init];
        newtestresult->iuserid=[everyitem[0] intValue];
        newtestresult->iscore=[everyitem[1] floatValue];
        newtestresult->ifinishtime=everyitem[2];
        [itestresults addObject:newtestresult];
    }
    return itestresults;
}

+(int)insettestresult:(Testresult *)newtestresult{

    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    NSString *post = [NSString stringWithFormat:@"userid=%i&account=%@&&testkindtype=%@&score=%f&starttime=%@&finishtime=%@",newtestresult->iuserid,newtestresult->iaccount,newtestresult->itestkindType,newtestresult->iscore,newtestresult->istarttime,newtestresult->ifinishtime];
    NSLog(@"提交的此次测试类型:%@",newtestresult->itestkindType);

    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/zjut_java_ios/inserttestresult.jsp",HOSTIP]]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    //定义
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //将NSData类型的返回值转换成NSString类型
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"上传考试结果jsp返回此次TestID:%@",result);
    
    return [result intValue];
    /*
    if([result isEqualToString:@"true"]){
        NSLog(@"上传考试结果成功");
        return true;
    }else{
        NSLog(@"上传考试成绩出错");

        return false;
    }*/
}

//========================================================

+(BOOL)addCredit:(int)userid valueofnum:(int)num{
    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    NSString *post = [NSString stringWithFormat:@"userid=%i&num=%i",userid,num];
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [post dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/zjut_java_ios/updateCredit.jsp",HOSTIP]]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    //定义
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //将NSData类型的返回值转换成NSString类型
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"更新积分jsp返回结果：%@",result);
    
    if([result isEqualToString:@"true"]){
        NSLog(@"更新积分成功");
        return true;
    }else{
        NSLog(@"更新积分出错");
        return false;
    }
}

+(NSMutableArray *)getCredit:(int)userid{
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    NSString *url=[NSString stringWithFormat:@"http://%@/zjut_java_ios/getcredit.jsp?userid=%i",HOSTIP,userid];
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    [request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    BOOL isnew=false;
    int sumItem;
    if([returnstr isEqualToString:@""]){
        isnew=true;
    }
    
    
    NSArray *everyresult = [[NSArray alloc] init];
    NSArray *everyitem = [[NSArray alloc] init];
    
    everyresult = [returnstr componentsSeparatedByString:@"*"];
    
    NSMutableArray *irank=[[NSMutableArray alloc]init];
    
    if (isnew) {
        sumItem=0;
    }else{
        sumItem=(int)everyresult.count;
    }
    
    for (int i=0; i<sumItem; i++) {
        everyitem=[everyresult[i] componentsSeparatedByString:@"#"];
        Person *newPerson=[[Person alloc]init];
        newPerson->iuserid=[everyitem[0] intValue];
        newPerson->imailbox=everyitem[1];
        newPerson->iname=everyitem[2];
        newPerson->isex=everyitem[3];
        newPerson->iphonenum=everyitem[4];
        newPerson->icredit=[everyitem[5] intValue];
        [irank addObject:newPerson];
    }
    return irank;
}

+(void)loginwithQRcode:(NSString *)url{
    NSLog(@"访问网址为：%@",url);
    // 初始化请求
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    // 设置URL
    [request setURL:[NSURL URLWithString:url]];
    // 设置HTTP方法
    //[request setHTTPMethod:@"GET"];
    // 发 送同步请求, 这里得returnData就是返回得数据了
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request
                                               returningResponse:nil error:nil];
    
    NSString *returnstr = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //NSLog(@"检测联网jsp返回结果:%@",returnstr);
}

+(BOOL)insertpro:(NSMutableArray *)proset{
    //post提交的参数，格式如下：
    //参数1名字=参数1数据&参数2名字＝参数2数据&参数3名字＝参数3数据&...
    
    //POST详细题目的用户信息和测试信息
    NSString *postString = [NSString stringWithFormat:@"TestID=%i&userindexid=%i&account=%@&",[Examinfo gettestID],[Personinfo getid],[Personinfo getaccount]];
    //添加每道题的信息
    for (int i=0; i<[proset count]; i++) {
        Testproblem *thispro=[proset objectAtIndex:i];
        int ifright=0;
        if([thispro->Chooce isEqualToString:thispro->Tanswer]){
            ifright=1;
        }
    
        postString=[postString stringByAppendingFormat:@"QuestionID%i=%i&Response%i=%@&Answer%i=%@&Result%i=%i&",i,thispro->Tid,i,thispro->Chooce,i,thispro->Tanswer,i,ifright];
        
    }
    
    //NSLog(@"POSTSTRING:%@",postString);
    
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    //设置提交目的url
    [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/zjut_java_ios/updatedetail.jsp",HOSTIP]]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    
    //定义
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    //将NSData类型的返回值转换成NSString类型
    NSString *result = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    NSLog(@"更新Detail表jsp返回结果：%@",result);
    
    /*
    if([result isEqualToString:@"true"]){
        NSLog(@"更新具体成绩成功");
        return true;
    }else{
        NSLog(@"更新具体成绩出错");
        return false;
    }
    return false;
    */
    return false;
}


+(NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    NSMutableString *Mstr = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH];
    
    for (int i=0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [Mstr appendFormat:@"%02X",result[i]];
    }
    return Mstr;
}


@end
