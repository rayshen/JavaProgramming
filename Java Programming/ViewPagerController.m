//
//  ViewPagerController.m
//  ICViewPager
//
//  Created by Ilter Cengiz on 28/08/2013.
//  Copyright (c) 2013 Ilter Cengiz. All rights reserved.
//

#import "ViewPagerController.h"

#define kDefaultTabHeight 49.0 // Default tab height
#define kDefaultTabOffset 95.0 // Offset of the second and further tabs' from left
#define kDefaultTabWidth 128.0
#define kDefaultTabLocation 1.0 // 1.0: Top, 0.0: Bottom
#define kDefaultStartFromSecondTab 0.0 // 1.0: YES, 0.0: NO
#define kDefaultCenterCurrentTab 0.0 // 1.0: YES, 0.0: NO
#define kPageViewTag 34
#define kDefaultIndicatorColor [UIColor colorWithRed:178.0/255.0 green:203.0/255.0 blue:57.0/255.0 alpha:0.75]
#define kDefaultTabsViewBackgroundColor [UIColor colorWithRed:234.0/255.0 green:234.0/255.0 blue:234.0/255.0 alpha:0.75]
#define kDefaultContentViewBackgroundColor [UIColor colorWithRed:92.0f/255.0f green:172.0f/255.0f blue:238.0f/255.0f alpha:0.75]


// TabView for tabs, that provides un/selected state indicators
@class TabView;

@interface TabView : UIView
@property (nonatomic, getter = isSelected) BOOL selected;
@property (nonatomic) UIColor *indicatorColor;
@end

@implementation TabView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (void)setSelected:(BOOL)selected {
    _selected = selected;
    // Update view as state changed
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *bezierPath;
    
    // Draw top line
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0.0, 0.0)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, 0.0)];
    [[UIColor colorWithWhite:197.0/255.0 alpha:0.75] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    // Draw bottom line
    bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0.0, rect.size.height)];
    [bezierPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height)];
    [[UIColor colorWithWhite:197.0/255.0 alpha:0.75] setStroke];
    [bezierPath setLineWidth:1.0];
    [bezierPath stroke];
    
    // Draw an indicator line if tab is selected
    if (self.selected) {
        
        bezierPath = [UIBezierPath bezierPath];
        
        //画一条指示线
        [bezierPath moveToPoint:CGPointMake(0.0, rect.size.height - 1.0)];
        [bezierPath addLineToPoint:CGPointMake(rect.size.width, rect.size.height - 1.0)];
        [bezierPath setLineWidth:5.0];
        [self.indicatorColor setStroke];
        [bezierPath stroke];
    }
}

@end




// ViewPagerController
@interface ViewPagerController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate>

@property UIPageViewController *pageViewController;
@property (assign) id<UIScrollViewDelegate> origPageScrollViewDelegate;

@property UIView *contentView;
@property UILabel *objnumlabel;
@property UILabel *objtypelabel;


@property NSMutableArray *tabs;
@property NSMutableArray *contents;

@property NSUInteger tabCount;
@property (getter = isAnimatingToTab, assign) BOOL animatingToTab;
@property (nonatomic) NSUInteger activeTabIndex;

@property  int sumObj;
@property Testproblem *curPro;
@property int curproid;

@end

@implementation ViewPagerController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self defaultSettings];
    }
    return self;
}

