//
//  RecommedCellModel.h
//  taihuitao
//
//  Created by Tebuy on 2017/10/3.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommedCellModel : NSObject
@property (nonatomic, strong) NSNumber *cid;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *type;
@end
