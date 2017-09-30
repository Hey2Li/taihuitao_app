//
//  ArticleDetailModel.h
//  taihuitao
//
//  Created by Tebuy on 2017/9/29.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleDetailModel : NSObject
@property (nonatomic, strong) NSNumber *brand;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *introduct;
@property (nonatomic, strong) NSNumber *is_show;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, strong) NSNumber *time;
@end