#pragma mark - View life cycle
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //[self reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [self reloadData];
}
- (void)viewWillLayoutSubviews {
    
    CGRect frame;
    
    frame = _tabsView.frame;
    frame.origin.x = 0.0;
    frame.origin.y = self.tabLocation ? 0.0 : self.view.frame.size.height - self.tabHeight-kDefaultTabHeight;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = self.tabHeight;
    _tabsView.frame = frame;
    
    frame = _contentView.frame;
    frame.origin.x = 0.0;
    frame.origin.y = self.tabLocation ? self.tabHeight : 0.0;
    frame.size.width = self.view.bounds.size.width;
    frame.size.height = self.view.frame.size.height - self.tabHeight;
    _contentView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)handleTapGesture:(id)sender {
    
    self.animatingToTab = YES;
    
    //对点击手势进行识别，获取相应Tab的index
    UITapGestureRecognizer *tapGestureRecognizer = (UITapGestureRecognizer *)sender;
    UIView *tabView = tapGestureRecognizer.view;
    __block NSUInteger index = [_tabs indexOfObject:tabView];
    
    // 根据点击的TAB获取相应index的Viewcontroller
    UIViewController *viewController = [self viewControllerAtIndex:index];
    
    //？？？？啥意思？？为了防止Strong来改变自身，所以用weak？
    // __weak pageViewController to be used in blocks to prevent retaining strong reference to self
    __weak UIPageViewController *weakPageViewController = self.pageViewController;
    __weak ViewPagerController *weakSelf = self;
    
    //NSLog(@"%@",weakPageViewController.view);
    
    //当获取的index>此时正激活着的TAB的index时，进行后退
    if (index < self.activeTabIndex) {
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             //再次设置页面来保持Tab和content的同步
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                            direction:UIPageViewControllerNavigationDirectionReverse
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
    //如果获取index>此时激活着的tab的index，进行前进
    } else if (index > self.activeTabIndex) {
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             //再次设置页面来保持Tab和content的同步

                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                                  direction:UIPageViewControllerNavigationDirectionForward
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
    }
    
    //把获取到的index设置成当前激活着的index  （此句话会执行下面的setActiveTabIndex函数?）
    self.activeTabIndex = index;
}

#pragma mark - 
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    // Re-align tabs if needed
    self.activeTabIndex = self.activeTabIndex;
}

#pragma mark - Setter/Getter
//此函数解释： activeTabIndex前面加set再大写首字母，就成为了设置该变量的方法
//这就是传说中的Setter and Getter
//@property 设置的变量都有这样的功能

//唯一每次切换页面都被执行的函数
- (void)setActiveTabIndex:(NSUInteger)activeTabIndex {
    
    TabView *activeTabView;
    //设置之前index的Tab为未选中状态
    activeTabView = [self tabViewAtIndex:self.activeTabIndex];
    activeTabView.selected = NO;
    
    //设置新选中的index的Tab为选中状态
    activeTabView = [self tabViewAtIndex:activeTabIndex];
    activeTabView.selected = YES;
    
    //设置当前激活的tab的index
    _activeTabIndex = activeTabIndex;
    NSLog(@"setActiveTabIndex此处被执行,当前在第%i页",(int)_activeTabIndex);
    
    [self setobjnumlabel:(int)_activeTabIndex];
    
    //设置收藏情况的显示
    self.curproid=[Examinfo getproid:(int)_activeTabIndex];
    NSLog(@"该题目的ID为：%i",self.curproid);
    BOOL ifcollect=[Personinfo checkproisCollect:self.curproid];
    [self.dataSource viewPager:self collected:ifcollect];

    // Inform delegate about the change
    if ([self.delegate respondsToSelector:@selector(viewPager:didChangeTabToIndex:)]) {
        [self.delegate viewPager:self didChangeTabToIndex:self.activeTabIndex];
    }
    //把新激活的Tab居中显示
    UIView *tabView = [self tabViewAtIndex:self.activeTabIndex];
    CGRect frame = tabView.frame;
    
    if (self.centerCurrentTab) {
        
        frame.origin.x += (frame.size.width / 2);
        frame.origin.x -= _tabsView.frame.size.width / 2;
        frame.size.width = _tabsView.frame.size.width;
        
        if (frame.origin.x < 0) {
            frame.origin.x = 0;
        }
        
        if ((frame.origin.x + frame.size.width) > _tabsView.contentSize.width) {
            frame.origin.x = (_tabsView.contentSize.width - _tabsView.frame.size.width);
        }
    } else {
        
        frame.origin.x -= self.tabOffset;
        frame.size.width = self.tabsView.frame.size.width;
    }
    
    [_tabsView scrollRectToVisible:frame animated:YES];
}

