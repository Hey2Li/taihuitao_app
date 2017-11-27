//
//  HorizontalTableViewCell.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/31.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "HorizontalTableViewCell.h"
#import "RecommendCollectionViewCell.h"
#import "ArticleDetailViewController.h"

@interface HorizontalTableViewCell ()<UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation HorizontalTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UICollectionViewFlowLayout *flowlayout = [[UICollectionViewFlowLayout alloc]init];
        flowlayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [Tool layoutForAlliPhoneHeight:300]) collectionViewLayout:flowlayout];
        collectionView.dataSource = self;
        collectionView.delegate = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
        [self addSubview:collectionView];
        self.collectionView = collectionView;
        collectionView.backgroundColor = [UIColor whiteColor];
        [collectionView registerNib:[UINib nibWithNibName:@"RecommendCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([RecommendCollectionViewCell class])];
        collectionView.showsHorizontalScrollIndicator = NO;
    }
    return self;
}
#pragma mark UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.modelArray.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake([Tool layoutForAlliPhoneWidth:(SCREEN_WIDTH-30)/2] ,CGRectGetHeight(self.bounds));
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 10, 0, 5);
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecommendCollectionViewCell *cell  =[collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([RecommendCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    return cell;
}

- (void)setModelArray:(NSArray *)modelArray{
    _modelArray = modelArray;
    [self.collectionView reloadData];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.HorCollectionCellClick) {
        self.HorCollectionCellClick(indexPath);
    }
    DebugLog(@"点击了");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
