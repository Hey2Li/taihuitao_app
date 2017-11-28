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

    // 设置imageView的tag，在PlayerView中取（建议设置100以上）
    self.picView.tag = 101;
    self.picView.userInteractionEnabled = YES;
    
    // 代码添加playerBtn到imageView上
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.picView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.picView);
        make.width.height.mas_equalTo(50);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
     [self.picView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"photo"]] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    self.dateLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"time"]];
    NSMutableParagraphStyle  *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    // 行间距设置为30
    [paragraphStyle  setLineSpacing:10];
    
    NSString  *testString = dataDic[@"introduct"];
    if (testString.length > 0) {
        NSMutableAttributedString  *setString = [[NSMutableAttributedString alloc] initWithString:testString];
        [setString  addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [testString length])];
        
        // 设置Label要显示的text
        [self.introduceLabel  setAttributedText:setString];
    }else{
        self.introduceLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"introduct"]];
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@",dataDic[@"title"]];
}
- (void)setModel:(ZFVideoModel *)model {
//    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
}
- (void)play:(UIButton *)sender {
    if (self.playBlock) {
        self.playBlock(sender);
    }
}
@end
