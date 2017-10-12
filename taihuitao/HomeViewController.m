 //
//  HomeViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/17.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "HomeViewController.h"
#import "NaviView.h"
#import "JSDTableViewController.h"
#import "JQRefreshHeaader.h"
#import "ArticleDetailViewController.h"
#import "NavigationGradientBar.h"
#import <PYSearch.h>
#import "TYTabButtonPagerController.h"

#define CATEGORY @[@"推荐",@"断货王",@"妆心得",@"美食番",@"品牌购",@"汇生活"]
#define NAVBARHEIGHT 64.0f

#define FONTMAX 15.0
#define FONTMIN 14.0
#define PADDING 15.0

@interface HomeViewController ()<UIScrollViewDelegate,TYPagerControllerDataSource>
@property (nonatomic, strong) UITableView *currentTableView;
@property (nonatomic, strong) NaviView *naviView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) UIScrollView *segmentScrollView;
@property (nonatomic, strong) UIImageView *currentSelectedItemImageView;
@property (nonatomic, strong) UIScrollView *bottomScrollView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *qrCodeButton;

//存放button
@property(nonatomic,strong)NSMutableArray *titleButtons;
//记录上一个button
@property (nonatomic, strong) UIButton *previousButton;
//存放控制器
@property(nonatomic,strong)NSMutableArray *controlleres;
//存放TableView
@property(nonatomic,strong)NSMutableArray *tableViews;

//记录上一个偏移量
@property (nonatomic, assign) CGFloat lastTableViewOffsetY;

@property (nonatomic, strong) UIImageView *barImageView;
@property (nonatomic,strong) NavigationGradientBar * navigationBar;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) TYTabButtonPagerController *pagerController;
@property (nonatomic, strong) UIScrollView *myScrollView;
@end

@implementation HomeViewController

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.myScrollView];
    }
    return self;
}
- (UIScrollView *)myScrollView{
    if (!_myScrollView) {
        _myScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, ScreenHeight)];
        _myScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, ScreenHeight + 200);
    }
    return _myScrollView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
    [self initWithNavi];
    [self initWithView];
    [self addPagerController];
    self.myScrollView.delegate = self;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (1) {
//        CGFloat tableViewoffsetY = scrollView.contentOffset.y;
//        if (tableViewoffsetY >=  0 && tableViewoffsetY <= 200) {
//            self.cycleScrollView.frame =CGRectMake(0, 264 - tableViewoffsetY, SCREEN_WIDTH, 200);
//       }else if( tableViewoffsetY < 0){
//            self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
//        }else if (tableViewoffsetY > 200){
//            self.cycleScrollView.frame = CGRectMake(0, -200, SCREEN_WIDTH, 200);
//        }
//    }else{
//
//    }
//    CGFloat tableViewoffsetY = scrollView.contentOffset.y;
//    self.lastTableViewOffsetY = tableViewoffsetY;
//    if (tableViewoffsetY >=  0 && tableViewoffsetY <= 200) {
//        self.cycleScrollView.frame =CGRectMake(0, 0 - tableViewoffsetY, SCREEN_WIDTH, 200);
//        self.pagerController.view.frame = CGRectMake(0, 200 - tableViewoffsetY, SCREEN_WIDTH, SCREEN_HEIGHT );
//    }else if( tableViewoffsetY < 0){
//        self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
//        self.pagerController.view.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT );
//    }else if (tableViewoffsetY > 200){
//        self.cycleScrollView.frame = CGRectMake(0, -200, SCREEN_WIDTH, 200);
//        self.pagerController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    }
    NSLog(@"%f",scrollView.contentOffset.y);
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    UITableView *tableView = (UITableView *)object;
    
//    if (!(self.currentTableView == tableView)) {
//        return;
//    }
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    CGFloat tableViewoffsetY = tableView.contentOffset.y;
    self.lastTableViewOffsetY = tableViewoffsetY;
    NSLog(@"%f",tableViewoffsetY);
    if (tableViewoffsetY >=  0 && tableViewoffsetY <= 200) {
        self.cycleScrollView.frame =CGRectMake(0, 0 - tableViewoffsetY, SCREEN_WIDTH, 200);
        self.pagerController.view.frame = CGRectMake(0, 200 - tableViewoffsetY, SCREEN_WIDTH, SCREEN_HEIGHT );
        self.myScrollView.scrollEnabled = NO;
    }else if( tableViewoffsetY < 0){
        self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        self.pagerController.view.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT );
        self.myScrollView.scrollEnabled = NO;
    }else if (tableViewoffsetY > 200){
        self.cycleScrollView.frame = CGRectMake(0, -200, SCREEN_WIDTH, 200);
        self.pagerController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        self.myScrollView.scrollEnabled = YES;
    }
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
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
- (void)initWithView{
    [self.myScrollView addSubview:self.cycleScrollView];
}
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        NSMutableArray *imageMutableArray = [NSMutableArray array];
        for (int i = 1; i<9; i++) {
            NSString *imageName = [NSString stringWithFormat:@"cycle_%02d.jpg",i];
            [imageMutableArray addObject:imageName];
        }
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"heart-grey-sm"];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"heart-red"];
        _cycleScrollView.showPageControl = NO;
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200) imageNamesGroup:imageMutableArray];
    }
    return _cycleScrollView;
}
- (void)loadData{
    WeakSelf
    [LTHttpManager THomeDataWithLimit:@4 Page:@1 Nlimit:@10 Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            NSArray *array = data[@"responseData"][@"column"];
            [weakSelf.titleArray removeAllObjects];
            for (NSDictionary *dic in array) {
                [weakSelf.titleArray addObject:dic];
            }
        }else{
            
        }
    }];
}

