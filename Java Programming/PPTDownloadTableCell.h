//
//  PPTDownloadTableCell.h
//  Java Programming
//
//  Created by way on 14-7-9.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PPTDownloadTableCell : UITableViewCell
//@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *DownloadButton;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property BOOL isDown;
@end
