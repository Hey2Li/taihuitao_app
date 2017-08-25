//
//  NavigationGradientBar.h
//  简书地址：iOS俱哥 http://www.jianshu.com/u/c68406aa55fa
//
//  Created by zhengju on 17/3/31.
//  Copyright © 2017年 郑俱. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - 屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - 屏幕高度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width



@class NavigationGradientBar;

@protocol NavigationGradientBarDelegate <NSObject>

/**
 代理方法：返回事件

 @param bar 自定义导航条
 */
- (void)backNavigationGradientBar:(NavigationGradientBar *)bar;
- (void)rightNavigationBar:(NavigationGradientBar *)bar;
@end

@interface NavigationGradientBar : UIView

@property (nonatomic,weak) id<NavigationGradientBarDelegate> delegate;

/**
 透明色的返回按钮的箭头名字
 */
@property (nonatomic , copy,readonly) NSString * backImgName;
/**
 渐变之后显示的返回按钮的箭头名字
 */
@property (nonatomic , copy,readonly) NSString * gradientImgName;
/**
 透明色按钮的名字
 */
@property (nonatomic , copy,readonly) NSString * rightImagName;
/**
 渐变之后按钮的名字
 */
@property (nonatomic , copy,readonly) NSString * rightGImageName;
/**
 中间title
 */
@property (nonatomic , copy,readonly) NSString * middleTitle;
/**
 透明色的title颜色，默认白色
 */
@property (nonatomic,strong) UIColor * beginTitleColor;
/**
 渐变色的title颜色，默认白色
 */
@property (nonatomic,strong) UIColor * afterTitleColor;

/**
 开始是否隐藏中间title，默认不隐藏
 */
@property (nonatomic,assign) BOOL beginHiddenMiddleTitle;
/**
 渐变之后是否隐藏中间title，默认不隐藏
 */
@property (nonatomic,assign) BOOL afterHiddenMiddleTitle;

/**
 导航栏的字体颜色，默认黑色
 */
@property (nonatomic,assign) BOOL beginStatusBarDefault;
/**
 导航栏的字体颜色，默认黑色
 */
@property (nonatomic,assign) BOOL afterStatusBarDefault;
/**
 渐变最后的背景色,默认是白色
 */
@property (strong, nonatomic) UIColor *gradientBackgroundColor;

-(instancetype)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName gradientImgName:(NSString *)gradientImgName  middleTitle:(NSString *)middleTitle;
-(instancetype)initWithFrame:(CGRect)frame middleTitle:(NSString *)middleTitle;
-(instancetype)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName middleTitle:(NSString *)middleTitle;

-(instancetype)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName middleTitle:(NSString *)middleTitle delegate:(id<NavigationGradientBarDelegate> )delegate;

-(instancetype)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName gradientImgName:(NSString *)gradientImgName  middleTitle:(NSString *)middleTitle delegate:(id<NavigationGradientBarDelegate>)delegate;

-(instancetype)initWithFrame:(CGRect)frame backImgName:(NSString *)backImgName gradientImgName:(NSString *)gradientImgName rightImgName:(NSString *)rightImgName rightGImgName:(NSString *)rightGImgName middleTitle:(NSString *)middleTitle delegate:(id<NavigationGradientBarDelegate>)delegate;
/**
 渐变的方法
 @param contentOffset 渐变偏移量
 */
-(void)navigationGradientBarContentOffset:(CGFloat)contentOffset;

@end
