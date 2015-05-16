//
//  SHRootController.m
//  SHLineGraphView
//
//  Created by SHAN UL HAQ on 23/3/14.
//  Copyright (c) 2014 grevolution. All rights reserved.
//

#import "SHRootController.h"
#import "SHLineGraphView.h"
#import "SHPlot.h"

@interface SHRootController ()

@end

@implementation SHRootController

UIScrollView *scrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itestresults=[Personinfo gettestresults];
    self.testsumtimes=(int)[self.itestresults count];
    if(self.testsumtimes==0){
        [self initundoview];
    }else{
       [self initgraphview];
    }
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;
}
/*
-(void)inittextview{
    NSString *labelstring=[[NSString alloc]initWithFormat:@"该用户一共进行过%i次测试\n",self.testsumtimes];
    for (int i=0; i<[self.itestresults count]; i++) {
        Testresult *thisresult=[self.itestresults objectAtIndex:i];
        NSString *addstring2;
        addstring2=[[NSString alloc]initWithFormat:@"\n#第%i次测试情况：\n",self.testsumtimes-i];
        labelstring=[labelstring stringByAppendingString:addstring2];
        addstring2=[[NSString alloc]initWithFormat:@"    测试类型：%@\n",thisresult->itesttype];
        labelstring=[labelstring stringByAppendingString:addstring2];
        addstring2=[[NSString alloc]initWithFormat:@"    题目总数：%i\n",thisresult->iprossum];
        labelstring=[labelstring stringByAppendingString:addstring2];
        addstring2=[[NSString alloc]initWithFormat:@"    答对总数：%i\n",thisresult->icrtsum];
        labelstring=[labelstring stringByAppendingString:addstring2];
        addstring2=[[NSString alloc]initWithFormat:@"    正确率：%@\n",thisresult->ipercent];
        labelstring=[labelstring stringByAppendingString:addstring2];
        addstring2=[[NSString alloc]initWithFormat:@"    测试时间：%@\n",thisresult->idatetime];
        labelstring=[labelstring stringByAppendingString:addstring2];
    }
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(15, 0, 300, 150)];
    textView.delegate=self;
    textView.text=labelstring;
    textView.editable=NO;
    textView.font = [UIFont fontWithName:@"Arial"size:15.0];//设置字体名字和字体大小
    [self.view addSubview: textView];
    
}
*/
-(void)initundoview{
    UIAlertView *alert;
    alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"你还没有做过任何题目呢！快去测试下吧！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];

}


