//
//  HomeTableViewCell.h
//  taihuitao
//
//  Created by Tebuy on 2017/10/10.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeNewsModel.h"

@interface HomeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *authorLabel;
@property (weak, nonatomic) IBOutlet UILabel *readNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeNumLabel;


@property (nonatomic, strong) HomeNewsModel *model;
@end
