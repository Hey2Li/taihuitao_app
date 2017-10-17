//
//  NCategoryViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/10/17.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "NCategoryViewController.h"
#import "BrandCollectionViewCell.h"
#import "BrandName.h"
#import "BrandNameModel.h"
#import "BrandDetailViewController.h"
#define CATEGORY @[@"推荐",@"断货王",@"妆心得",@"美食番",@"品牌购",@"汇生活"]

@interface NCategoryViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, strong) NSMutableArray *categoryMutableArray;
@property (nonatomic, strong) NSMutableArray *subCategoryMutableArray;
@end

@implementation NCategoryViewController

- (NSMutableArray *)subCategoryMutableArray{
    if (!_subCategoryMutableArray) {
        _subCategoryMutableArray = [NSMutableArray array];
    }
    return _subCategoryMutableArray;
}
- (NSMutableArray *)categoryMutableArray{
    if (!_categoryMutableArray) {
        _categoryMutableArray = [NSMutableArray array];
    }
    return _categoryMutableArray;
}
- (UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _leftTableView;
}
- (UICollectionView *)rightCollectionView{
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        _rightCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/4*3, SCREEN_HEIGHT) collectionViewLayout:layout];
        _rightCollectionView.backgroundColor = RGBCOLOR(244, 245, 246);
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        [_rightCollectionView registerNib:[UINib nibWithNibName:@"BrandCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([BrandCollectionViewCell class])];
    }
    return _rightCollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.leftTableView];
    [self.view addSubview:self.rightCollectionView];
    self.title = @"分类";
    [self loadData];
}
- (void)loadData{
    [LTHttpManager brandIndexWithComplete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            NSArray *cateArray = data[@"responseData"][@"category"];
            [self.categoryMutableArray removeAllObjects];
            for (NSDictionary *dic in cateArray) {
                BrandName *model = [BrandName mj_objectWithKeyValues:dic];
                [self.categoryMutableArray addObject:model];
            }
            NSArray *hotArray = data[@"responseData"][@"hotbrands"];
            [self.subCategoryMutableArray removeAllObjects];
            [hotArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                BrandNameModel *model = [BrandNameModel mj_objectWithKeyValues:obj];
                [self.subCategoryMutableArray addObject:model];
            }];
            [self.rightCollectionView reloadData];
            [self.leftTableView reloadData];
        }else{
            
        }
    }];
}
#pragma mark TableView Delagate DataSource
- (void)viewDidLayoutSubviews {
    
    if ([self.leftTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        
        self.leftTableView.layoutMargins = UIEdgeInsetsZero;
    }
    if ([self.leftTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        self.leftTableView.separatorInset = UIEdgeInsetsZero;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        cell.layoutMargins = UIEdgeInsetsZero;
    }
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset = UIEdgeInsetsZero;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.categoryMutableArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = RGBCOLOR(244, 245, 246);
    [cell setSelectedBackgroundView:bgColorView];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"热门品牌";
        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:(UITableViewScrollPositionNone)];
    }else{
        BrandName *model = self.categoryMutableArray[indexPath.row - 1];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row > 0) {
        BrandName *model = self.categoryMutableArray[indexPath.row - 1];
        [LTHttpManager brandSearchWithID:model.ID Limit:@30 Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                NSArray *array = data[@"responseData"];
                [self.subCategoryMutableArray removeAllObjects];
                [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BrandNameModel *model = [BrandNameModel mj_objectWithKeyValues:obj];
                    [self.subCategoryMutableArray addObject:model];
                }];
                [self.rightCollectionView reloadData];
            }else{
                
            }
        }];
    }else{
        [LTHttpManager brandIndexWithComplete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                NSArray *hotArray = data[@"responseData"][@"hotbrands"];
                [self.subCategoryMutableArray removeAllObjects];
                [hotArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    BrandNameModel *model = [BrandNameModel mj_objectWithKeyValues:obj];
                    [self.subCategoryMutableArray addObject:model];
                }];
                [self.rightCollectionView reloadData];
            }else{
                
            }
        }];
    }
}
#pragma mark CollectionView Delegate DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.subCategoryMutableArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH/4*3 - 23)/3, 50);
}
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
//    return CGSizeMake(SCREEN_WIDTH, 30);
//}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([BrandCollectionViewCell class]) forIndexPath:indexPath];
    cell.hotBrandModel = self.subCategoryMutableArray[indexPath.row];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandDetailViewController *vc =[[BrandDetailViewController alloc]init];
    BrandNameModel *model = self.subCategoryMutableArray[indexPath.row];
    vc.brandId = model.ID;
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
