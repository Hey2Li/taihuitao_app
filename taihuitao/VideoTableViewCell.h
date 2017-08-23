//
//  VideoTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/5/23.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"
@interface VideoTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *picView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *hotBtn;
@property (nonatomic, strong) UIButton *commentBtn;
@property (nonatomic, strong) UILabel *titleLabel;
/** 播放按钮block */
@property (nonatomic, copy  ) void(^playBlock)(UIButton *);
@property (nonatomic, strong) VideoModel  *model;

/**
 分享block
 */
@property (nonatomic, strong) void(^shareBlock)(UIButton *);
@end
