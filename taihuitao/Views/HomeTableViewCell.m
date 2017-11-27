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
//    self.authorLabel.text = [NSString stringWithFormat:@"%@",model.author];
    self.authorLabel.text = [NSString stringWithFormat:@"熊起"];
//    self.readNumLabel.text = [NSString stringWithFormat:@"%@",model.hits];
    CGFloat count =  [model.hits intValue];
    if (count > 10000) {
          self.readNumLabel.text = [NSString stringWithFormat:@"%.0f万",count/10000];
    }else{
          self.readNumLabel.text = [NSString stringWithFormat:@"%.1f万",count/100];
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
//    self.likeNumLabel.text = [NSString stringWithFormat:@"%@",model.collection];
    int value = (arc4random() % 10000) + 1000;
    self.likeNumLabel.text = [NSString stringWithFormat:@"%d",value];
}
@end
