//
//  EditSchoolViewController.m
//  Java Programming
//
//  Created by way on 14-7-22.
//  Copyright (c) 2014年 rayshen. All rights reserved.
//

#import "EditSchoolViewController.h"

@interface EditSchoolViewController ()

@end

@implementation EditSchoolViewController

UITableView *areaTableView;

LocalDataDB *newDB;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addunivchoose];
    
    [self.view setBackgroundColor:[UIColor colorWithRed:234.0f/255.0f green:234.0f/255.0f blue:234.0f/255.0f alpha:1]];
    
    province = @"";
    city = @"";
    area = @"";
    selectType = PROVINCE;
    
    [self readData];
    
    switch (selectType) {
        case 0:
            self.navigationController.title=@"选择省份";
            break;
        case 1:
            self.navigationController.title=@"选择城市";
            break;
        case 2:
            self.navigationController.title=@"选择学校";
            break;
        default:
            break;
    }
}


-(void)readData{
    newDB=[[LocalDataDB alloc]init];
    [newDB createDB];
    provinces=[newDB selectProvincelist];
    NSLog(@"共有省份%d",(int)[provinces count]);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)addunivchoose{
    areaTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, [[UIScreen mainScreen] bounds].size.height-64) style:UITableViewStylePlain];
    [areaTableView setDelegate:self];
    [areaTableView setDataSource:self];
    [self.view addSubview:areaTableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (selectType) {
        case PROVINCE:
            return [provinces count];
        case CITY:
            return [cities count];
        default:
            return [areas count];
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    int index = (int)[indexPath row];
    //int section = [indexPath section];
    static NSString* CustomCellIdentifier = @"NerveAreaSelectorCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomCellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CustomCellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    switch (selectType) {
        case PROVINCE:
            cell.textLabel.text = [provinces objectAtIndex:index];
            break;
        case CITY:
            cell.textLabel.text = [cities objectAtIndex:index];
            break;
        default:
            cell.textLabel.text = [areas objectAtIndex:index];
            cell.accessoryType = UITableViewCellAccessoryNone;
            break;
    }
    
    return cell;
}

//表格被选择
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    int selectIndex = [indexPath row];
    int cellCount = 0;
    switch (selectType) {
        case PROVINCE:
            province = [provinces objectAtIndex:selectIndex];
            cities = [newDB selectCitylist:province];
            selectType = CITY;
            cellCount = [cities count];
            break;
        case CITY:
            city = [cities objectAtIndex:selectIndex];
            areas = [newDB selectSchoollist:city];
            selectType = AREA;
            cellCount = [areas count];
            break;
        default:
            area = [areas objectAtIndex:selectIndex];
            [Personinfo setischool:area];
            
            [Personinfo setUnivID:[newDB selectUnivID:area]];
            
            [NSThread detachNewThreadSelector:@selector(updateUser) toTarget:self withObject:nil];
            
            [self.navigationController popViewControllerAnimated:YES];
            
            break;
    }
    
    NSString* areaValue = [NSString stringWithFormat:@"%@ %@ %@",province, city,area];
    NSLog(@"select=%@", areaValue);
    
    [areaTableView reloadData];
    
    if(cellCount > 0){
        NSIndexPath* topIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [areaTableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)updateUser{
    [Personinfo updatepersoninfo];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
