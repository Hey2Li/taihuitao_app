//
//  SearchTableViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/10/13.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "SearchTableViewController.h"
#import "HomeTableViewCell.h"
#import "HomeNewsModel.h"
#import "ArticleDetailViewController.h"
#import "VideoDetailViewController.h"

@interface SearchTableViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic ,strong) NSMutableArray *dataMutableArray;
@property (nonatomic, assign) int pageNum;
@end

@implementation SearchTableViewController
- (NSMutableArray *)dataMutableArray{
    if (!_dataMutableArray) {
        _dataMutableArray = [NSMutableArray array];
    }
    return _dataMutableArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"HomeTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([HomeTableViewCell class])];
    self.tableView.separatorStyle = NO;
    [self footerLoadData];
    _pageNum = 1;
}
- (void)footerLoadData{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        _pageNum++;
        [LTHttpManager TgetMoreNewsWithLimit:@10 Page:@(_pageNum) Cid:@0 Title:self.subTitle Type:@1 Complete:^(LTHttpResult result, NSString *message, id data) {
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

- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    self.title = subTitle;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [LTHttpManager newsListWithLimit:@10 Cid:@0 Type:@1 Title:subTitle Complete:^(LTHttpResult result, NSString *message, id data) {
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataMutableArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 265;
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
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([model.type isEqual: @2] || [model.type isEqual: @5]){
        VideoDetailViewController *vc = [VideoDetailViewController new];
        vc.videoId = model.ID;
        vc.hidesBottomBarWhenPushed = YES;
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
