//
//  VideoViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/17.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "VideoViewController.h"
#import "ZFVideoModel.h"
#import "VideoTableViewCell.h"
#import "ZFVideoModel.h"
#import "ZFVideoResolution.h"
#import <UShareUI/UShareUI.h>
#import "VideoModel.h"
#import "ArticleDetailViewController.h"
#import "BURefreshGifHeader.h"
#import "ScrollBannerTableViewCell.h"
#import "VideoDetailViewController.h"

@interface VideoViewController ()<UITableViewDelegate, UITableViewDataSource,ZFPlayerControlViewDelagate, ZFPlayerDelegate>
@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic, strong) UITableView *videoTableView;
@property (nonatomic, strong) UITableView *liveTableView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *liveDataSource;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, assign) int pageNum;
@property (nonatomic, assign) int livePageNum;
@property (nonatomic, assign) int indexPath;
@property (nonatomic, assign) int liveIndexPath;
@property (nonatomic, strong) NSArray *liveBannerArray;
@property (nonatomic, strong) NSArray *videoBannerArray;

@end
static NSString *videoCell = @"playerCell";

@implementation VideoViewController

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [ZFPlayerView sharedPlayerView];
        _playerView.delegate = self;
        // 当cell播放视频由全屏变为小屏时候，不回到中间位置
        //        _playerView.cellPlayerOnCenter = NO;
        
        // 当cell划出屏幕的时候停止播放
        // _playerView.stopPlayWhileCellNotVisable = YES;
        //（可选设置）可以设置视频的填充模式，默认为（等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResizeAspect;
        // 静音
        // _playerView.mute = YES;
    }
    return _playerView;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [[ZFPlayerControlView alloc] init];
    }
    return _controlView;
}

