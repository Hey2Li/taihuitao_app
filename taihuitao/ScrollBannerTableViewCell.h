//
//  ScrollBannerTableViewCell.h
//  BearUp
//
//  Created by Tebuy on 2017/5/23.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollBannerTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *imageURLStringsGroup;
@property (nonatomic, copy) void (^BannerImageClick)(NSInteger index);
@end
