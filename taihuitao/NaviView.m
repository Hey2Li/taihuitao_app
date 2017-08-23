//
//  NaviView.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/21.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "NaviView.h"

@interface NaviView ()<UISearchBarDelegate>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UIButton *qrCodeButton;
@end

@implementation NaviView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.searchBar];
        [self addSubview:self.searchButton];
        [self addSubview:self.qrCodeButton];
        
        [self addSubview:self.searchBar];
        [self addSubview:self.searchButton];
        [self addSubview:self.qrCodeButton];
    }
    return self;
}
- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    for (UITableView *tableView in self.tableViews) {
        NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
        [tableView addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
    }
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if (![keyPath isEqualToString:@"contentOffset"]) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    UITableView *tableView = (UITableView *)object;
    CGFloat tableViewoffsetY = tableView.contentOffset.y;
    
    UIColor * color = [UIColor whiteColor];
    CGFloat alpha = MIN(1, tableViewoffsetY/136);
    
    self.backgroundColor = [color colorWithAlphaComponent:alpha];
    
    if (tableViewoffsetY < 125){
        
        [UIView animateWithDuration:0.25 animations:^{
            self.searchButton.hidden = NO;
            [self.qrCodeButton setBackgroundImage:[UIImage imageNamed:@"home_email_black"] forState:UIControlStateNormal];
            self.searchBar.frame = CGRectMake(-(self.width-60), 30, self.width-80, 30);
            self.qrCodeButton.alpha = 1-alpha;
            self.searchButton.alpha = 1-alpha;
        }];
    } else if (tableViewoffsetY >= 125){
        
        [UIView animateWithDuration:0.25 animations:^{
            self.searchBar.frame = CGRectMake(20, 30, self.width-80, 30);
            self.searchButton.hidden = YES;
            self.qrCodeButton.alpha = 1;
            [self.qrCodeButton setBackgroundImage:[UIImage imageNamed:@"home_email_red"] forState:UIControlStateNormal];
        }];
    }
}
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(-(self.width - 60), 30, self.width - 80, 30)];
        _searchBar.placeholder = @"淘你想淘";
        _searchBar.layer.cornerRadius = 15;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.delegate = self;
        
        [_searchBar setSearchFieldBackgroundImage:[UIImage imageWithColor:[UIColor clearColor] size:_searchBar.size] forState:UIControlStateNormal];
        [_searchBar setBackgroundImage:[UIImage imageWithColor:[[UIColor grayColor] colorWithAlphaComponent:0.4] size:_searchBar.size] ];
        
        UITextField *seatchField = [_searchBar  valueForKey:@"_searchField"];
        seatchField.textColor = [UIColor whiteColor];
        [seatchField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    }
    return _searchBar;
}

- (UIButton *)searchButton{
    if (!_searchButton) {
        _searchButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 30, 30, 30)];
        [_searchButton setBackgroundImage:[UIImage imageNamed:@"home_search_icon"] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (UIButton *)qrCodeButton{
    if (!_qrCodeButton) {
        _qrCodeButton = [[UIButton alloc]initWithFrame:CGRectMake(self.width - 45, 30, 30, 30)];
        [_qrCodeButton setBackgroundImage:[UIImage imageNamed:@"home_email_black"] forState:UIControlStateNormal];
        [_qrCodeButton addTarget:self action:@selector(qrCodeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qrCodeButton;
}
#pragma mark - UISearchBarDelegate 协议

// UISearchBar得到焦点并开始编辑时，执行该方法
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}

// 取消按钮被按下时，执行的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.searchBar resignFirstResponder];
}

// 键盘中，搜索按钮被按下，执行的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"---%@",searchBar.text);
    [self.searchBar resignFirstResponder];// 放弃第一响应者
}
- (void)searchClick:(UIButton *)btn{
    if (self.searchBtnClick) {
        self.searchBtnClick(btn);
    }
}
- (void)qrCodeClick:(UIButton *)btn{
    if (self.qrCodeBtnClick) {
        self.qrCodeBtnClick(btn);
    }
}
@end
