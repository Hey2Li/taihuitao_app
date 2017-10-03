//
//  GoodsDetailsTableViewCell.h
//  taihuitao
//
//  Created by Tebuy on 2017/8/24.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsBkImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *readNumLabel;
@property (nonatomic, strong) NSDictionary *dataDic;
@end
