//
//  BearupViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/23.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BearupViewController.h"
#import "HomeTableViewCell.h"
#import "HomeNewsModel.h"
#import "CDetailViewController.h"

@interface BearupViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataMutableArray;
@property (nonatomic, assign) int pageNum;
@end

@implementation BearupViewController

- (NSMutableArray *)dataMutableArray{
    if (!_dataMutableArray) {
        _dataMutableArray = [NSMutableArray array];
    }
    return _dataMutableArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"熊起";
    [self initWithView];
    [self loadData];
    [self loadFooterData];
    _pageNum = 1;
}
- (void)initWithView{
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44 - 64) style:UITableViewStylePlain];
        [self.view addSubview:tableView];
        [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.separatorStyle = NO;
        [tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeTableViewCell class])];
        tableView;
    });
}
- (void)loadData{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [LTHttpManager newsListWithLimit:@10 Cid:@0 Type:@4 Title:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                [self.dataMutableArray removeAllObjects];
                NSArray *array = data[@"responseData"][@"news"][@"data"];
                for (NSDictionary *dic in array) {
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
- (void)loadFooterData{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [LTHttpManager TgetMoreNewsWithLimit:@10 Page:@2 Cid:@0 Title:@"" Type:@4 Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                NSArray *array = data[@"responseData"][@"data"];
                for (NSDictionary *dic in array) {
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataMutableArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 255;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HomeTableViewCell class])];
    cell.model = self.dataMutableArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CDetailViewController *vc = [CDetailViewController new];
    HomeNewsModel *model = self.dataMutableArray[indexPath.row];
    vc.cid = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
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
