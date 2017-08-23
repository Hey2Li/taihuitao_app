//
//  NaviView.h
//  taihuitao
//
//  Created by Tebuy on 2017/8/21.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NaviView : UIView
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSMutableArray *tableViews;
@property (nonatomic, copy) void (^searchBtnClick)(UIButton *btn);
@property (nonatomic, copy) void (^qrCodeBtnClick)(UIButton *btn);
@end
