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

#define CATEGORY @[@"断货王",@"妆心得",@"美食番",@"品牌购",@"汇生活"]
#define NAVBARHEIGHT 64.0f

#define FONTMAX 15.0
#define FONTMIN 14.0
#define PADDING 15.0

@interface HomeViewController ()<UIScrollViewDelegate,NavigationGradientBarDelegate>
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
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        self.titleButtons = [[NSMutableArray alloc]initWithCapacity:CATEGORY.count];
        self.controlleres  =[[NSMutableArray alloc]initWithCapacity:CATEGORY.count];
        self.tableViews  = [[NSMutableArray alloc]initWithCapacity:CATEGORY.count];
        
        [self.view addSubview:self.bottomScrollView];
        self.naviView.tableViews = [NSMutableArray arrayWithArray:self.tableViews];
        
        self.cycleScrollView.pageDotImage = [UIImage imageNamed:@"home_banner_nomal_dot_4x4_"];
        self.cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"home_banner_red_dot_13x4_"];
        [self.view addSubview:self.cycleScrollView];
        [self.view addSubview:self.segmentScrollView];
        [self.view addSubview:self.navigationBar];
    }
    return self;
}
- (NavigationGradientBar *)navigationBar{
    if (!_navigationBar) {
        _navigationBar = [[NavigationGradientBar alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64) backImgName:@"home_email_black" gradientImgName:@"home_email_red" rightImgName:@"home_search_icon" rightGImgName:@"home_search_icon" middleTitle:@"太会淘" delegate:self];
        _navigationBar.beginTitleColor = [UIColor redColor];
        _navigationBar.afterTitleColor = [UIColor redColor];
        
        _navigationBar.beginStatusBarDefault = NO;
        _navigationBar.afterStatusBarDefault = YES;
        _navigationBar.beginHiddenMiddleTitle = YES;
    }
    return _navigationBar;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
//    [self initWithNavi];
}
- (void)initWithNavi{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    self.barImageView = self.navigationController.navigationBar.subviews.firstObject;
//    self.barImageView.backgroundColor = [UIColor whiteColor];
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchButton];
//    self.navigationItem.rightBarButtonItem  =[[UIBarButtonItem alloc]initWithCustomView:self.qrCodeButton];
//    self.navigationController.navigationBar.alpha = 1;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.view setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma observe


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    UITableView *tableView = (UITableView *)object;
    if (!(self.currentTableView == tableView)) {
        return;
    }
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    CGFloat tableViewoffsetY = tableView.contentOffset.y;
    [self.navigationBar navigationGradientBarContentOffset:tableViewoffsetY];
    self.lastTableViewOffsetY = tableViewoffsetY;
    if ( tableViewoffsetY>=0 && tableViewoffsetY<=136) {
        self.segmentScrollView.frame = CGRectMake(0, 200-tableViewoffsetY, SCREEN_WIDTH, 40);
        self.cycleScrollView.frame = CGRectMake(0, 0-tableViewoffsetY, SCREEN_WIDTH, 200);
    }else if( tableViewoffsetY < 0){
        self.segmentScrollView.frame = CGRectMake(0, 200, SCREEN_WIDTH, 40);
        self.cycleScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
    }else if (tableViewoffsetY > 136){
        self.segmentScrollView.frame = CGRectMake(0, 64, SCREEN_WIDTH, 40);
        self.cycleScrollView.frame = CGRectMake(0, -136, SCREEN_WIDTH, 200);
    }
    