#pragma mark -
- (void)defaultSettings {
    
    //默认设置
    _tabHeight = kDefaultTabHeight;
    _tabOffset = kDefaultTabOffset;
    _tabWidth = kDefaultTabWidth;
    
    _tabLocation = kDefaultTabLocation;
    
    _startFromSecondTab = kDefaultStartFromSecondTab;
    
    _centerCurrentTab = kDefaultCenterCurrentTab;
    
    //默认的颜色
    _indicatorColor = kDefaultIndicatorColor;
    _tabsViewBackgroundColor = kDefaultTabsViewBackgroundColor;
    _contentViewBackgroundColor = kDefaultContentViewBackgroundColor;
    
    // pageViewController的设置
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:nil];
    
    //看不懂？？？？？？？？
    //Setup some forwarding events to hijack the scrollview
    self.origPageScrollViewDelegate = ((UIScrollView*)[_pageViewController.view.subviews objectAtIndex:0]).delegate;
    [((UIScrollView*)[_pageViewController.view.subviews objectAtIndex:0]) setDelegate:self];
    
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    
    self.animatingToTab = NO;
}




//每次该类运行时执行的函数，非常重要！！
- (void)reloadData {

    //NSLog(@"执行了ViewPager的reloadData函数！！！");
    //如果提供了参数的话进行设置，否则默认，此delegate在HostViewController中有实现
    if ([self.delegate respondsToSelector:@selector(viewPager:valueForOption:withDefault:)]) {
        _tabHeight = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabHeight withDefault:kDefaultTabHeight];
        _tabOffset = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabOffset withDefault:kDefaultTabOffset];
        _tabWidth = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabWidth withDefault:kDefaultTabWidth];
        _tabLocation = [self.delegate viewPager:self valueForOption:ViewPagerOptionTabLocation withDefault:kDefaultTabLocation];
        _startFromSecondTab = [self.delegate viewPager:self valueForOption:ViewPagerOptionStartFromSecondTab withDefault:kDefaultStartFromSecondTab];
        _centerCurrentTab = [self.delegate viewPager:self valueForOption:ViewPagerOptionCenterCurrentTab withDefault:kDefaultCenterCurrentTab];
    }

    //每次刷新清空tabs和contents
    [_tabs removeAllObjects];
    [_contents removeAllObjects];
    [self.objnumlabel removeFromSuperview];
    [self.objtypelabel removeFromSuperview];
    _tabCount = [Examinfo getsumobj];
    
    //初始化数组
    _tabs = [NSMutableArray arrayWithCapacity:_tabCount];
    for (int i = 0; i < _tabCount; i++) {
        [_tabs addObject:[NSNull null]];
    }
    
    _contents = [NSMutableArray arrayWithCapacity:_tabCount];
    for (int i = 0; i < _tabCount; i++) {
        [_contents addObject:[NSNull null]];
    }
    
    //============================================================
    // 加入tabsView tabsview是整一个滑动条
    _tabsView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.tabHeight)];
    _tabsView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _tabsView.backgroundColor = self.tabsViewBackgroundColor;
    _tabsView.showsHorizontalScrollIndicator = NO;
    _tabsView.showsVerticalScrollIndicator = NO;
    
    //把各个小的tab views加入到_tabsView滑动条里
    CGFloat contentSizeWidth = 0;
    for (int i = 0; i < _tabCount; i++) {
        
        UIView *tabView = [self tabViewAtIndex:i];
        
        CGRect frame = tabView.frame;
        frame.origin.x = contentSizeWidth;
        frame.size.width = self.tabWidth;
        tabView.frame = frame;
        
        [_tabsView addSubview:tabView];
        
        contentSizeWidth += tabView.frame.size.width;
        
        //获得tabview的点击事件
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        [tabView addGestureRecognizer:tapGestureRecognizer];
    }
    
    _tabsView.contentSize = CGSizeMake(contentSizeWidth, self.tabHeight);
    
    //==============================================================
    //加入contentView
    _contentView = [self.view viewWithTag:kPageViewTag];
    _contentView = _pageViewController.view;

    _contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _contentView.backgroundColor = self.contentViewBackgroundColor;
    _contentView.bounds = self.view.bounds;
    _contentView.tag = kPageViewTag;
    
    [self.view insertSubview:_contentView atIndex:0];
    
    //加入一个显示的label
    self.objnumlabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 20)];
    self.objnumlabel.text=@"0/0";
    self.objnumlabel.font=[UIFont systemFontOfSize:22];
    self.objnumlabel.textColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    [self.view insertSubview:self.objnumlabel atIndex:3];
    
    
    //加入一个显示的label
    self.objtypelabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 20)];
    self.objtypelabel.text=@"类型：XX";
    [self.objtypelabel setTextAlignment:NSTextAlignmentCenter];
    self.objtypelabel.font=[UIFont systemFontOfSize:22];
    self.objtypelabel.textColor=[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1];
    [self.view insertSubview:self.objtypelabel atIndex:3];
    

    //==============================================================
    //是否从第一个页面开始
    UIViewController *viewController;
    
    if (self.startFromSecondTab) {
        viewController = [self viewControllerAtIndex:1];
    } else {
        viewController = [self viewControllerAtIndex:0];
    }
    
    if (viewController == nil) {
        viewController = [[UIViewController alloc] init];
        viewController.view = [[UIView alloc] init];
    }
    
    [_pageViewController setViewControllers:@[viewController]
                                  direction:UIPageViewControllerNavigationDirectionForward
                                   animated:NO
                                 completion:nil];
    
    //设置激活的tabindex
    self.activeTabIndex = self.startFromSecondTab;
}


