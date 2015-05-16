//
//  Testresult.m
//  Java Programming
//
//  Created by way on 5/21/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "Testresult.h"

@implementation Testresult

-(Testresult *)inittestresult:(int)userid vfaccount:(NSString *)account vftestkindType:(NSString *)type vfscore:(float)score vfstarttime:(NSString *)starttime vffinishtime:(NSString *)finishtime{
    
    Testresult *newtestresult=[[Testresult alloc]init];
    newtestresult->iuserid=userid;
    newtestresult->iaccount=account;
    newtestresult->itestkindType=type;
    newtestresult->iscore=score;
    newtestresult->istarttime=starttime;
    newtestresult->ifinishtime=finishtime;
    return newtestresult;
}

@end
