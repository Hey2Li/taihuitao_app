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
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    SVProgressShow();
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
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
