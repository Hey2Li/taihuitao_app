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

@interface VideoViewController ()<UITableViewDelegate, UITableViewDataSource,ZFPlayerControlViewDelagate, ZFPlayerDelegate>
@property (nonatomic, strong) UISegmentedControl *segControl;
@property (nonatomic, strong) UITableView *videoTableView;
@property (nonatomic, strong) UITableView *liveTableView;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) ZFPlayerView        *playerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, assign) int pageNum;
@property (nonatomic, assign) int indexPath;
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
        _videoTableView.separatorStyle = NO;
    }
    return _videoTableView;
}
- (UITableView *)liveTableView{
    if (!_liveTableView) {
        _liveTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 44) style:UITableViewStylePlain];
        _liveTableView.delegate = self;
        _liveTableView.dataSource = self;
        [_liveTableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:videoCell];
        _liveTableView.separatorStyle = NO;
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

- (void)segControlClick:(UISegmentedControl *)seg{
    
}
#pragma mark tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 270;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取到对应cell的model
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:videoCell forIndexPath:indexPath];
    __block VideoModel *model = self.dataSource[indexPath.section];
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
    return cell;
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
