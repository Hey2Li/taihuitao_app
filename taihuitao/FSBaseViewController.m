//
//  FSBaseViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSBaseViewController.h"
#import "FSBaseTableView.h"
#import "FSBaseTopTableViewCell.h"
#import "FSScrollContentView.h"
#import "FSScrollContentViewController.h"
#import "FSBottomTableViewCell.h"
#import <PYSearch.h>
#import "ArticleDetailViewController.h"

#define CATEGORY @[@"推荐",@"断货王",@"妆心得",@"美食番",@"品牌购",@"汇生活"]

@interface FSBaseViewController ()<UITableViewDelegate,UITableViewDataSource,FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) FSBaseTableView *tableView;
@property (nonatomic, strong) FSBottomTableViewCell *contentCell;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) NSArray *topTitleArray;
@property (nonatomic, strong) NSMutableArray *controllersArray;
@end

@implementation FSBaseViewController

- (NSMutableArray *)controllersArray{
    if (!_controllersArray) {
        _controllersArray = [NSMutableArray array];
    }
    return _controllersArray;
}
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeScrollStatus) name:@"leaveTop" object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSubViews];
    [self initWithNavi];
    [self loadData];
}
- (void)loadData{
    [LTHttpManager THomeDataWithLimit:@5 Page:@1 Nlimit:@10 Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            self.topTitleArray = data[@"responseData"][@"column"];
            [self.controllersArray removeAllObjects];
            for (NSDictionary *dic in self.topTitleArray) {
                FSScrollContentViewController *vc = [[FSScrollContentViewController alloc]init];
                vc.str = dic[@"id"];
                [self.controllersArray addObject:vc];
            }
            [self.tableView reloadData];
        }
    }];
}
- (void)initWithNavi{
    UIImage *leftImage = [[UIImage imageNamed:@"搜索"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStyleDone target:self action:@selector(searchBtnClick:)];
    self.navigationItem.leftBarButtonItem = leftBarItem;
    UIImage *rightImage = [[UIImage imageNamed:@"扫一扫"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(qrCodeBtnClick)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (void)searchBtnClick:(UIButton *)btn{
    NSArray *hotSeaches = @[@"原创",@"漫画", @"搞笑", @"热点", @"视频", @"美食", @"动物圈", @"娱乐圈"];
    // 2. Create searchViewController
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"  " didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Call this Block when completion search automatically
        // Such as: Push to a view controller
        ArticleDetailViewController *vc = [[ArticleDetailViewController alloc]init];
        [searchViewController.navigationController pushViewController:vc animated:YES];
    }];
    
    // 3. present the searchViewController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.navigationController.navigationBar.backIndicatorImage =  [[UIImage imageNamed:@"返回白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    searchViewController.navigationController.navigationBar.backIndicatorTransitionMaskImage = [[UIImage imageNamed:@"返回白"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    //去掉左边的title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //自定义一个NavigationBar
    [searchViewController.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    searchViewController.navigationController.navigationBar.shadowImage = [UIImage new];
    //PingFangSC
    searchViewController.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Light" size:18],NSFontAttributeName, nil];
    [searchViewController.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:nav  animated:NO completion:nil];
}
- (void)setupSubViews
{
    self.canScroll = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
//    __weak typeof(self) weakSelf = self;
//    [self.tableView addPullToRefreshWithActionHandler:^{
//        [weakSelf insertRowAtTop];
//    }];
}

- (void)insertRowAtTop
{
    self.contentCell.currentTagStr = CATEGORY[self.titleView.selectIndex];
    self.contentCell.isRefresh = YES;
//    [self.tableView.pullToRefreshView stopAnimating];
}

#pragma mark notify
- (void)changeScrollStatus//改变主视图的状态
{
    self.canScroll = YES;
    self.contentCell.cellCanScroll = NO;
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 1;
    }
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 200;
        }
    }
    return CGRectGetHeight(self.view.bounds);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 50) titles:self.topTitleArray delegate:self indicatorType:FSIndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor whiteColor];
    return self.titleView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *FSBaseTopTableViewCellIdentifier = @"FSBaseTopTableViewCellIdentifier";
    if (indexPath.section == 1) {
        _contentCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!_contentCell) {
            _contentCell = [[FSBottomTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            _contentCell.viewControllers = self.controllersArray;
        }
        _contentCell.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, SCREEN_HEIGHT - 64) childVCs:self.controllersArray parentVC:self delegate:self];
        [_contentCell.contentView addSubview:_contentCell.pageContentView];
        return _contentCell;
    }
    if (indexPath.row == 0) {
        FSBaseTopTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FSBaseTopTableViewCellIdentifier];
        if (!cell) {
            cell = [[FSBaseTopTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FSBaseTopTableViewCellIdentifier];
        }
        return cell;
    }
    return nil;
}

#pragma mark FSSegmentTitleViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    _tableView.scrollEnabled = YES;//此处其实是监测scrollview滚动，pageView滚动结束主tableview可以滑动，或者通过手势监听或者kvo，这里只是提供一种实现方式
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.contentCell.pageContentView.contentViewCurrentIndex = endIndex;
}

- (void)FSContentViewDidScroll:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex progress:(CGFloat)progress
{
    _tableView.scrollEnabled = NO;//pageView开始滚动主tableview禁止滑动
}

#pragma mark UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat bottomCellOffset = [_tableView rectForSection:1].origin.y;
    if (scrollView.contentOffset.y >= bottomCellOffset) {
        scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        if (self.canScroll) {
            self.canScroll = NO;
            self.contentCell.cellCanScroll = YES;
        }
    }else{
        if (!self.canScroll) {//子视图没到顶部
            scrollView.contentOffset = CGPointMake(0, bottomCellOffset);
        }
    }
    self.tableView.showsVerticalScrollIndicator = _canScroll?YES:NO;
}

#pragma mark LazyLoad
- (FSBaseTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[FSBaseTableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.bounces = NO;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

@end