-(void)jumptoindex:(int)index{
    
    // 根据点击的TAB获取相应index的Viewcontroller
    UIViewController *viewController = [self viewControllerAtIndex:index];
    
    //？？？？啥意思？？为了防止Strong来改变自身，所以用weak？
    // __weak pageViewController to be used in blocks to prevent retaining strong reference to self
    __weak UIPageViewController *weakPageViewController = self.pageViewController;
    __weak ViewPagerController *weakSelf = self;
    
    //NSLog(@"%@",weakPageViewController.view);
    
    //当获取的index>此时正激活着的TAB的index时，进行后退
    if (index < self.activeTabIndex) {
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             //再次设置页面来保持Tab和content的同步
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                                  direction:UIPageViewControllerNavigationDirectionReverse
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
        //如果获取index>此时激活着的tab的index，进行前进
    } else if (index > self.activeTabIndex) {
        [self.pageViewController setViewControllers:@[viewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             //再次设置页面来保持Tab和content的同步
                                             
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[viewController]
                                                                                  direction:UIPageViewControllerNavigationDirectionForward
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
    }
    
    //把获取到的index设置成当前激活着的index  （此句话会执行下面的setActiveTabIndex函数?）
    self.activeTabIndex = index;
}

-(BOOL)gotoprepage{
    NSInteger index=self.activeTabIndex;
    if (index>0) {
        UIViewController *previewController = [self viewControllerAtIndex:index-1];
        __weak UIPageViewController *weakPageViewController = self.pageViewController;
        __weak ViewPagerController *weakSelf = self;
        [self.pageViewController setViewControllers:@[previewController]
                                          direction:UIPageViewControllerNavigationDirectionReverse
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             //再次设置页面来保持Tab和content的同步
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[previewController]
                                                             direction:UIPageViewControllerNavigationDirectionReverse
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
        [self setActiveTabIndex:index-1];
        index--;
        return true;

    }else{
        NSLog(@"已到第一页！！");
        return false;
    }

}

-(BOOL)gotonextpage{
    NSInteger index=self.activeTabIndex;
    //NSLog(@"当前为第%i页！！",index);
    if (index<_tabCount-1) {
        UIViewController *nextviewController = [self viewControllerAtIndex:index+1];
        __weak UIPageViewController *weakPageViewController = self.pageViewController;
        __weak ViewPagerController *weakSelf = self;
        [self.pageViewController setViewControllers:@[nextviewController]
                                          direction:UIPageViewControllerNavigationDirectionForward
                                           animated:YES
                                         completion:^(BOOL completed) {
                                             weakSelf.animatingToTab = NO;
                                             
                                             //再次设置页面来保持Tab和content的同步
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakPageViewController setViewControllers:@[nextviewController]
                                                                                direction:UIPageViewControllerNavigationDirectionForward
                                                                                   animated:NO
                                                                                 completion:nil];
                                             });
                                         }];
        [self setActiveTabIndex:index+1];
        index++;
        return true;
        
    }else{
        NSLog(@"已到最后页！！");
        return false;
    }
}

