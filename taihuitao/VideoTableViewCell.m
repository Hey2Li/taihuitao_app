//
//  VideoTableViewCell.m
//  BearUp
//
//  Created by Tebuy on 2017/5/23.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "VideoTableViewCell.h"


@interface VideoTableViewCell()<ZFPlayerDelegate, ZFPlayerControlViewDelagate>
@property (nonatomic, strong) ZFPlayerView *playerView;
@end
@implementation VideoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initWithCell];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.userInteractionEnabled = YES;
    }
    return self;
}
- (void)initWithCell{
    UIImageView *picView = [UIImageView new];
    picView.image = [UIImage imageNamed:@"未加载好图片长"];
    [self.contentView addSubview:picView];
    [picView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-70);
    }];
    self.picView = picView;
    // 设置imageView的tag，在PlayerView中取（建议设置100以上）
    self.picView.tag = 101;
    self.picView.userInteractionEnabled = YES;
    
    UIView *bottomView = [UIView new];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.picView);
        make.right.equalTo(self.picView);
        make.height.equalTo(@70);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    UILabel *videoTitleLabel = [UILabel new];
    [bottomView addSubview:videoTitleLabel];
    videoTitleLabel.font = [UIFont systemFontOfSize:18];
    videoTitleLabel.textColor = UIColorFromRGB(0x6b6b6b);
    videoTitleLabel.text = @"工作这么辛苦，老板有奖金发吗，我已经做了这么多的";
    [videoTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bottomView.mas_left).offset(10);
        make.right.equalTo(bottomView.mas_right).offset(-10);
        make.height.equalTo(@35);
        make.top.equalTo(self.picView.mas_bottom).offset(5);
    }];
    
    UIButton *hotBtn = [UIButton new];
    [bottomView addSubview:hotBtn];
    [hotBtn setImage:[UIImage imageNamed:@"红火"] forState:UIControlStateNormal];
    [hotBtn setTitle:@"12111" forState:UIControlStateNormal];
    [hotBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    hotBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [hotBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(videoTitleLabel.mas_left);
        make.top.equalTo(videoTitleLabel.mas_bottom).offset(5);
        make.height.equalTo(@20);
        make.width.equalTo(@70);
    }];
    
    UIButton *praiseBtn = [UIButton new];
    [praiseBtn setImage:[UIImage imageNamed:@"点赞灰"] forState:UIControlStateNormal];
    [praiseBtn setImage:[UIImage imageNamed:@"点赞红"] forState:UIControlStateSelected];
    [praiseBtn setTitle:@"6548" forState:UIControlStateNormal];
    [praiseBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    praiseBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [praiseBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [bottomView addSubview:praiseBtn];
    [praiseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(hotBtn.mas_right).offset(10);
        make.height.equalTo(hotBtn.mas_height);
        make.width.equalTo(@70);
        make.centerY.equalTo(hotBtn.mas_centerY);
    }];
    
    UIButton *commendBtn = [UIButton new];
    [commendBtn setImage:[UIImage imageNamed:@"评论灰"] forState:UIControlStateNormal];
    [commendBtn setTitle:@"325" forState:UIControlStateNormal];
    [commendBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    commendBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [commendBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    [bottomView addSubview:commendBtn];
    [commendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(praiseBtn.mas_right).offset(10);
        make.height.equalTo(hotBtn.mas_height);
        make.width.equalTo(@70);
        make.centerY.equalTo(hotBtn.mas_centerY);
    }];
    
    UIButton *shareBtn = [UIButton new];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn setImage:[UIImage imageNamed:@"分享灰"] forState:UIControlStateNormal];
    [shareBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    [shareBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [bottomView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bottomView.mas_right).offset(-10);
        make.height.equalTo(hotBtn.mas_height);
        make.width.equalTo(@70);
        make.centerY.equalTo(hotBtn.mas_centerY);
    }];
    
//    UILabel *playAmountLabel = [UILabel new];
//    playAmountLabel.textAlignment = NSTextAlignmentLeft;
//    playAmountLabel.font = [UIFont systemFontOfSize:12];
//    playAmountLabel.backgroundColor = [UIColor clearColor];
//    playAmountLabel.textColor = [UIColor whiteColor];
//    playAmountLabel.text = @"4123播放";
//    [bottomView addSubview:playAmountLabel];
//    [playAmountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(bottomView.mas_left).offset(10);
//        make.centerY.equalTo(bottomView.mas_centerY);
//        make.width.equalTo(@100);
//        make.height.equalTo(@15);
//    }];
//    
//    UILabel *playTimeLabel = [UILabel new];
//    playTimeLabel.textAlignment = NSTextAlignmentRight;
//    playTimeLabel.font = [UIFont systemFontOfSize:12];
//    playTimeLabel.backgroundColor = [UIColor clearColor];
//    playTimeLabel.textColor = [UIColor whiteColor];
//    playTimeLabel.text = @"3:20";
//    [bottomView addSubview:playTimeLabel];
//    [playTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(bottomView.mas_right).offset(-10);
//        make.height.equalTo(@15);
//        make.width.equalTo(@50);
//        make.centerY.equalTo(bottomView.mas_centerY);
//    }];
    
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn setImage:[UIImage imageNamed:@"video_list_cell_big_icon"] forState:UIControlStateNormal];
    [self.playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
    [self.picView addSubview:self.playBtn];
    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.picView);
        make.width.height.mas_equalTo(50);
    }];
    [praiseBtn addTarget:self action:@selector(praiseClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    self.hotBtn = hotBtn;
    self.praiseBtn = praiseBtn;
    self.commentBtn = commendBtn;
    self.titleLabel = videoTitleLabel;
}
- (void)setModel:(VideoModel *)model {
    _model = model;
    [self.picView sd_setImageWithURL:[NSURL URLWithString:model.photo] placeholderImage:[UIImage imageNamed:@"loading_bgView"]];
    [self.hotBtn setTitle:[NSString stringWithFormat:@"%@",model.hits] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[NSString stringWithFormat:@"%@",model.comment] forState:UIControlStateNormal];
    [self.praiseBtn setTitle:[NSString stringWithFormat:@"%@",model.agree] forState:UIControlStateNormal];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    if ([model.is_agree isEqual:@1]) {
        self.praiseBtn.selected = YES;
        [self.praiseBtn setImage:[UIImage imageNamed:@"点赞红"] forState:UIControlStateSelected];
        self.praiseBtn.userInteractionEnabled = NO;
    }else{
        self.praiseBtn.selected = NO;
        [self.praiseBtn setImage:[UIImage imageNamed:@"点赞灰"] forState:UIControlStateSelected];
        self.praiseBtn.userInteractionEnabled = YES;
    }
}
- (void)play:(UIButton *)sender{
    if (self.playBlock) {
        self.playBlock(sender);
    }
}
- (void)praiseClick:(UIButton *)sender{
    if (self.model.ID) {
        [LTHttpManager agreeVideosWithId:self.model.ID User_uuid:GETUUID User_id:USER_ID User_token:USER_TOKEN Complete:^(LTHttpResult result, NSString *message, id data) {
            if (LTHttpResultSuccess == result) {
                sender.selected = YES;
                [sender setTitle:[NSString stringWithFormat:@"%@",data[@"responseData"]] forState:UIControlStateSelected];
                [sender setImage:[UIImage imageNamed:@"点赞红"] forState:UIControlStateSelected];
                sender.userInteractionEnabled = NO;
                SVProgressShowStuteText(@"点赞成功", YES);
            }else{
                SVProgressShowStuteText(@"点赞失败", NO);
            }
        }];
    }else{
        SVProgressShowStuteText(@"点赞失败", NO);
    }
}
- (void)shareClick:(UIButton *)sender{
    if (self.shareBlock) {
        self.shareBlock(sender);
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
