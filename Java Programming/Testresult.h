//
//  Testresult.h
//  Java Programming
//
//  Created by way on 5/21/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Testresult : NSObject
{
    @public int iuserid;
    @public NSString * iaccount;
    @public NSString *itestkindType;
    @public float iscore;
    @public NSString * istarttime;
    @public NSString * ifinishtime;
}

-(Testresult *)inittestresult:(int)userid vfaccount:(NSString *)account vftestkindType:(NSString *)type vfscore:(float)score vfstarttime:(NSString *)starttime vffinishtime:(NSString *)finishtime;
@end

