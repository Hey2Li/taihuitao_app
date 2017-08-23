//
//  BaseNaviViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/5.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "BaseNaviViewController.h"

@interface BaseNaviViewController ()

@end

@implementation BaseNaviViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.navigationBar.barTintColor = DRGBCOLOR;
    /*
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.translucent = NO;
    //去掉左边的title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationBar.backIndicatorImage = [UIImage imageNamed:@"返回白"];
    self.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回白"];
    
    //自定义一个NavigationBar
    [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationBar.shadowImage = [UIImage new];
    //PingFangSCd自定义title字体
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Light" size:18],NSFontAttributeName, nil];
    self.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi"] forBarMetrics:UIBarMetricsDefault];
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
