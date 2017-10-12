//
//  ArticleDetailViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/24.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "GoodsDetailsTableViewCell.h"
#import "BuyGoodsTableViewCell.h"
#import "HorizontalTableViewCell.h"
#import "ArticleDetailModel.h"
#import "RecommedCellModel.h"
#import "WebContentViewController.h"



@interface ArticleDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *goodsMutableArray;
@property (nonatomic, strong) NSDictionary *infoDataDic;
@property (nonatomic, strong) NSMutableArray *recommendMutableArrray;
@end

@implementation ArticleDetailViewController

- (NSMutableArray *)recommendMutableArrray{
    if (!_recommendMutableArrray) {
        _recommendMutableArrray = [NSMutableArray array];
    }
    return _recommendMutableArrray;
}
- (NSMutableArray *)goodsMutableArray{
    if (!_goodsMutableArray) {
        _goodsMutableArray = [NSMutableArray array];
    }
    return _goodsMutableArray;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        [_myTableView registerNib:[UINib nibWithNibName:@"GoodsDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"gooddetailcell"];
        [_myTableView registerNib:[UINib nibWithNibName:@"BuyGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"buygoodcell"];
        [_myTableView registerClass:[HorizontalTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HorizontalTableViewCell class])];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self.view addSubview:self.myTableView];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"详情";
//    [self loadData];
}
- (void)setArticleId:(NSNumber *)articleId{
    _articleId = articleId;
    [LTHttpManager TnewsDetailWithId:articleId Value:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            self.infoDataDic = data[@"responseData"][@"info"];
            NSArray *dataArray = data[@"responseData"][@"commodity"];
            [self.goodsMutableArray removeAllObjects];
            for (NSDictionary *dic in dataArray) {
                ArticleDetailModel *model = [ArticleDetailModel mj_objectWithKeyValues:dic];
                [self.goodsMutableArray addObject:model];
            }
            NSArray *recomdArray = data[@"responseData"][@"recomd"];
            [self.recommendMutableArrray removeAllObjects];
            for (NSDictionary *dic in recomdArray) {
                RecommedCellModel *model = [RecommedCellModel mj_objectWithKeyValues:dic];
                [self.recommendMutableArrray addObject:model];
            }
            [self.myTableView reloadData];
        }
    }];
}
- (void)loadData{
    [LTHttpManager TnewsDetailWithId:self.articleId Value:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            self.infoDataDic = data[@"responseData"][@"info"];
            NSArray *dataArray = data[@"responseData"][@"commodity"];
            [self.goodsMutableArray removeAllObjects];
            for (NSDictionary *dic in dataArray) {
                ArticleDetailModel *model = [ArticleDetailModel mj_objectWithKeyValues:dic];
                [self.goodsMutableArray addObject:model];
            }
            [self.myTableView reloadData];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2) {
        return 1;
    }else{
        return self.goodsMutableArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 50;
    }else{
        return 0;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [UIView new];
    if (section == 2) {
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = @"猜你喜欢";
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.equalTo(@100);
        }];
        UILabel *leftLine = [UILabel new];
        leftLine.backgroundColor = [UIColor grayColor];
        [view addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(10);
            make.right.equalTo(nameLabel.mas_left).offset(-10);
            make.height.equalTo(@1);
            make.centerY.equalTo(nameLabel.mas_centerY);
        }];
        UILabel *rightLine = [UILabel new];
        rightLine.backgroundColor = [UIColor grayColor];
        [view addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).offset(10);
            make.right.equalTo(view.mas_right).offset(-10);
            make.height.equalTo(@1);
            make.centerY.equalTo(nameLabel.mas_centerY);
        }];
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.myTableView.estimatedRowHeight = 300;
        self.myTableView.rowHeight = UITableViewAutomaticDimension;
        return self.myTableView.rowHeight;
    }else if (indexPath.section == 1){
//        self.myTableView.estimatedRowHeight = 120;
//        self.myTableView.rowHeight = UITableViewAutomaticDimension;
        return 120;
    }else if (indexPath.section == 2){
        return 100;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GoodsDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gooddetailcell"];
        cell.dataDic = self.infoDataDic;
        return cell;
    }else if (indexPath.section == 1){
        BuyGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buygoodcell"];
        cell.model = self.goodsMutableArray[indexPath.row];
        ArticleDetailModel *model = self.goodsMutableArray[indexPath.row];
        cell.buyGoodsBlock = ^(UIButton *btn) {
            [LTHttpManager getPlatformWithID:model.ID Complete:^(LTHttpResult result, NSString *message, id data) {
                WebContentViewController *vc = [[WebContentViewController alloc]init];
                vc.UrlString = data[@"responseData"][0][@"url"];
                [self.navigationController pushViewController:vc animated:YES];
            }];
        };
        return cell;
    }else if (indexPath.section == 2){
        HorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HorizontalTableViewCell class])];
        WeakSelf
        cell.HorCollectionCellClick = ^(NSIndexPath *indexPath) {
            RecommedCellModel *model = weakSelf.recommendMutableArrray[indexPath.row];
            ArticleDetailViewController *vc = [ArticleDetailViewController new];
            vc.articleId = model.ID;
            [self.navigationController pushViewController:vc animated:YES];
        };
        cell.modelArray = self.recommendMutableArrray;
        return cell;
    }else{
        return 0;
    }
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
