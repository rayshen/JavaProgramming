//
//  Testproblems.h
//  Java Programming
//
//  Created by rayshen on 4/26/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Testproblem : NSObject
{
    @public int         Tid;
    @public int         Ttype;
    @public NSString    *Ttitle;
    @public NSString    *Toption1;
    @public NSString    *Toption2;
    @public NSString    *Toption3;
    @public NSString    *Toption4;
    @public NSString    *Tanswer;
    @public NSString    *Chooce;
    @public BOOL ismark;
    @public BOOL ifright;
    //以上基本属性
    @public int         *Tchapter;
}

-(Testproblem *)create:(int)Nid valueoftype:(int)Ntype valueoftitle:(NSString*)Ntitle valueofoption1:(NSString *)Noption1 valueofoption2:(NSString *)Noption2 valueofoption3:(NSString *)Noption3 valueofoption4:(NSString *)Noption4 as:(NSString *)Nanswer;

@end
