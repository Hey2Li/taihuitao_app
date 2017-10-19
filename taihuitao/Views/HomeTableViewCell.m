//
//  HomeTableViewCell.m
//  taihuitao
//
//  Created by Tebuy on 2017/10/10.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "HomeTableViewCell.h"

@implementation HomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setModel:(HomeNewsModel *)model{
    _model = model;
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photo]] placeholderImage:[UIImage imageNamed:@"未加载好图片长"]];
    self.authorLabel.text = [NSString stringWithFormat:@"%@",model.author];
    self.readNumLabel.text = [NSString stringWithFormat:@"%@",model.hits];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    self.likeNumLabel.text = [NSString stringWithFormat:@"%@",model.collection];
}
@end
