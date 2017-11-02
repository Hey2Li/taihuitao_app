//
//  BrandDetailViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/9/4.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BrandDetailViewController.h"
#import "VideoTableViewCell.h"
#import "HomePageTableViewCell.h"
#import "ArticleDetailViewController.h"
#import "VideoDetailViewController.h"
#import "BrandDetailModel.h"
#import "XLPhotoBrowser.h"

@interface BrandDetailViewController ()<UIGestureRecognizerDelegate,UITableViewDelegate, UITableViewDataSource,UIGestureRecognizerDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) UILabel *lineLabel;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, assign) NSUInteger selectIndex;
@property (nonatomic, strong) UIView *navigtionBar;
@property (nonatomic, strong) UILabel *naviTitle;
@property (nonatomic, strong) UIButton *categoryHederBtn;
@property (nonatomic, strong) UIImageView *categoryBackgroundImageView;
@property (nonatomic, strong) UILabel *categoryDetailLabel;
@property (nonatomic, strong) UILabel *focusPeopleLabel;
@property (nonatomic, strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSMutableArray *updateDataArray;
@property (nonatomic, strong) NSMutableArray *welcomeDataArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *focusButton;
@property (nonatomic, strong) NSMutableArray *dataSourceMutableArray;
@end

@implementation BrandDetailViewController
- (NSMutableArray *)dataSourceMutableArray{
    if (!_dataSourceMutableArray) {
        _dataSourceMutableArray = [NSMutableArray array];
    }
    return _dataSourceMutableArray;
}
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
- (NSMutableDictionary *)dataDic{
    if (!_dataDic) {
        _dataDic = [NSMutableDictionary dictionary];
    }
    return _dataDic;
}
- (NSMutableArray *)updateDataArray{
    if (!_updateDataArray) {
        _updateDataArray = [NSMutableArray array];
    }
    return _updateDataArray;
}
- (NSMutableArray *)welcomeDataArray{
    if (!_welcomeDataArray) {
        _welcomeDataArray = [NSMutableArray array];
    }
    return _welcomeDataArray;
}
- (UIView *)navigtionBar{
    if (!_navigtionBar) {
        _navigtionBar =  [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 64)];
        _navigtionBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [self.view addSubview:_navigtionBar];
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [_navigtionBar addSubview:backBtn];
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_navigtionBar.mas_left).offset(5);
            make.height.equalTo(@50);
            make.width.equalTo(@30);
            make.centerY.equalTo(_navigtionBar).offset(10);
        }];
        [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *titleLabel = [UILabel new];
        titleLabel.text = @"";
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.textColor = [UIColor whiteColor];
        [_navigtionBar addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(backBtn.mas_centerY);
            make.centerX.equalTo(_navigtionBar.mas_centerX);
            make.height.equalTo(@25);
            make.width.equalTo(@200);
        }];
        self.naviTitle = titleLabel;
        self.naviTitle.hidden = YES;
    }
    return _navigtionBar;
}
- (void)back:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self initWithView];
    _selectIndex = 1001;
    [self loadData];
}
- (void)loadDataWithType:(NSNumber *)type{
    [LTHttpManager brandShowWithID:self.brandId Limit:@10 Type:type Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            [self.dataSourceMutableArray removeAllObjects];
            for (NSDictionary *dic in data[@"responseData"][@"rows"]) {
                BrandDetailModel *model = [BrandDetailModel mj_objectWithKeyValues:dic];
                [self.dataSourceMutableArray addObject:model];
            }
            [self.myTableView reloadData];
        }else{
            
        }
    }];
}
- (void)loadData{
    [LTHttpManager brandShowWithID:self.brandId Limit:@10 Type:@1 Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            //分类详情
            self.dataDic = [NSMutableDictionary dictionaryWithDictionary:data[@"responseData"][@"info"]];
            [self navigtionBar];
            if ([self.dataDic[@"atten"] isEqual:@1]) {
                //未关注
            }else if ([self.dataDic[@"atten"] isEqualToString:@"2"]){
                [self.focusButton setTitle:@"已关注" forState:UIControlStateSelected];
                [self.focusButton setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateSelected];
                self.focusButton.selected = YES;
                self.focusButton.backgroundColor = [UIColor whiteColor];
                [self.focusButton.layer setBorderWidth:1];
                [self.focusButton.layer setBorderColor:UIColorFromRGB(0xaeaeae).CGColor];
                self.focusButton.userInteractionEnabled = NO;
            }
            self.naviTitle.text = [NSString stringWithFormat:@"%@",self.dataDic[@"name"]];
            [self.categoryBackgroundImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataDic[@"photo"]]]];
            [self.categoryHederBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataDic[@"photo"]]] forState:UIControlStateNormal];
            self.focusPeopleLabel.text = [NSString stringWithFormat:@"已关注人数：%@",self.dataDic[@"atten_num"]];
            self.categoryDetailLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"introduct"]];
            //数据
            [self.dataSourceMutableArray removeAllObjects];
            for (NSDictionary *dic in data[@"responseData"][@"rows"]) {
                BrandDetailModel *model = [BrandDetailModel mj_objectWithKeyValues:dic];
                [self.dataSourceMutableArray addObject:model];
            }
            [self.myTableView reloadData];
        }else{
            
        }
    }];
}

