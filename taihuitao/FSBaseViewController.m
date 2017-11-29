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
#import "SearchTableViewController.h"
#import "SGQRCodeScanningVC.h"
#import <AVFoundation/AVFoundation.h>


#define CATEGORY @[@"推荐",@"断货王",@"妆心得",@"美食番",@"品牌购",@"汇生活"]

@interface FSBaseViewController ()<UITableViewDelegate,UITableViewDataSource,FSPageContentViewDelegate,FSSegmentTitleViewDelegate>
@property (nonatomic, strong) FSBaseTableView *tableView;
@property (nonatomic, strong) FSBottomTableViewCell *contentCell;
@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, assign) BOOL canScroll;
@property (nonatomic, strong) NSMutableArray *topTitleArray;
@property (nonatomic, strong) NSMutableArray *controllersArray;
@property (nonatomic, strong) NSMutableArray *imageMutaleArray;
@property (nonatomic, strong) NSMutableArray *keywordMutableArray;
@property (nonatomic, strong) UIButton *contactUsBtn;
@property (nonatomic, strong) NSString *telephoneStr;
@end

@implementation FSBaseViewController

- (NSMutableArray *)topTitleArray{
    if (!_topTitleArray) {
        _topTitleArray = [NSMutableArray array];
    }
    return _topTitleArray;
}
- (NSMutableArray *)keywordMutableArray{
    if (!_keywordMutableArray) {
        _keywordMutableArray = [NSMutableArray array];
    }
    return _keywordMutableArray;
}
- (NSMutableArray *)imageMutaleArray{
    if (!_imageMutaleArray) {
        _imageMutaleArray = [NSMutableArray array];
    }
    return _imageMutaleArray;
}
- (NSMutableArray *)controllersArray{
    if (!_controllersArray) {
        _controllersArray = [NSMutableArray array];
    }
    return _controllersArray;
}
- (UIButton *)contactUsBtn{
    if (!_contactUsBtn) {
        _contactUsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.view addSubview:self.contactUsBtn];
        [_contactUsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view.mas_right);
            make.centerY.equalTo(self.view.mas_centerY);
            make.width.equalTo(@35);
            make.height.equalTo(@35);
        }];
        [self.view bringSubviewToFront:self.contactUsBtn];
//        [_contactUsBtn setTitle:@"联系我们" forState:UIControlStateNormal];
        [_contactUsBtn setImage:[UIImage imageNamed:@"联系我们"] forState:UIControlStateNormal];
        [_contactUsBtn setTitleColor:DRGBCOLOR forState:UIControlStateNormal];
        _contactUsBtn.backgroundColor = [UIColor blackColor];
        [_contactUsBtn addTarget:self action:@selector(contactUsClick) forControlEvents:UIControlEventTouchUpInside];
        [_contactUsBtn setBackgroundColor:[UIColor whiteColor]];
    }
    return _contactUsBtn;
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
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setupSubViews];
    [self initWithNavi];
    [self loadData];
    self.title = @"TAIHUITAO";
