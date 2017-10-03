//
//  RecommendCollectionViewCell.h
//  taihuitao
//
//  Created by Tebuy on 2017/10/3.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommedCellModel.h"
@interface RecommendCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *recommendImageView;
@property (weak, nonatomic) IBOutlet UILabel *recommendTitleLabel;
@property (nonatomic, strong) RecommedCellModel *model;
@end