- (void)initWithView{
    UITableView *tableView  =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    [self.view addSubview:tableView];
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.top.equalTo(self.view.mas_top).offset(-44);
    }];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = NO;
    tableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    tableView.tableHeaderView = [self tableViewHeaderView];
    [tableView registerClass:[VideoTableViewCell class] forCellReuseIdentifier:@"welcomeCell"];
    self.myTableView = tableView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
- (UIView *)tableViewHeaderView{
    UIView *tableViewHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2)];
    tableViewHeaderView.backgroundColor = [UIColor whiteColor];
    UIImageView *backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT/2 - 50)];
    backgroundImageView.image = [UIImage imageNamed:@"recomand_05"];
    [tableViewHeaderView addSubview:backgroundImageView];
    
    UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    blurView.frame = backgroundImageView.frame;
    [tableViewHeaderView addSubview:blurView];
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [headerBtn setImage:[UIImage imageNamed:@"recomand_05"] forState:UIControlStateNormal];
    [headerBtn.layer setCornerRadius:45];
    [headerBtn.layer setMasksToBounds:YES];
    [blurView.contentView addSubview:headerBtn];
    [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(blurView);
        make.centerY.equalTo(blurView).offset(-40);
        make.height.equalTo(@90);
        make.width.equalTo(headerBtn.mas_height);
    }];
    
    UILabel *detailLabel = [UILabel new];
    detailLabel.textColor = [UIColor whiteColor];
    detailLabel.text = @"SEELE UPC拥有丰富的产品线，包括战骑士、暗黑者、适格者、装甲兵以及使徒等，这一次我们看到的使徒503是一台入门级游戏台式UPC，采";
    detailLabel.font = [UIFont systemFontOfSize:16];
    detailLabel.numberOfLines = 2;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    [blurView.contentView addSubview:detailLabel];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerBtn.mas_bottom).offset(10);
        make.centerX.equalTo(blurView.mas_centerX);
        make.height.equalTo(@40);
        make.right.equalTo(blurView.mas_right).offset(-20);
        make.left.equalTo(blurView.mas_left).offset(20);
    }];
    
    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [focusBtn.layer setMasksToBounds:YES];
    [focusBtn.layer setCornerRadius:15];
    [focusBtn setTitle:@" + 关注" forState:UIControlStateNormal];
    [focusBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [focusBtn setBackgroundColor:UIColorFromRGB(0xff4466)];
    [focusBtn setTitle:@"已关注" forState:UIControlStateSelected];
    [focusBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateSelected];
    [focusBtn addTarget:self action:@selector(focusCategory:) forControlEvents:UIControlEventTouchUpInside];
    [blurView.contentView addSubview:focusBtn];
    [focusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(blurView.mas_centerX);
        make.height.equalTo(@30);
        make.width.equalTo(@200);
        make.top.equalTo(detailLabel.mas_bottom).offset(10);
    }];
    
    UILabel *focusNum = [UILabel new];
    focusNum.textColor = [UIColor whiteColor];
    focusNum.font = [UIFont systemFontOfSize:14];
    focusNum.textAlignment = NSTextAlignmentCenter;
    focusNum.text = @"已关注人数：2345";
    [blurView.contentView addSubview:focusNum];
    [focusNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(blurView.mas_centerX);
        make.bottom.equalTo(blurView.mas_bottom).offset(-10);
        make.height.equalTo(@20);
        make.width.equalTo(@150);
    }];
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"文章" forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    [leftBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateSelected];
    leftBtn.selected = YES;
    _tempBtn = leftBtn;
    [tableViewHeaderView addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableViewHeaderView);
        make.width.equalTo(@(SCREEN_WIDTH/4));
        make.top.equalTo(blurView.mas_bottom);
        make.bottom.equalTo(tableViewHeaderView);
    }];
    
    UIButton *secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [secondBtn setTitle:@"视频" forState:UIControlStateNormal];
    [secondBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    [secondBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateSelected];
    secondBtn.selected = NO;
    _tempBtn = secondBtn;
    [tableViewHeaderView addSubview:secondBtn];
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftBtn.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH/4));
        make.top.equalTo(blurView.mas_bottom);
        make.bottom.equalTo(tableViewHeaderView);
    }];
    
    UIButton *thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [thirdBtn setTitle:@"图集" forState:UIControlStateNormal];
    [thirdBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    [thirdBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateSelected];
    thirdBtn.selected = NO;
    _tempBtn = thirdBtn;
    [tableViewHeaderView addSubview:thirdBtn];
    [thirdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(secondBtn.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH/4));
        make.top.equalTo(blurView.mas_bottom);
        make.bottom.equalTo(tableViewHeaderView);
    }];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"直播" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateSelected];
    [tableViewHeaderView addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(thirdBtn.mas_right);
        make.width.equalTo(@(SCREEN_WIDTH/4));
        make.top.equalTo(blurView.mas_bottom);
        make.bottom.equalTo(tableViewHeaderView);
    }];
    
    UILabel *lineLable = [UILabel new];
    lineLable.backgroundColor = UIColorFromRGB(0xff4466);
    [tableViewHeaderView addSubview:lineLable];
    [lineLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@40);
        make.height.equalTo(@1);
        make.centerX.equalTo(leftBtn.mas_centerX);
        make.bottom.equalTo(leftBtn);
    }];
    self.lineLabel = lineLable;
    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [secondBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [thirdBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.tag = 1001;
    secondBtn.tag = 1002;
    thirdBtn.tag = 1003;
    rightBtn.tag = 1005;
    self.categoryHederBtn = headerBtn;
    self.categoryDetailLabel = detailLabel;
    self.categoryBackgroundImageView = backgroundImageView;
    self.focusPeopleLabel = focusNum;
    self.focusButton = focusBtn;
    return tableViewHeaderView;
}
- (void)focusCategory:(UIButton *)btn{
    [LTHttpManager focusCategoryWithCid:self.dataDic[@"id"] Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            btn.selected = YES;
            btn.userInteractionEnabled = NO;
            SVProgressShowStuteText(@"关注成功", YES);
            btn.backgroundColor = [UIColor whiteColor];
            [btn setTitle:@"已关注" forState:UIControlStateSelected];
            [btn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateSelected];
        }else{
            btn.selected = NO;
            [btn setBackgroundColor:UIColorFromRGB(0xff4466)];
            [btn.layer setBorderColor:UIColorFromRGB(0xff4466).CGColor];
            // [self.view makeToast:message];
        }
    }];
}
- (void)leftBtnClick:(UIButton *)btn{
    if (_tempBtn == nil) {
        btn.selected = YES;
        _tempBtn = btn;
    }else if (_tempBtn != nil && _tempBtn == btn){
        btn.selected = YES;
    }else if (_tempBtn != nil && _tempBtn != btn){
        btn.selected = YES;
        _tempBtn.selected = NO;
        _tempBtn = btn;
    }
    if (btn.selected) {
        [self.lineLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@1);
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn);
        }];
        [self.lineLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@40);
            make.height.equalTo(@1);
            make.centerX.equalTo(btn.mas_centerX);
            make.bottom.equalTo(btn);
        }];
        [UIView animateWithDuration:0.2 animations:^{
            [self.lineLabel.superview layoutIfNeeded];
        }];
        _selectIndex = btn.tag;
        [self loadDataWithType:@(_selectIndex - 1000)];
        [self.myTableView reloadData];
    }
}

