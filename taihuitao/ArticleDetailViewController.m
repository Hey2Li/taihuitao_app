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

@interface ArticleDetailViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@end

@implementation ArticleDetailViewController

- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        [_myTableView registerNib:[UINib nibWithNibName:@"GoodsDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"gooddetailcell"];
        [_myTableView registerNib:[UINib nibWithNibName:@"BuyGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"buygoodcell"];
    }
    return _myTableView;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self.view addSubview:self.myTableView];
        self.view.backgroundColor = [UIColor whiteColor];
        
        UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"关闭" style:UIBarButtonItemStyleDone target:self action:@selector(back)];
        self.navigationItem.leftBarButtonItem = item;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        self.myTableView.estimatedRowHeight = 300;
        self.myTableView.rowHeight = UITableViewAutomaticDimension;
        return self.myTableView.rowHeight;
    }else if (indexPath.section == 1){
        self.myTableView.estimatedRowHeight = 80;
        self.myTableView.rowHeight = UITableViewAutomaticDimension;
        return self.myTableView.rowHeight;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        GoodsDetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"gooddetailcell"];
        return cell;
    }else if (indexPath.section == 1){
        BuyGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buygoodcell"];
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
