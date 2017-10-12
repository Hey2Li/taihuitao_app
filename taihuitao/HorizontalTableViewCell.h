//
//  HorizontalTableViewCell.h
//  taihuitao
//
//  Created by Tebuy on 2017/8/31.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorizontalTableViewCell : UITableViewCell
@property (nonatomic, strong) NSArray *modelArray;
@property (nonatomic, copy) void (^HorCollectionCellClick)(NSIndexPath *);
@end
