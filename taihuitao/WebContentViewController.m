//
//  WebContentViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/7/21.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "WebContentViewController.h"

@interface WebContentViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIBarButtonItem *backItem;
@property (nonatomic, strong) UIBarButtonItem *closeItem;

@end

@implementation WebContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.webView.delegate = self;
    self.webView.opaque = NO;
    self.webView.backgroundColor = [UIColor clearColor];
    if (self.UrlString.length > 3) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.UrlString]]];
    }
    self.webView.delegate = self;
    // 初始化返回、关闭两个按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [button setBounds:CGRectMake(0, 0, 42, 28)];
    [button.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -2, 0, 0)];
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -9, 0, 0)];
    [button addTarget:self action:@selector(backEven:) forControlEvents:UIControlEventTouchUpInside];
    [button setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    self.backItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(popPage)];
    self.closeItem.tintColor = [UIColor blackColor];
    [self setLeftBarButton];
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    SVProgressShow();
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"加载完毕");
    [self setLeftBarButton];
    NSString *theTitle = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    if (theTitle.length > 10) {
        theTitle = [[theTitle substringToIndex:9] stringByAppendingString:@"…"];
    }
    self.title = theTitle;
    SVProgressHiden();
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    SVProgressShowStuteText(@"加载失败", NO);
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:NO];
}
#pragma mark - 事件响应
/// 返回按钮事件
- (void)backEven:(UIButton *)button
{
    if ([self.webView canGoBack]){
        [self.webView goBack];
    }else{
        [self popPage];
    }
}
/// 关闭事件
- (void)popPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
/// 刷新左上角按钮
- (void)setLeftBarButton{
    if ([self.webView canGoBack]){
        [self.navigationItem setLeftBarButtonItems:@[self.backItem, self.closeItem]];
    }else{
        [self.navigationItem setLeftBarButtonItems:@[self.backItem]];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
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
