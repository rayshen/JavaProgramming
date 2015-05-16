//
//  ResultBoardViewController.h
//  Java Programming
//
//  Created by rayshen on 5/4/14.
//  Copyright (c) 2014 rayshen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IOSTimelabel.h"
#import "Examinfo.h"
@interface ResultBoardViewController : UIViewController

@property int sumObj;
@property int points;
@property NSTimeInterval usingtime;
@property (weak, nonatomic) IBOutlet UILabel *pointslabel;
@property (weak, nonatomic) IBOutlet UILabel *sumobjlabel;
@property (weak, nonatomic) IBOutlet UILabel *CP;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;

@end
