//
//  FSBaseTopTableViewCell.h
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSBaseTopTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, copy) void (^cycleScrollClick)(NSInteger);
@end
