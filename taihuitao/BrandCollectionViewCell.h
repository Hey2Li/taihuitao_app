//
//  BrandCollectionViewCell.h
//  taihuitao
//
//  Created by Tebuy on 2017/10/16.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BrandName.h"
#import "BrandNameModel.h"

@interface BrandCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *brandImageView;
@property (nonatomic, strong) BrandNameModel *hotBrandModel;
@property (nonatomic, strong) BrandName *brandModel;
@end
