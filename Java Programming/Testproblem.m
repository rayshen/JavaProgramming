//
//  Testproblems.m
//  Java Programming
//
//  Created by rayshen on 4/26/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import "Testproblem.h"

@implementation Testproblem

-(Testproblem *)create:(int)Nid valueoftype:(int)Ntype valueoftitle:(NSString*)Ntitle  valueofoption1:(NSString *)Noption1 valueofoption2:(NSString *)Noption2 valueofoption3:(NSString *)Noption3 valueofoption4:(NSString *)Noption4 as:(NSString *)Nanswer{
    Testproblem *newTestproblem=[[Testproblem alloc]init];
    newTestproblem->Tid=Nid;
    newTestproblem->Ttype=Ntype;
    newTestproblem->Ttitle=Ntitle;
    newTestproblem->Toption1=Noption1;
    newTestproblem->Toption2=Noption2;
    newTestproblem->Toption3=Noption3;
    newTestproblem->Toption4=Noption4;
    newTestproblem->Tanswer=Nanswer;
    newTestproblem->Chooce=@"NoAnswer";
    return newTestproblem;
}




@end


