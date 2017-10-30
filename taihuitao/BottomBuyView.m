//
//  BottomBuyView.m
//  taihuitao
//
//  Created by Tebuy on 2017/10/30.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BottomBuyView.h"

@implementation BottomBuyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initWithView];
    }
    return self;
}
- (void)initWithView{
    UIButton *backBtn = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset(10);
            make.centerY.equalTo(self.mas_centerY);
            make.height.equalTo(@35);
            make.width.equalTo(@35);
        }];
        [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    
    UIButton *buyBtn = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backBtn.mas_right).offset(20);
            make.centerY.equalTo(backBtn.mas_centerY);
            make.height.equalTo(@40);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
        [btn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"购买" forState:UIControlStateNormal];
        [btn setTitle:@"收起" forState:UIControlStateSelected];
        [btn setBackgroundColor:DRGBCOLOR];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.layer setMasksToBounds:YES];
        [btn.layer setCornerRadius:5];
        btn;
    });
}
- (void)buyBtnClick:(UIButton *)btn{
    [_delegate buyWithBtnClick:btn];
}
- (void)backBtnClick:(UIButton *)btn{
    [_delegate backWithBtnClick:btn];
}
@end