-(int)getcurindex{
    return (int)self.activeTabIndex;
}

//加入滚动条
-(void)insertTabsView{
    [self.view insertSubview:_tabsView atIndex:1];
}

//删除滚动条
-(void)hideTabsView{
    [_tabsView removeFromSuperview];
}

-(void)setobjnumlabel:(int)index{
    
    self.objnumlabel.text=[NSString stringWithFormat:@"%d/%d",index+1,(int)_tabCount];
    
    switch ([Examinfo getProblem:index]->Ttype) {
        case 1:
            self.objtypelabel.text=@"单项选择";
            break;
        case 2:
            self.objtypelabel.text=@"多项选择";
            break;
        case 3:
            self.objtypelabel.text=@"判断题";
            break;
        default:
            break;
    }
}

-(Testproblem *)getcurpro{
    return self.curPro;
}

-(int)getcurproid{
    return self.curproid;
}

- (TabView *)tabViewAtIndex:(NSUInteger)index {
    
    if (index >= _tabCount) {
        return nil;
    }
    
    if ([[_tabs objectAtIndex:index] isEqual:[NSNull null]]) {

        //委托给Hostviewcontroller执行的函数   每次执行后都返回一个UIView（这里是每个滑动tab块的内容）
        UIView *tabViewContent = [self.dataSource viewPager:self viewForTabAtIndex:index];
        
        //创建TabView以及把获得的content加入进去
        TabView *tabView = [[TabView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tabWidth, self.tabHeight)];
        [tabView addSubview:tabViewContent];
        [tabView setClipsToBounds:YES];
        [tabView setIndicatorColor:self.indicatorColor];
        
        tabViewContent.center = tabView.center;
        
        //把之前tabview里的空Object替换掉
        [_tabs replaceObjectAtIndex:index withObject:tabView];
    }
    
    return [_tabs objectAtIndex:index];
}


//tabview查询函数，返回某个tabview的index
- (NSUInteger)indexForTabView:(UIView *)tabView {
    
    return [_tabs indexOfObject:tabView];
}


- (UIViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    if (index >= _tabCount) {
        return nil;
    }
    //如果该index下object未加载，则加载
    if ([[_contents objectAtIndex:index] isEqual:[NSNull null]]) {
        
        UIViewController *viewController;
        //判断datasource是否实现了该方法
        if ([self.dataSource respondsToSelector:@selector(viewPager:contentViewControllerForTabAtIndex:)]) {
            //实现了，则调用，每次执行后都返回一个UIViewController（这里是每个滑动ContentViewController的内容）
            viewController = [self.dataSource viewPager:self contentViewControllerForTabAtIndex:index];
        }else {
            viewController = [[UIViewController alloc] init];
            viewController.view = [[UIView alloc] init];
        }

        [_contents replaceObjectAtIndex:index withObject:viewController];
    }
    
    return [_contents objectAtIndex:index];
}

