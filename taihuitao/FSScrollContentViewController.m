//
//  FSScrollContentViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSScrollContentViewController.h"
#import "HomeTableViewCell.h"
#import "HomeNewsModel.h"
#import "ArticleDetailViewController.h"
#import "VideoDetailViewController.h"

@interface FSScrollContentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) BOOL fingerIsTouch;
@property (nonatomic ,strong) NSMutableArray *dataMutableArray;
@property (nonatomic, assign) int pageNum;
@end

@implementation FSScrollContentViewController
- (NSMutableArray *)dataMutableArray{
    if (!_dataMutableArray) {
        _dataMutableArray = [NSMutableArray array];
    }
    return _dataMutableArray;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    NSLog(@"---%@",self.title);
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupSubViews];
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeTableViewCell class])];
    _pageNum = 1;
    [self footerLoadData];
    [self headerLoadData];
}
- (void)footerLoadData{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [LTHttpManager TgetMoreNewsWithLimit:@10 Page:@(_pageNum) Cid:self.cid?self.cid:@0 Title:@"" Type:@1 Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                NSArray *dataArray = data[@"responseData"][@"data"];
                for (NSDictionary *dic in dataArray) {
                    HomeNewsModel *model = [HomeNewsModel mj_objectWithKeyValues:dic];
                    [self.dataMutableArray addObject:model];
                }
                [self.tableView reloadData];
                [self.tableView.mj_footer endRefreshing];
            }else{
                _pageNum--;
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    }];
}
- (void)headerLoadData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [LTHttpManager newsListWithLimit:@10 Cid:self.cid?self.cid:@0 Type:@1 Title:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                NSArray *dataArray = data[@"responseData"][@"news"][@"data"];
                [self.dataMutableArray removeAllObjects];
                for (NSDictionary *dic in dataArray) {
                    HomeNewsModel *model = [HomeNewsModel mj_objectWithKeyValues:dic];
                    [self.dataMutableArray addObject:model];
                }
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }else{
                [self.tableView.mj_header endRefreshing];
            }
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}
- (void)setupSubViews
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), SCREEN_HEIGHT - 64 - 44 - 55) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = NO;
//    _tableView.bounces = NO;
    [self.view addSubview:_tableView];
}

#pragma mark UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataMutableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Tool layoutForAlliPhoneHeight:265];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeTableViewCell class])];
    cell.model = self.dataMutableArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeNewsModel *model = self.dataMutableArray[indexPath.row];
    if ([model.type isEqual: @1]) {
        ArticleDetailViewController *vc = [ArticleDetailViewController new];
        vc.articleId = model.ID;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.type isEqual: @2] || [model.type isEqual: @5]){
        VideoDetailViewController *vc = [VideoDetailViewController new];
        vc.videoId = model.ID;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.type isEqual:@3]){
        [LTHttpManager TnewsDetailWithId:model.ID Value:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                NSArray *imageArray = data[@"responseData"][@"info"][@"images"];
                NSLog(@"%@",imageArray);
                NSMutableArray *imageMutableArray = [NSMutableArray array];
                [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *imageUrl = obj[@"url"];
                    [imageMutableArray addObject:imageUrl];
                }];
                XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:imageMutableArray currentImageIndex:0];
                browser.browserStyle = XLPhotoBrowserStyleIndexLabel; // 微博样式
            }
        }];
    }
}
#pragma mark UIScrollView
//判断屏幕触碰状态
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSLog(@"接触屏幕");
    self.fingerIsTouch = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    DebugLog(@"离开屏幕");
    self.fingerIsTouch = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.vcCanScroll) {
        scrollView.contentOffset = CGPointZero;
    }
    if (scrollView.contentOffset.y <= 0) {
//        if (!self.fingerIsTouch) {//这里的作用是在手指离开屏幕后也不让显示主视图，具体可以自己看看效果
//            return;
//        }
        self.vcCanScroll = NO;
        scrollView.contentOffset = CGPointZero;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"leaveTop" object:nil];//到顶通知父视图改变状态
    }
    self.tableView.showsVerticalScrollIndicator = _vcCanScroll?YES:NO;
}

@end
