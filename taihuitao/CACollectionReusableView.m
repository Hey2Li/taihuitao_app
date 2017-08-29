//
//  CACollectionReusableView.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/29.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "CACollectionReusableView.h"

@implementation CACollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *titleLabel = [UILabel new];
        [self addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
    }
    return self;
}
@end