#pragma mark TableViewDelage
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSourceMutableArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [Tool layoutForAlliPhoneHeight:220];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[HomePageTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.brandDetailModel = self.dataSourceMutableArray[indexPath.section];
    cell.hotImageView.hidden = YES;
    cell.hotNumLabel.hidden = YES;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BrandDetailModel *model = self.dataSourceMutableArray[indexPath.section];
    if (_selectIndex == 1002 || _selectIndex == 1005) {
        VideoDetailViewController *vc = [VideoDetailViewController new];
        vc.videoId = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
    }else if (_selectIndex == 1003){
        [LTHttpManager TnewsDetailWithId:model.ID Value:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                NSArray *imageArray = data[@"responseData"][@"info"][@"images"];
                NSLog(@"%@",imageArray);
                NSMutableArray *imageMutableArray = [NSMutableArray array];
                [imageArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    NSString *imageUrl = obj[@"photo"];
                    [imageMutableArray addObject:imageUrl];
                }];
                XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithImages:imageMutableArray currentImageIndex:0];
                browser.browserStyle = XLPhotoBrowserStyleIndexLabel; // 微博样式
            }
        }];
    }else{
        ArticleDetailViewController *vc = [[ArticleDetailViewController alloc]init];
        vc.articleId = model.ID;
        [self.navigationController pushViewController:vc animated:YES];
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