//查询某个Viewcontroller的index的函数
- (NSUInteger)indexForViewController:(UIViewController *)viewController {
    
    return [_contents indexOfObject:viewController];
}


//对UIPageViewController的委托的实现
#pragma mark - UIPageViewControllerDataSource
//向前index++
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexForViewController:viewController];
    index++;
    return [self viewControllerAtIndex:index];
}
//向后index--
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = [self indexForViewController:viewController];
    index--;
    return [self viewControllerAtIndex:index];
}

#pragma mark - UIPageViewControllerDelegate
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers {
//    NSLog(@"willTransitionToViewController: %i", [self indexForViewController:[pendingViewControllers objectAtIndex:0]]);
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed {
    
    UIViewController *viewController = self.pageViewController.viewControllers[0];
    self.activeTabIndex = [self indexForViewController:viewController];
}


//对UIscrollViewController的委托的实现
#pragma mark - UIScrollViewDelegate, Responding to Scrolling and Dragging
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidScroll:)]) {
        [self.origPageScrollViewDelegate scrollViewDidScroll:scrollView];
    }
    
    if (![self isAnimatingToTab]) {
        UIView *tabView = [self tabViewAtIndex:self.activeTabIndex];
        
        // Get the related tab view position
        CGRect frame = tabView.frame;
        
        CGFloat movedRatio = (scrollView.contentOffset.x / scrollView.frame.size.width) - 1;
        frame.origin.x += movedRatio * frame.size.width;
        
        if (self.centerCurrentTab) {
            
            frame.origin.x += (frame.size.width / 2);
            frame.origin.x -= _tabsView.frame.size.width / 2;
            frame.size.width = _tabsView.frame.size.width;
            
            if (frame.origin.x < 0) {
                frame.origin.x = 0;
            }
            
            if ((frame.origin.x + frame.size.width) > _tabsView.contentSize.width) {
                frame.origin.x = (_tabsView.contentSize.width - _tabsView.frame.size.width);
            }
        } else {
            
            frame.origin.x -= self.tabOffset;
            frame.size.width = self.tabsView.frame.size.width;
        }
        
        [_tabsView scrollRectToVisible:frame animated:YES];
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)]) {
        [self.origPageScrollViewDelegate scrollViewWillBeginDragging:scrollView];
    }
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillEndDragging:withVelocity:targetContentOffset:)]) {
        [self.origPageScrollViewDelegate scrollViewWillEndDragging:scrollView withVelocity:velocity targetContentOffset:targetContentOffset];
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
}
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewShouldScrollToTop:)]) {
        return [self.origPageScrollViewDelegate scrollViewShouldScrollToTop:scrollView];
    }
    return NO;
}
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidScrollToTop:)]) {
        [self.origPageScrollViewDelegate scrollViewDidScrollToTop:scrollView];
    }
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)]) {
        [self.origPageScrollViewDelegate scrollViewWillBeginDecelerating:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndDecelerating:scrollView];
    }
}

#pragma mark - UIScrollViewDelegate, Managing Zooming
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(viewForZoomingInScrollView:)]) {
        return [self.origPageScrollViewDelegate viewForZoomingInScrollView:scrollView];
    }
    
    return nil;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewWillBeginZooming:withView:)]) {
        [self.origPageScrollViewDelegate scrollViewWillBeginZooming:scrollView withView:view];
    }
}
- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndZooming:withView:atScale:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndZooming:scrollView withView:view atScale:scale];
    }
}
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidZoom:)]) {
        [self.origPageScrollViewDelegate scrollViewDidZoom:scrollView];
    }
}

#pragma mark - UIScrollViewDelegate, Responding to Scrolling Animations
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if ([self.origPageScrollViewDelegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)]) {
        [self.origPageScrollViewDelegate scrollViewDidEndScrollingAnimation:scrollView];
    }
}

@end