//    UIColor * color = [UIColor whiteColor];
//    CGFloat alpha = MIN(1, tableViewoffsetY/136);
//    
////    self.barImageView.backgroundColor = [color colorWithAlphaComponent:alpha];
////    self.navigationController.navigationBar.tintColor = [color colorWithAlphaComponent:alpha];
//    self.navigationController.navigationBar.alpha = alpha;
//    if (tableViewoffsetY < 125){
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            [self.qrCodeButton setBackgroundImage:[UIImage imageNamed:@"home_email_black"] forState:UIControlStateNormal];
//            [self.searchButton setBackgroundImage:[UIImage imageNamed:@"home_search_icon"] forState:UIControlStateNormal];
//
//            self.qrCodeButton.alpha = 1-alpha;
//            self.searchButton.alpha = 1-alpha;
//        }];
//    } else if (tableViewoffsetY >= 125){
//        
//        [UIView animateWithDuration:0.25 animations:^{
//            self.qrCodeButton.alpha = 1;
//            [self.qrCodeButton setBackgroundImage:[UIImage imageNamed:@"home_email_red"] forState:UIControlStateNormal];
//            [self.searchButton setBackgroundImage:[UIImage imageNamed:@"home_search_icon"] forState:UIControlStateNormal];
//        }];
//    }

}
#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    if (scrollView !=self.bottomScrollView) {
        return ;
    }
    int index =  scrollView.contentOffset.x/scrollView.frame.size.width;
    
    
    UIButton *currentButton = self.titleButtons[index];
    _previousButton.selected = NO;
    currentButton.selected = YES;
    _previousButton = currentButton;
    
    
    self.currentTableView  = self.tableViews[index];
    for (UITableView *tableView in self.tableViews) {
        
        if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=136) {
            
            tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
            
        }else if(  self.lastTableViewOffsetY < 0){
            
            tableView.contentOffset = CGPointMake(0, 0);
            
        }else if ( self.lastTableViewOffsetY > 136){
            
            tableView.contentOffset = CGPointMake(0, 136);
        }
        
    }
    
    [UIView animateWithDuration:0.3 animations:^{
        if (index == 0) {
            
            self.currentSelectedItemImageView.frame = CGRectMake(PADDING, self.segmentScrollView.frame.size.height - 2,currentButton.frame.size.width, 2);
            
        }else{
            
            
            UIButton *preButton = self.titleButtons[index - 1];
            
            float offsetX = CGRectGetMinX(preButton.frame)-PADDING*2;
            
            [self.segmentScrollView scrollRectToVisible:CGRectMake(offsetX, 0, self.segmentScrollView.frame.size.width, self.segmentScrollView.frame.size.height) animated:YES];
            
            self.currentSelectedItemImageView.frame = CGRectMake(CGRectGetMinX(currentButton.frame), self.segmentScrollView.frame.size.height-2, currentButton.frame.size.width, 2);
        }
    }];
}
#pragma  mark - 选项卡点击事件

-(void)changeSelectedItem:(UIButton *)currentButton{
    
    //     for (UIButton *button in self.titleButtons) {
    //         button.selected = NO;
    //     }
    
    _previousButton.selected = NO;
    currentButton.selected = YES;
    _previousButton = currentButton;
    
    NSInteger index = [self.titleButtons indexOfObject:currentButton];
    
    self.currentTableView  = self.tableViews[index];
    for (UITableView *tableView in self.tableViews) {
        
        if ( self.lastTableViewOffsetY>=0 &&  self.lastTableViewOffsetY<=136) {
            
            tableView.contentOffset = CGPointMake(0,  self.lastTableViewOffsetY);
            
        }else if(self.lastTableViewOffsetY < 0){
            
            tableView.contentOffset = CGPointMake(0, 0);
            
        }else if ( self.lastTableViewOffsetY > 136){
            
            tableView.contentOffset = CGPointMake(0, 136);
        }
    }
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        if (index == 0) {
            
            self.currentSelectedItemImageView.frame = CGRectMake(PADDING, self.segmentScrollView.frame.size.height - 2,currentButton.frame.size.width, 2);
            
        }else{
            
            
            UIButton *preButton = self.titleButtons[index - 1];
            
            float offsetX = CGRectGetMinX(preButton.frame)-PADDING*2;
            
            [self.segmentScrollView scrollRectToVisible:CGRectMake(offsetX, 0, self.segmentScrollView.frame.size.width, self.segmentScrollView.frame.size.height) animated:YES];
            
            self.currentSelectedItemImageView.frame = CGRectMake(CGRectGetMinX(currentButton.frame), self.segmentScrollView.frame.size.height-2, currentButton.frame.size.width, 2);
        }
        self.bottomScrollView.contentOffset = CGPointMake(SCREEN_WIDTH *index, 0);
        
    }];
}
#pragma -mark Lazy Load

