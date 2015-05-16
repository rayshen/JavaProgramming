//
//  BGRadioView.m
//  Listbingo
//
//  Created by Bishal Ghimire on 5/29/13.
//  Copyright (c) 2013 Bishal Ghimire. All rights reserved.
//

#import "BGRadioView.h"

@implementation BGRadioView

@synthesize optionNo;
@synthesize answerNo;

@synthesize editable;
@synthesize maxRow;
@synthesize rowItems;

@synthesize delegate;
@synthesize tag;
@synthesize rowHeight;

int selectedRow = -1;
#pragma mark - Table View

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return maxRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";
    //设置分割线不可见
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [tableView setBackgroundColor:[UIColor clearColor]];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[UIColor clearColor]];
    UILabel *labelOne = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 300, 45)];
    [labelOne setBackgroundColor:[UIColor clearColor]];
    [labelOne setTextColor:[UIColor blackColor]];
    NSString *textString = [[NSString alloc] init];
    textString = @"\u2001"; // blank unicode char to represent uncheck

    
    //结束的情况下，显示正确答案
    if ([Examinfo ifisfinish]) {
        if(optionNo==answerNo){
            //单选答案一样，就显示绿色
            if (indexPath.row == optionNo) {
                textString = @"\u2713"; // check unicode char
                [labelOne setTextColor:[UIColor greenColor]];
            }
        }else{
            //单选答案不一样，错误用红色，正确用绿色
            if (indexPath.row == answerNo) {
                textString = @"\u2713"; // check unicode char
                [labelOne setTextColor:[UIColor greenColor]];
            }
            if (indexPath.row == optionNo) {
                //textString = @"\u2713"; // check unicode char
                [labelOne setTextColor:[UIColor redColor]];
            }
        }
        
    }else{
        if (indexPath.row == optionNo) {
            textString = @"\u2713"; // check unicode char
            [labelOne setTextColor:[UIColor whiteColor]];
        }
    }
    

    textString = [textString stringByAppendingString:[rowItems objectAtIndex:indexPath.row]];
    
    labelOne.textAlignment = UITextAlignmentLeft;
    labelOne.text = textString;
    labelOne.numberOfLines = 2;
    labelOne.lineBreakMode = UILineBreakModeWordWrap;
    [cell.contentView addSubview:labelOne];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    optionNo = indexPath.row;
    [self.delegate radioView:self didSelectOption:indexPath.row];
    [tableView reloadData];
}

- (void)setRating:(float)rating {
    rating = rating;
}

- (void)handleTouchAtLocation {
    if (!self.editable) return;
    int newRating = 0;
    self.rating = newRating;
}

//  This function gets called whenever the frame of our view changes, and we’re
// expected to set up the frames of all of our subviews to the appropriate size for that space.
- (void)layoutSubviews {
    [super layoutSubviews];
}

/* we support both initWithFrame and initWithCoder so that our view controller
 can add us via a XIB or programatically. */
- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}


/* we initialize our instance variables to default values */
-(void) baseInit {
    selectedRow = optionNo;
    optionNo = 0;
    editable = NO;
    // maxRow = 4;
    delegate = nil;
    rowItems = [[NSMutableArray alloc]init];
    
    // Make TableView
    UITableView* tableView = [[UITableView alloc] initWithFrame:self.bounds];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.bounces = NO;
    [tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [tableView setBackgroundColor:[UIColor clearColor]];

    
    [self addSubview:tableView];
}



@end
