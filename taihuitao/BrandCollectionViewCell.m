//
//  BrandCollectionViewCell.m
//  taihuitao
//
//  Created by Tebuy on 2017/10/16.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BrandCollectionViewCell.h"

@implementation BrandCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self.layer setMasksToBounds:YES];
//    [self.layer setBorderWidth:1];
//    [self.layer setBorderColor:UIColorFromRGB(0x000000).CGColor];
//    [self.layer setCornerRadius:3];
}

- (void)setHotBrandModel:(BrandNameModel *)hotBrandModel{
    _hotBrandModel = hotBrandModel;
    [self.brandImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",hotBrandModel.photo]] placeholderImage:[UIImage imageNamed:@"未加载好图片长"]];
}
@end
