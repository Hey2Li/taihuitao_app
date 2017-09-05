//
//  HomePageTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/5/10.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeModel.h"

@interface HomePageTableViewCell : UITableViewCell
@property (nonatomic, strong) UIImageView *contentImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *hotImageView;
@property (nonatomic, strong) UILabel *hotNumLabel;
@property (nonatomic, strong) HomeModel *model;
@end
