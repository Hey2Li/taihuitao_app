//
//  CategoryViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/17.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "CategoryViewController.h"
#import "CACollectionReusableView.h"
#import "BrandDetailViewController.h"

@interface CategoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *myCollectionView;
@property (nonatomic, strong) NSArray *headerArray;
@property (nonatomic, strong) NSDictionary *brandDic;
@property (nonatomic, strong) NSMutableArray *brandTitleMutableArray;
@end
static NSString * const reuseIdentifierHeader = @"HeaderCell";

@implementation CategoryViewController
- (NSMutableArray *)brandTitleMutableArray{
    if (!_brandTitleMutableArray) {
        _brandTitleMutableArray = [NSMutableArray array];
    }
    return _brandTitleMutableArray;
}
- (UICollectionView *)myCollectionView{
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) collectionViewLayout:layout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        [_myCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
//        [_myCollectionView registerNib:[UINib nibWithNibName:@"CACollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader];
        [_myCollectionView registerClass:[CACollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:reuseIdentifierHeader];
    }
    return _myCollectionView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"分类";
    [self.view addSubview:self.myCollectionView];
    self.headerArray = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
    [self loadData];
}
- (void)loadData{
    [LTHttpManager brandIndexWithComplete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            self.brandDic = data[@"responseData"][@"brands"];
            NSArray *array = [NSMutableArray arrayWithArray:[self.brandDic allKeys]];
           self.brandTitleMutableArray = [NSMutableArray arrayWithArray: [array sortedArrayUsingSelector:@selector(compare:)]];
            [self.myCollectionView reloadData];
        }else{

        }
    }];
}
#pragma mark UICollectionView Delegate DataSource
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70, 35);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}
//头部试图的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section >= 0) {
        return CGSizeMake(ScreenWidth, 40);
    }else{
        return CGSizeMake(0, 0);
    }
}
//脚部试图的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(50, 60);
//}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.brandTitleMutableArray.count;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *brandArray = self.brandDic[self.brandTitleMutableArray[section]];
    return brandArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell  =[self.myCollectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndexPath:indexPath];
    [cell.layer setMasksToBounds:YES];
    [cell.layer setBorderWidth:1];
    [cell.layer setBorderColor:UIColorFromRGB(0x000000).CGColor];
    [cell.layer setCornerRadius:3];
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(cell.mas_left);
        make.right.equalTo(cell.mas_right);
        make.bottom.equalTo(cell.mas_bottom);
        make.top.equalTo(cell.mas_top);
    }];
    NSArray *brandArray = self.brandDic[self.brandTitleMutableArray[indexPath.section]];
    titleLabel.text = [NSString stringWithFormat:@"%@",brandArray[indexPath.row][@"name"]];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    CACollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuseIdentifierHeader forIndexPath:indexPath];
    headerView.titleLabel.text = [NSString stringWithFormat:@"%@",self.brandTitleMutableArray[indexPath.section]];
    return headerView;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    BrandDetailViewController *vc =[[BrandDetailViewController alloc]init];
    vc.brandId = self.brandDic[self.brandTitleMutableArray[indexPath.section]][indexPath.row][@"id"];
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
