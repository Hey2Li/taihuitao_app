//
//  NavigationGradientBar.m
//  简书地址：iOS俱哥 http://www.jianshu.com/u/c68406aa55fa
//
//  Created by zhengju on 17/3/31.
//  Copyright © 2017年 郑俱. All rights reserved.
//

#import "NavigationGradientBar.h"


#define barHeight 50.00

@interface NavigationGradientBar()

@property (nonatomic,strong) UIButton * backBtn;
@property (nonatomic,strong) UIButton *rightBtn;
@property (nonatomic,strong) UILabel * middleTitleL;

@end

@implementation NavigationGradientBar
-(instancetype)initWithFrame:(CGRect)frame middleTitle:(NSString *)middleTitle{
    return [self initWithFrame:frame backImgName:nil middleTitle:middleTitle];
}
-(instancetype)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName middleTitle:(NSString *)middleTitle{
    return  [self initWithFrame:frame backImgName:backImgName gradientImgName:nil middleTitle:middleTitle];
}
-(instancetype)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName middleTitle:(NSString *)middleTitle delegate:(id<NavigationGradientBarDelegate> )delegate{
    return [self initWithFrame:frame backImgName:backImgName gradientImgName:nil middleTitle:middleTitle delegate:delegate];
}
-(instancetype)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName gradientImgName:(NSString *)gradientImgName middleTitle:(NSString *)middleTitle delegate:(id<NavigationGradientBarDelegate> )delegate{
    if (self = [super initWithFrame:frame]) {
        
        _backImgName = backImgName;
        _middleTitle = middleTitle;
        _gradientImgName = gradientImgName;
      
        self.delegate = delegate;
        self.beginStatusBarDefault = YES;
        self.afterStatusBarDefault = YES;
        
        //暂时没用到
        self.gradientBackgroundColor = [UIColor whiteColor];
        
        [self configureUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName gradientImgName:(NSString *)gradientImgName rightImgName:(NSString *)rightImgName rightGImgName:(NSString *)rightGImgName middleTitle:(NSString *)middleTitle delegate:(id<NavigationGradientBarDelegate>)delegate{
    if (self = [super initWithFrame:frame]) {
        
        _backImgName = backImgName;
        _middleTitle = middleTitle;
        _gradientImgName = gradientImgName;
        _rightGImageName = rightGImgName;
        _rightImagName = rightImgName;
        
        self.delegate = delegate;
        self.beginStatusBarDefault = YES;
        self.afterStatusBarDefault = YES;
        
        //暂时没用到
        self.gradientBackgroundColor = [UIColor whiteColor];
        
        [self configureUI];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName gradientImgName:(NSString *)gradientImgName middleTitle:(NSString *)middleTitle{
    return [self initWithFrame:frame backImgName:backImgName gradientImgName:gradientImgName middleTitle:middleTitle delegate:nil];
}

-(void)setBeginTitleColor:(UIColor *)beginTitleColor{
    _beginTitleColor = beginTitleColor;
    self.middleTitleL.textColor = _beginTitleColor;
}
-(void)setAfterTitleColor:(UIColor *)afterTitleColor{
    _afterTitleColor = afterTitleColor;
}
-(void)setBeginStatusBarDefault:(BOOL)beginStatusBarDefault{
    _beginStatusBarDefault = beginStatusBarDefault;
}
-(void)setAfterStatusBarDefault:(BOOL)afterStatusBarDefault{
    _afterStatusBarDefault = afterStatusBarDefault;
}
-(void)setGradientBackgroundColor:(UIColor *)gradientBackgroundColor{
    _gradientBackgroundColor = gradientBackgroundColor;
}
-(void)setBeginHiddenMiddleTitle:(BOOL)beginHiddenMiddleTitle{
   
    _beginHiddenMiddleTitle = beginHiddenMiddleTitle;
    self.middleTitleL.alpha = 0.0f;
}
-(void)configureUI{
    if (_backImgName) {
        self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, 24, 40, 40)];
        [self.backBtn setImage:[UIImage imageNamed:_backImgName] forState:UIControlStateNormal];
        [self.backBtn addTarget:self action:@selector(backToBeginView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.backBtn];
    }
    if (_rightImagName) {
        self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth - 48, 24, 40, 40)];
        [self.rightBtn setImage:[UIImage imageNamed:_rightImagName] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(rightToBeginView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.rightBtn];
    }
    CGFloat width = 100.0f;//默认长度是100
    self.middleTitleL = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width -width)/2.0, 24, width, 40)];
    self.middleTitleL.textColor = [UIColor whiteColor];
    self.middleTitleL.font = [UIFont systemFontOfSize:20];
    self.middleTitleL.textAlignment = NSTextAlignmentCenter;
    self.middleTitleL.text = _middleTitle;
    [self addSubview:self.middleTitleL];
}
-(void)navigationGradientBarContentOffset:(CGFloat)contentOffset{
    
     CGFloat alpha = 1- (barHeight - contentOffset)/barHeight;
    
    if (contentOffset <barHeight) {
         [self.backBtn setImage:[UIImage imageNamed:_backImgName] forState:UIControlStateNormal];
        [self.rightBtn setImage:[UIImage imageNamed:_rightImagName] forState:UIControlStateNormal];
        if (_beginTitleColor) {
            self.middleTitleL.textColor = _beginTitleColor;
        }
        if (_beginHiddenMiddleTitle) {
            self.middleTitleL.alpha = alpha;
        }
        [[UIApplication sharedApplication] setStatusBarStyle:_beginStatusBarDefault ?UIStatusBarStyleDefault :UIStatusBarStyleLightContent];
    }else{
        if (_gradientImgName) {
             [self.backBtn setImage:[UIImage imageNamed:_gradientImgName] forState:UIControlStateNormal];
        }
        if (_rightGImageName) {
            [self.rightBtn setImage:[UIImage imageNamed:_rightGImageName] forState:UIControlStateNormal];
        }
        if (_afterTitleColor) {
            self.middleTitleL.textColor = _afterTitleColor;
        }
        [[UIApplication sharedApplication] setStatusBarStyle:_afterStatusBarDefault ?UIStatusBarStyleDefault :UIStatusBarStyleLightContent];
    }
    self.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:alpha];
}
-(void)backToBeginView{
    if ([self.delegate respondsToSelector:@selector(backNavigationGradientBar:)]) {
        [self.delegate backNavigationGradientBar:self];
    }
}
-(void)rightToBeginView{
    if ([self.delegate respondsToSelector:@selector(backNavigationGradientBar:)]) {
        [self.delegate rightNavigationBar:self];
    }
}
@end
