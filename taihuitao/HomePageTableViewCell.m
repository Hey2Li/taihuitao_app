
//
//  HomePageTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/5/10.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "HomePageTableViewCell.h"

@implementation HomePageTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initWithCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)initWithCell{
    
    self.contentImageView = [[UIImageView alloc]init];
    self.contentImageView.image = [UIImage imageNamed:@"index_news_1.jpg"];
    [self.contentView addSubview:self.contentImageView];
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];

    UIView *grayView = [[UIView alloc]init];
    grayView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.contentImageView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentImageView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = @"这是标题";
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.numberOfLines = 2;
    [grayView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentImageView.mas_left).offset(50);
        make.right.equalTo(self.contentImageView.mas_right).offset(-50);
        make.height.equalTo(@50);
        make.centerY.equalTo(self.contentImageView.mas_centerY);
    }];
    
    self.hotNumLabel = [UILabel new];
    self.hotNumLabel.text = @"121235";
    CGFloat count =  [self.hotNumLabel.text intValue];
    if (count > 10000) {
        self.hotNumLabel.text = [NSString stringWithFormat:@"%.1f万",count/10000];
    }else{
        self.hotNumLabel.text = [NSString stringWithFormat:@"%.0f",count];
    }

    self.hotNumLabel.textColor = UIColorFromRGB(0xffffff);
    self.hotNumLabel.font = [UIFont systemFontOfSize:16];
    [grayView addSubview:self.hotNumLabel];
    [self.hotNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentImageView.mas_right).offset(-5);
        make.width.equalTo(@50);
        make.height.equalTo(@20);
        make.bottom.equalTo(self.contentImageView.mas_bottom).offset(-5);
    }];
    
    self.hotImageView = [UIImageView new];
    [grayView addSubview:self.hotImageView];
    self.hotImageView.contentMode = UIViewContentModeCenter;
    self.hotImageView.image = [UIImage imageNamed:@"火"];
    [self.hotImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.hotNumLabel.mas_centerY);
        make.right.equalTo(self.hotNumLabel.mas_left).offset(-5);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
}
- (void)setModel:(HomeModel *)model{
    _model = model;
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    [self.contentImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.photo]] placeholderImage:[UIImage imageNamed:@"未加载好图片长"]];
    self.hotNumLabel.text = [NSString stringWithFormat:@"%@",model.hits];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