- (UITableView *)videoTableView{
    if (!_videoTableView) {
        _videoTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStylePlain];
        _videoTableView.delegate = self;
        _videoTableView.dataSource = self;
        [_videoTableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:videoCell];
        [_videoTableView registerClass:[ScrollBannerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ScrollBannerTableViewCell class])];
        _videoTableView.separatorStyle = NO;
        _videoTableView.hidden = NO;
    }
    return _videoTableView;
}
- (UITableView *)liveTableView{
    if (!_liveTableView) {
        _liveTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStylePlain];
        _liveTableView.delegate = self;
        _liveTableView.dataSource = self;
        [_liveTableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:videoCell];
        [_liveTableView registerClass:[ScrollBannerTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ScrollBannerTableViewCell class])];
        _liveTableView.separatorStyle = NO;
        _liveTableView.hidden = YES;
    }
    return _liveTableView;
}
- (UISegmentedControl *)segControl{
    if (!_segControl) {
        _segControl = [[UISegmentedControl alloc]initWithItems:@[@"视频",@"直播"]];
        _segControl.frame = CGRectMake(0, 0, 120, 30);
        _segControl.selectedSegmentIndex = 0;
        _segControl.tintColor = DRGBCOLOR;
        [_segControl addTarget:self action:@selector(segControlClick:) forControlEvents:UIControlEventValueChanged];
    }
    return _segControl;
}
- (void)segControlClick:(UISegmentedControl *)control{
    if (control.selectedSegmentIndex == 0) {
        self.liveTableView.hidden = YES;
        self.videoTableView.hidden = NO;
        [self.videoTableView reloadData];
    }else{
        self.liveTableView.hidden = NO;
        self.videoTableView.hidden = YES;
        [self.liveTableView reloadData];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.playerView resetPlayer];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self footerLoadData];
    [self headerLoadData];
    _pageNum = 1;
    _livePageNum = 1;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.navigationItem setTitleView:self.segControl];
        [self.view addSubview:self.videoTableView];
        [self.view addSubview:self.liveTableView];
    }
    return self;
}
//下拉刷新
- (void)headerLoadData{
    self.videoTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        WeakSelf
        [LTHttpManager newsListWithLimit:@10 Cid:@0 Type:@2 Title:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                self.dataSource = @[].mutableCopy;
                NSArray *videoList = [data[@"responseData"][@"news"] objectForKey:@"data"];
                for (NSDictionary *dataDic in videoList) {
                    VideoModel *model = [VideoModel mj_objectWithKeyValues:dataDic];
                    //                  ZFVideoModel *model = [[ZFVideoModel alloc] init];
                    //                  [model setValuesForKeysWithDictionary:dataDic];
                    [weakSelf.dataSource addObject:model];
                }
                self.videoBannerArray = data[@"responseData"][@"top"];
                [weakSelf.videoTableView reloadData];
                [weakSelf.videoTableView.mj_header endRefreshing];
            }else{
                [weakSelf.videoTableView.mj_header endRefreshing];
            }
        }];
    }];
    [self.videoTableView.mj_header beginRefreshing];
    self.liveTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        WeakSelf
        [LTHttpManager newsListWithLimit:@10 Cid:@0 Type:@5 Title:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                self.liveDataSource = @[].mutableCopy;
                NSArray *videoList = [data[@"responseData"][@"news"] objectForKey:@"data"];
                for (NSDictionary *dataDic in videoList) {
                    VideoModel *model = [VideoModel mj_objectWithKeyValues:dataDic];
                    [weakSelf.liveDataSource addObject:model];
                }
                self.liveBannerArray = data[@"responseData"][@"top"];
                [weakSelf.liveTableView reloadData];
                [weakSelf.liveTableView.mj_header endRefreshing];
            }else{
                [weakSelf.liveTableView.mj_header endRefreshing];
            }
        }];
    }];
    [self.liveTableView.mj_header beginRefreshing];
}
- (void)footerLoadData{
    self.videoTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        WeakSelf
        _pageNum++;
        [LTHttpManager TgetMoreNewsWithLimit:@10 Page:@(_pageNum) Cid:@0 Title:@"" Type:@2 Complete:^(LTHttpResult result, NSString *message, id data){
            if (LTHttpResultSuccess == result) {
                NSArray *videoList = [data[@"responseData"] objectForKey:@"data"];
                for (NSDictionary *dataDic in videoList) {
                    VideoModel *model = [VideoModel mj_objectWithKeyValues:dataDic];
                    [weakSelf.dataSource addObject:model];
                }
                [self.videoTableView reloadData];
                [self.videoTableView.mj_footer endRefreshing];
            }else{
                [self.videoTableView.mj_footer endRefreshing];
                _pageNum--;
            }
        }];
    }];
    self.liveTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        WeakSelf
        _livePageNum++;
        [LTHttpManager TgetMoreNewsWithLimit:@10 Page:@(_pageNum) Cid:@0 Title:@"" Type:@5 Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                NSArray *videoList = [data[@"responseData"] objectForKey:@"data"];
                for (NSDictionary *dataDic in videoList) {
                    VideoModel *model = [VideoModel mj_objectWithKeyValues:dataDic];
                    [weakSelf.liveDataSource addObject:model];
                }
                [self.liveTableView reloadData];
                [self.liveTableView.mj_footer endRefreshing];
            }else{
                [self.liveTableView.mj_footer endRefreshing];
                _livePageNum--;
            }
        }];
    }];
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat sectionHeaderHeight = 40;
//    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//    } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//    }
//}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.videoTableView) {
        return self.dataSource.count + 1;
    }else{
        return self.liveDataSource.count + 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [Tool layoutForAlliPhoneHeight:200];
    }else{
        return [Tool layoutForAlliPhoneHeight:270];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
//    view.backgroundColor = [UIColor lightGrayColor];
//    return view;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ScrollBannerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ScrollBannerTableViewCell class])];
        if (tableView == _liveTableView) {
            cell.imageURLStringsGroup = self.liveBannerArray;
            WeakSelf
            cell.BannerImageClick = ^(NSInteger index) {
               VideoDetailViewController *vc = [VideoDetailViewController new];
                vc.videoId = @([[NSString stringWithFormat:@"%@",weakSelf.liveBannerArray[index][@"id"]] integerValue]);
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }else{
            cell.imageURLStringsGroup = self.videoBannerArray;
            WeakSelf
            cell.BannerImageClick = ^(NSInteger index) {
                VideoDetailViewController *vc = [VideoDetailViewController new];
                vc.videoId = @([[NSString stringWithFormat:@"%@",weakSelf.liveBannerArray[index][@"id"]] integerValue]);
                [weakSelf.navigationController pushViewController:vc animated:YES];
            };
        }
          return cell;
    }else{
        //取到对应cell的model
        VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell forIndexPath:indexPath];
        __block VideoModel *model;
        if (tableView == self.liveTableView) {
            model = self.liveDataSource[indexPath.section - 1];
        }else if (tableView == self.videoTableView){
            model = self.dataSource[indexPath.section - 1];
        }
        //赋值model
        cell.model = model;
        __block NSIndexPath *weakIndexPath = indexPath;
        __block VideoTableViewCell *weakCell = cell;
        __weak typeof(self)  weakSelf = self;
        //点击播放的回调
        cell.playBlock = ^(UIButton *btn){
            ZFPlayerModel *playerModel = [[ZFPlayerModel alloc]init];
            playerModel.fatherViewTag = weakCell.picView.tag;
            playerModel.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",model.url]];
            playerModel.scrollView = weakSelf.videoTableView;
            playerModel.indexPath = weakIndexPath;
            [weakSelf.playerView playerControlView:self.controlView playerModel:playerModel];
            [weakSelf.playerView autoPlayTheVideo];
        };
        cell.shareBlock = ^(UIButton *btn){
            _indexPath = (int)indexPath.section;
            [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
            [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作
                NSLog(@"%ld---%@",(long)platformType, userInfo);
                [self shareVedioToPlatformType:platformType];
            }];
        };
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.videoTableView) {
        VideoModel *model = self.dataSource[indexPath.section - 1];
        VideoDetailViewController *vc = [[VideoDetailViewController alloc]init];
        vc.videoId = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        VideoModel *model = self.dataSource[indexPath.section - 1];
        VideoDetailViewController *vc = [[VideoDetailViewController alloc]init];
        vc.videoId = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }
 
}
#pragma mark VideoShare 
//视频分享
- (void)shareVedioToPlatformType:(UMSocialPlatformType)platformType
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    VideoModel *model = self.dataSource[_indexPath - 1];
    UMShareVideoObject *shareObject;
    if (platformType == 0) {
        shareObject = [UMShareVideoObject shareObjectWithTitle:model.title descr:model.introduct thumImage:[UIImage imageNamed:@"微博点击"]];
    }else{
        shareObject =[UMShareVideoObject shareObjectWithTitle:model.title descr:model.introduct thumImage:model.photo];
    }
    
    //设置视频网页播放地址
    if (model.share_url.length > 5) {
        shareObject.videoUrl = model.share_url;
    }
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
            SVProgressShowStuteText(@"分享失败", YES);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                SVProgressShowStuteText(@"分享成功", YES);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
                
            }
        }
    }];
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