- (void)addPagerController{
     _pagerController = [[TYTabButtonPagerController alloc]init];
    _pagerController.dataSource = self;
    _pagerController.adjustStatusBarHeight = YES;
    _pagerController.pagerBarColor = [UIColor whiteColor];
    _pagerController.selectedTextColor = [UIColor redColor];
    _pagerController.normalTextColor = [UIColor blackColor];
    _pagerController.cellWidth = (SCREEN_WIDTH - 10)/6;
//    _pagerController.cellSpacing = 8;
    _pagerController.barStyle = TYPagerBarStyleProgressElasticView;
//    _pagerController.cellEdging = 10;
    _pagerController.progressBottomEdging = 2;
    _pagerController.progressWidth = 15;
    _pagerController.normalTextFont = [UIFont systemFontOfSize:14];
    _pagerController.selectedTextFont = [UIFont systemFontOfSize:12];
    _pagerController.view.frame = CGRectMake(0, 200, ScreenWidth, ScreenHeight - 50);
    [self addChildViewController:_pagerController];
    [self.myScrollView addSubview:_pagerController.view];
    /*
     self.view addsubView:pageController.view;
     */
}

#pragma mark - TYPagerControllerDataSource

- (NSInteger)numberOfControllersInPagerController
{
    self.tableViews = [[NSMutableArray alloc]initWithCapacity:CATEGORY.count];
    return CATEGORY.count;
}

- (NSString *)pagerController:(TYPagerController *)pagerController titleForIndex:(NSInteger)index{
    return CATEGORY[index];
}

- (UIViewController *)pagerController:(TYPagerController *)pagerController controllerForIndex:(NSInteger)index{
    JSDTableViewController *vc  =[JSDTableViewController new];
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [vc.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    [vc.tableView setContentOffset:CGPointMake(0, 0)];
//    if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=200) {
//
//        vc.tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
//
//    }else if(  self.lastTableViewOffsetY < 0){
//
//        vc.tableView.contentOffset = CGPointMake(0, 0);
//
//    }else if ( self.lastTableViewOffsetY > 200){
//
//        vc.tableView.contentOffset = CGPointMake(0, 200);
//    }
//    if (self.lastTableViewOffsetY >=  0 && self.lastTableViewOffsetY <= 200) {
//        self.cycleScrollView.frame =CGRectMake(0, 0 - self.lastTableViewOffsetY, SCREEN_WIDTH, 200);
//        self.pagerController.view.frame = CGRectMake(0, 200 - self.lastTableViewOffsetY, SCREEN_WIDTH, SCREEN_HEIGHT );
//    }else if( self.lastTableViewOffsetY < 0){
//        self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
//        self.pagerController.view.frame = CGRectMake(0, 200, SCREEN_WIDTH, SCREEN_HEIGHT );
//    }else if (self.lastTableViewOffsetY > 200){
//        self.cycleScrollView.frame = CGRectMake(0, -200, SCREEN_WIDTH, 200);
//        self.pagerController.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
//    }
    return vc;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
