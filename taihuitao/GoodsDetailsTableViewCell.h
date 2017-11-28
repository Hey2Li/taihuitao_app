//
//  GoodsDetailsTableViewCell.h
//  taihuitao
//
//  Created by Tebuy on 2017/8/24.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayer.h"
#import "ZFVideoModel.h"

@interface GoodsDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UIButton                      *playBtn;

/** model */
@property (nonatomic, strong) ZFVideoModel                  *model;
/** 播放按钮block */
@property (nonatomic, copy  ) void(^playBlock)(UIButton *);
@end
