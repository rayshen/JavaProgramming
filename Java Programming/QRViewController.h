//
//  ViewController.h
//  NewProject
//
//  Created by 学鸿 张 on 13-11-29.
//  Copyright (c) 2013年 Steven. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface QRViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    int num;
    BOOL upOrdown;
    NSTimer * timer;
   
}
@property (nonatomic, strong) UIImageView * line;
@end