//    [self contactUsBtn];
}
- (void)contactUsClick{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"025-88018310-810"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)loadData{
    [LTHttpManager THomeDataWithLimit:@5 Page:@1 Nlimit:@10 Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            [self.topTitleArray addObject:@{@"id":@"-1",@"name":@"推荐"}];
            [self.topTitleArray addObjectsFromArray:data[@"responseData"][@"column"]];
            self.imageMutaleArray = [NSMutableArray arrayWithArray:data[@"responseData"][@"top"]];
            [self.controllersArray removeAllObjects];
            for (NSDictionary *dic in self.topTitleArray) {
                FSScrollContentViewController *vc = [[FSScrollContentViewController alloc]init];
                vc.cid = @([[NSString stringWithFormat:@"%@",dic[@"id"]] integerValue]);
                [self.controllersArray addObject:vc];
            }
            [self.keywordMutableArray removeAllObjects];
            NSArray *array = data[@"responseData"][@"keywords"];
            for (NSDictionary *dic in array) {
                NSString *keyword = dic[@"name"];
                [self.keywordMutableArray addObject:keyword];
            }
            self.telephoneStr = data[@"responseData"][@"sy_freewebtel"];
            if (self.telephoneStr.length > 7) {
                [self contactUsBtn];
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
    
    UIBarButtonItem *rightBarItem = [[UIBarButtonItem alloc]initWithImage:rightImage style:UIBarButtonItemStyleDone target:self action:@selector(qrCodeBtnClick:)];
    self.navigationItem.rightBarButtonItem = rightBarItem;
    [self.navigationController.navigationBar setTranslucent:NO];
}
- (void)qrCodeBtnClick:(UIButton *)btn{
    // 1、 获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusNotDetermined) {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_sync(dispatch_get_main_queue(), ^{
                        SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                    // 用户第一次同意了访问相机权限
                    NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    
                } else {
                    // 用户第一次拒绝了访问相机权限
                    NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                }
            }];
        } else if (status == AVAuthorizationStatusAuthorized) { // 用户允许当前应用访问相机
            SGQRCodeScanningVC *vc = [[SGQRCodeScanningVC alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        } else if (status == AVAuthorizationStatusDenied) { // 用户拒绝当前应用访问相机
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置 - 隐私 - 相机 - SGQRCodeExample] 打开访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alertC addAction:alertA];
            [self presentViewController:alertC animated:YES completion:nil];
            
        } else if (status == AVAuthorizationStatusRestricted) {
            NSLog(@"因为系统原因, 无法访问相册");
        }
    } else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertC addAction:alertA];
        [self presentViewController:alertC animated:YES completion:nil];
    }

}

- (void)searchBtnClick:(UIButton *)btn{
    NSArray *hotSeaches = self.keywordMutableArray;
    // 2. Create searchViewController
    PYSearchViewController *searchViewController = [PYSearchViewController searchViewControllerWithHotSearches:hotSeaches searchBarPlaceholder:@"请输入想要搜索的内容" didSearchBlock:^(PYSearchViewController *searchViewController, UISearchBar *searchBar, NSString *searchText) {
        // Call this Block when completion search automatically
        // Such as: Push to a view controller
        SearchTableViewController *vc = [SearchTableViewController new];
        vc.subTitle = searchText;
        [searchViewController.navigationController pushViewController:vc animated:YES];
    }];
    
    // 3. present the searchViewController
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    searchViewController.navigationController.navigationBar.tintColor = [UIColor blackColor];
    //    self.navigationBar.translucent = NO;
    //去掉左边的title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    searchViewController.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"返回"];
    searchViewController.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];
    
    //自定义一个NavigationBar
    //    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    searchViewController.navigationController.navigationBar.shadowImage = [UIImage new];
    //PingFangSCd自定义title字体
    searchViewController.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Light" size:18],NSFontAttributeName, nil];
    searchViewController.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    [self presentViewController:nav  animated:NO completion:nil];
}
- (void)setupSubViews{
    self.canScroll = YES;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
}

- (void)insertRowAtTop{
    self.contentCell.currentTagStr = CATEGORY[self.titleView.selectIndex];
    self.contentCell.isRefresh = YES;
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
            return [Tool layoutForAlliPhoneHeight:200];
        }
    }
    return SCREEN_HEIGHT;
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
        cell.imageArray = self.imageMutaleArray;
        cell.cycleScrollClick = ^(NSInteger index) {
            ArticleDetailViewController *vc = [ArticleDetailViewController new];
            if ([self.imageMutaleArray[index][@"type"] isEqual:@2]) {
                vc.articleId  = self.imageMutaleArray[index][@"id"];
                vc.isVideo  = @"yes";
                [self.navigationController pushViewController:vc animated:YES];
            }else{
                vc.articleId  = self.imageMutaleArray[index][@"id"];
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
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
