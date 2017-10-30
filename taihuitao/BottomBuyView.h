//
//  BottomBuyView.h
//  taihuitao
//
//  Created by Tebuy on 2017/10/30.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BottomBuyViewDelegate <NSObject>
@optional
- (void)backWithBtnClick:(UIButton *)btn;
- (void)buyWithBtnClick:(UIButton *)btn;
@end

@interface BottomBuyView : UIView
- (instancetype)initWithFrame:(CGRect)frame;
@property (nonatomic, weak) id<BottomBuyViewDelegate> delegate;
@end
