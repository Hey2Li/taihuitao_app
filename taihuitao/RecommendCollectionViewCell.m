//
//  RecommendCollectionViewCell.m
//  taihuitao
//
//  Created by Tebuy on 2017/10/3.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "RecommendCollectionViewCell.h"

@implementation RecommendCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.recommendImageView.clipsToBounds = YES;
    self.recommendImageView.contentMode = UIViewContentModeScaleAspectFill;
}
- (void)setModel:(RecommedCellModel *)model{
    _model = model;
    [self.recommendImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photo]] placeholderImage:[UIImage imageNamed:@"未加载好图片长"]];
    self.recommendTitleLabel.text = [NSString stringWithFormat:@"%@",model.title];
}
@end