-(void)initgraphview{
    int length=self.testsumtimes*50;
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 20, 320, [[UIScreen mainScreen] bounds].size.height)];
    scrollView.contentSize = CGSizeMake(length, 100);
    scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scrollView];
    
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    // Do any additional setup after loading the view.
    
    //initate the graph view
    SHLineGraphView *_lineGraph = [[SHLineGraphView alloc] initWithFrame:CGRectMake(0, 0, length, [[UIScreen mainScreen] bounds].size.height-100)];
    
    //set the main graph area theme attributes
    
    /**
     *  theme attributes dictionary. you can specify graph theme releated attributes in this dictionary. if this property is
     *  nil, then a default theme setting is applied to the graph.
     */
    NSDictionary *_themeAttributes = @{
                                       kXAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                       kXAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       kYAxisLabelColorKey : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4],
                                       kYAxisLabelFontKey : [UIFont fontWithName:@"TrebuchetMS" size:10],
                                       kYAxisLabelSideMarginsKey : @20,
                                       kPlotBackgroundLineColorKye : [UIColor colorWithRed:0.48 green:0.48 blue:0.49 alpha:0.4]
                                       };
    _lineGraph.themeAttributes = _themeAttributes;
    
    //set the line graph attributes
    
    /**
     *  the maximum y-value possible in the graph. make sure that the y-value is not in the plotting points is not greater
     *  then this number. otherwise the graph plotting will show wrong results.
     */
    _lineGraph.yAxisRange = @(100);
    
    /**
     *  y-axis values are calculated according to the yAxisRange passed. so you do not have to pass the explicit labels for
     *  y-axis, but if you want to put any suffix to the calculated y-values, you can mention it here (e.g. K, M, Kg ...)
     */
    _lineGraph.yAxisSuffix = @"%";
    
    /**
     *  an Array of dictionaries specifying the key/value pair where key is the object which will identify a particular
     *  x point on the x-axis line. and the value is the label which you want to show on x-axis against that point on x-axis.
     *  the keys are important here as when plotting the actual points on the graph, you will have to use the same key to
     *  specify the point value for that x-axis point.
     */
    //NSString *xAxisValues=@"@[";
    /*
    for (int i=1; i<=self.testsumtimes; i++) {
    
        NSString *addString=[NSString ]
        
    }*/
    NSMutableArray *Xvalues=[[NSMutableArray alloc]initWithCapacity:self.testsumtimes];
    for (int i=0; i<self.testsumtimes; i++) {
       NSDictionary * thisdic = [NSDictionary dictionaryWithObject:[NSString stringWithFormat:@"%d",i+1] forKey:[NSString stringWithFormat:@"%d",i+1]];
        [Xvalues addObject:thisdic];
    }
    
    _lineGraph.xAxisValues = [Xvalues copy];
    
    //create a new plot object that you want to draw on the `_lineGraph`
    SHPlot *_plot1 = [[SHPlot alloc] init];
    
    //set the plot attributes
    
    /**
     *  Array of dictionaries, where the key is the same as the one which you specified in the `xAxisValues` in `SHLineGraphView`,
     *  the value is the number which will determine the point location along the y-axis line. make sure the values are not
     *  greater than the `yAxisRange` specified in `SHLineGraphView`.
     */
    //string类型 进行转换
    //设置每个点的参数值
    NSMutableArray *Yvalues=[[NSMutableArray alloc]initWithCapacity:self.testsumtimes];
    //NSArray *everyitem = [[NSArray alloc] init];
    
    for (int i=self.testsumtimes-1,j=1;i>=0; i--,j++) {
        Testresult *thisresult=[self.itestresults objectAtIndex:i];
        //everyitem= [thisresult->iscore componentsSeparatedByString:@"%"];
        NSNumber *percentage=[NSNumber numberWithInt:thisresult->iscore];
        NSDictionary * thisdic = [NSDictionary dictionaryWithObject:percentage forKey:[NSString stringWithFormat:@"%d",j]];
        NSLog(@"第%d次测试成绩:%@",j,percentage);
        [Yvalues addObject:thisdic];
    }
    _plot1.plottingValues =[Yvalues copy];
    /**
     *  this is an optional array of `NSString` that specifies the labels to show on the particular points. when user clicks on
     *  a particular points, a popover view is shown and will show the particular label on for that point, that is specified
     *  in this array.
     */
    //设置每个点的点击label值
    NSMutableArray *Pdetail=[[NSMutableArray alloc]initWithCapacity:self.testsumtimes];
    
    for (int i=self.testsumtimes-1,j=1; i>=0; i--,j++) {
        NSString *labelstring=@"";
        NSString *addstring=@"";
        Testresult *thisresult=[self.itestresults objectAtIndex:i];
        addstring=[[NSString alloc]initWithFormat:@"#第%d次:\n",j];
        labelstring=[labelstring stringByAppendingString:addstring];
        NSString *type=[[NSString alloc]init];
        /*
        if ([thisresult->itesttype isEqualToString:@"collectionRetest"]) {
             type=@"收藏夹再练";
        } else if ([thisresult->itesttype isEqualToString:@"wrongprosRetest"]){
            type=@"错题本再练";
        }else{
            type=@"随机刷题";
        }*/
        type=@"40题模拟";

        addstring=[[NSString alloc]initWithFormat:@"    测试类型：%@\n",type];
        labelstring=[labelstring stringByAppendingString:addstring];
        addstring=[[NSString alloc]initWithFormat:@"    题目总数：%i\n",40];
        labelstring=[labelstring stringByAppendingString:addstring];
        addstring=[[NSString alloc]initWithFormat:@"    答对题目：%.0f\n",thisresult->iscore/2.5];
        labelstring=[labelstring stringByAppendingString:addstring];
        addstring=[[NSString alloc]initWithFormat:@"    得分：%.1f\n",thisresult->iscore];
        labelstring=[labelstring stringByAppendingString:addstring];
        addstring=[[NSString alloc]initWithFormat:@"    测试时间：%@\n",thisresult->ifinishtime];
        labelstring=[labelstring stringByAppendingString:addstring];
        [Pdetail addObject:labelstring];
    }
    
    //NSArray *arr = @[@"测试类型: Random\n测试题目: 120\n正确率: 100%\n所用时间: 00:10:12", @"2", @"3", @"4", @"5", @"6" , @"7" , @"8", @"9", @"10", @"11", @"12"];
    _plot1.plottingPointsLabels = [Pdetail copy];
    
    //set plot theme attributes
    
    /**
     *  the dictionary which you can use to assing the theme attributes of the plot. if this property is nil, a default theme
     *  is applied selected and the graph is plotted with those default settings.
     */
    
    NSDictionary *_plotThemeAttributes = @{
                                           kPlotFillColorKey : [UIColor colorWithRed:0.47 green:0.75 blue:0.78 alpha:0.5],
                                           kPlotStrokeWidthKey : @2,
                                           kPlotStrokeColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
                                           kPlotPointFillColorKey : [UIColor colorWithRed:0.18 green:0.36 blue:0.41 alpha:1],
                                           kPlotPointValueFontKey : [UIFont fontWithName:@"TrebuchetMS" size:12]
                                           };
    
    _plot1.plotThemeAttributes = _plotThemeAttributes;
    [_lineGraph addPlot:_plot1];
    
    //You can as much `SHPlots` as you can in a `SHLineGraphView`
    
    [_lineGraph setupTheView];
    
    [scrollView addSubview:_lineGraph];
    
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
