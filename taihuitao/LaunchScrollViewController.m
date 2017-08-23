//
//  LaunchScrollViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/7/21.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "LaunchScrollViewController.h"
#import "BaseTabBarViewController.h"

@interface LaunchScrollViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation LaunchScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)initWithView{
    NSArray *imageArray = @[@"首次打开使用介绍",@"首次打开使用介绍2",@"首次打开使用介绍3",@"首次打开使用介绍4"];
    UIScrollView *scrollView = [UIScrollView new];
    scrollView.delegate = self;
    [self.view addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * 4, SCREEN_HEIGHT);
    self.scrollView = scrollView;
    for (int i = 0; i < imageArray.count; i++) {
        UIImageView *imageView = [UIImageView new];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [self.scrollView addSubview:imageView];
        imageView.frame = CGRectMake(SCREEN_WIDTH * i, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        if (i >= 0) {
            imageView.userInteractionEnabled = YES;
            UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            loginBtn.backgroundColor = [UIColor clearColor];
            [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [imageView addSubview:loginBtn];
            [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(imageView.mas_centerX);
                make.width.equalTo(@100);
                make.height.equalTo(@55);
                make.bottom.equalTo(imageView.mas_bottom).offset(-50);
            }];

        }
    }
    
    UIPageControl *pageControl = [UIPageControl new];
    pageControl.backgroundColor = DRGBCOLOR;
    pageControl.numberOfPages = imageArray.count;
    [self.view addSubview:pageControl];
    [pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
        make.bottom.equalTo(self.view.mas_bottom).offset(-50);
    }];
    self.pageControl = pageControl;
    self.pageControl.hidden = YES;
}
- (void)loginBtnClick:(UIButton *)btn{
    if ([self.type isEqualToString:@"1"]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        BaseTabBarViewController *tabVC = [BaseTabBarViewController new];
        [self presentViewController:tabVC animated:YES completion:nil];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat index = scrollView.contentOffset.x/SCREEN_WIDTH;
    self.pageControl.currentPage = index;
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
