//
//  GoodsDetailsTableViewCell.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/24.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "GoodsDetailsTableViewCell.h"

@implementation GoodsDetailsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.dateLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"time"]];
    self.introduceLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"introduct"]];
    [self.goodsBkImageView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"photo"]] placeholderImage:[UIImage imageNamed:@"未加载好图片长"]];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"title"]];
    self.readNumLabel.text = [NSString stringWithFormat:@"阅读:%@",dataDic[@"hits"]];
}
@end