- (UIScrollView *)bottomScrollView {
    
    if (!_bottomScrollView) {
        _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44)];
        _bottomScrollView.delegate = self;
        _bottomScrollView.pagingEnabled = YES;
        
        
        for (int i = 0; i<CATEGORY.count; i++) {
            
            JSDTableViewController *jsdTableViewController = [[JSDTableViewController alloc] init];
            jsdTableViewController.view.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44);
            WeakSelf
            jsdTableViewController.tableViewDidSelected = ^(UITableView *tableview, NSIndexPath *indexPath) {
                ArticleDetailViewController *vc = [ArticleDetailViewController new];
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
            jsdTableViewController.view.backgroundColor = [UIColor whiteColor];
            [self.bottomScrollView addSubview:jsdTableViewController.view];
            
            [self.controlleres addObject:jsdTableViewController];
            [self.tableViews addObject:jsdTableViewController.tableView];
            
            //下拉刷新动画
            JQRefreshHeaader *jqRefreshHeader  = [[JQRefreshHeaader alloc] initWithFrame:CGRectMake(0, 212, SCREEN_WIDTH, 30)];
            jqRefreshHeader.backgroundColor = [UIColor whiteColor];
            jqRefreshHeader.tableView = jsdTableViewController.tableView;
            [jsdTableViewController.tableView.tableHeaderView addSubview:jqRefreshHeader];
            
            
            NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
            [jsdTableViewController.tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
            
            
        }
        
        self.currentTableView = self.tableViews[0];
        self.bottomScrollView.contentSize = CGSizeMake(self.controlleres.count * SCREEN_WIDTH, 0);
        
    }
    return _bottomScrollView;
}

- (UIScrollView *)segmentScrollView {
    
    if (!_segmentScrollView) {
        
        _segmentScrollView =  [[UIScrollView alloc]initWithFrame:CGRectMake(0, 200, SCREEN_WIDTH, 40)];
        [_segmentScrollView addSubview:self.currentSelectedItemImageView];
        _segmentScrollView.showsHorizontalScrollIndicator = NO;
        _segmentScrollView.showsVerticalScrollIndicator = NO;
        _segmentScrollView.backgroundColor = [UIColor whiteColor];
        NSInteger btnoffset = 0;
        
        for (int i = 0; i<CATEGORY.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            [btn setTitle:CATEGORY[i] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
            btn.titleLabel.font = [UIFont systemFontOfSize:FONTMIN];
            CGSize size = [UIButton sizeOfLabelWithCustomMaxWidth:SCREEN_WIDTH systemFontSize:FONTMIN andFilledTextString:CATEGORY[i]];
            
            
            float originX =  i? PADDING*2+btnoffset:PADDING;
            
            btn.frame = CGRectMake(originX, 14, size.width, size.height);
            btnoffset = CGRectGetMaxX(btn.frame);
            
            
            btn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [btn addTarget:self action:@selector(changeSelectedItem:) forControlEvents:UIControlEventTouchUpInside];
            [_segmentScrollView addSubview:btn];
            
            [self.titleButtons addObject:btn];
            
            //contentSize 等于按钮长度叠加
            //默认选中第一个按钮
            if (i == 0) {
                
                btn.selected = YES;
                _previousButton = btn;
                
                _currentSelectedItemImageView.frame = CGRectMake(PADDING, self.segmentScrollView.frame.size.height - 2, btn.frame.size.width, 2);
            }
        }
        
        _segmentScrollView.contentSize = CGSizeMake(btnoffset+PADDING, 25);
    }
    
    return _segmentScrollView;
}

- (UIImageView *)currentSelectedItemImageView {
    if (!_currentSelectedItemImageView) {
        _currentSelectedItemImageView = [[UIImageView alloc] init];
        _currentSelectedItemImageView.image = [UIImage imageNamed:@"nar_bgbg"];
    }
    return _currentSelectedItemImageView;
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

- (NaviView *)naviView{
    
    if (!_naviView) {
        
        _naviView = [[NaviView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _naviView.backgroundColor = [UIColor clearColor];
        
    }
    return _naviView;
}
- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"home_search_icon"] forState:UIControlStateNormal];
//        [_searchButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (UIButton *)qrCodeButton{
    if (!_qrCodeButton) {
        _qrCodeButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        [_qrCodeButton setBackgroundImage:[UIImage imageNamed:@"home_email_black"] forState:UIControlStateNormal];
//        [_qrCodeButton addTarget:self action:@selector(qrCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrCodeButton;
}
#pragma mark NavigationGradientBarDelegate
-(void)backNavigationGradientBar:(NavigationGradientBar *)bar{
    NSLog(@"1111");
}
- (void)rightNavigationBar:(NavigationGradientBar *)bar{
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
