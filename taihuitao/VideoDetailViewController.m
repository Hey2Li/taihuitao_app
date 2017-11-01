//
//  VideoDetailViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/11/1.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "VideoDetailViewController.h"
#import "GoodsDetailsTableViewCell.h"
#import "BuyGoodsTableViewCell.h"
#import "HorizontalTableViewCell.h"
#import "ArticleDetailModel.h"
#import "RecommedCellModel.h"
#import "ArticleDetailViewController.h"
#import "WebContentViewController.h"

@interface VideoDetailViewController ()<UITableViewDataSource, UITableViewDelegate, ZFPlayerDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *goodsMutableArray;
@property (nonatomic, strong) NSDictionary *infoDataDic;
@property (nonatomic, strong) NSMutableArray *recommendMutableArrray;

@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;
@end

@implementation VideoDetailViewController
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
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
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
- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        //        _playerModel.title            = @"这里设置视频标题";
        //        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        //        _playerView.hasDownload    = YES;
        
        // 打开预览图
        _playerView.hasPreviewView = YES;
        
    }
    return _playerView;
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
    if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
        self.isPlaying = NO;
        self.playerView.playerPushedOrPresented = NO;
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    // push出下一级页面时候暂停
    if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
    {
        self.isPlaying = YES;
        //        [self.playerView pause];
        self.playerView.playerPushedOrPresented = YES;
    }else{
        [self.playerView resetPlayer];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
}
- (void)setVideoId:(NSNumber *)videoId{
    _videoId = videoId;
    WeakSelf
    [LTHttpManager TnewsDetailWithId:videoId Value:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
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
            self.playerModel.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.infoDataDic[@"url"]]];
            [self.playerView resetToPlayNewVideo:self.playerModel];
            [self.myTableView reloadData];
        }else{
            [self.playerView resetPlayer];
        }
    }];
    self.playerFatherView = [[UIView alloc] init];
    [self.myTableView addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTableView.mas_top);
        make.leading.trailing.mas_equalTo(0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    [self.playerView autoPlayTheVideo];
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 2 || section == 3) {
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
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:14];
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
        return [Tool layoutForAlliPhoneHeight:120];
    }else if (indexPath.section == 3){
        return 50;
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
    }else if (indexPath.section == 3){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        return 0;
    }
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
