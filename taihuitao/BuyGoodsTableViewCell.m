//
//  BuyGoodsTableViewCell.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/24.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BuyGoodsTableViewCell.h"

@implementation BuyGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)buyGoodsClick:(id)sender {
    if (self.buyGoodsBlock) {
        self.buyGoodsBlock(sender);
    }
}
-(void)setModel:(ArticleDetailModel *)model{
    _model = model;
    [self.goodsImageView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage new]];
    self.goodsNameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.goodsDetailLabel.text = [NSString stringWithFormat:@"%@",model.introduct];
    self.buyGoodsBtn.tag = [model.ID integerValue];
}
@end
