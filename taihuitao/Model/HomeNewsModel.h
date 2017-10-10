//
//  HomeNewsModel.h
//  taihuitao
//
//  Created by Tebuy on 2017/10/10.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeNewsModel : NSObject
@property (nonatomic, strong) NSNumber *cid;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *photo;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *type;
@property (nonatomic, copy) NSString *author;
@property (nonatomic, strong) NSNumber *collection;
@property (nonatomic, strong) NSNumber *hits;
@property (nonatomic, copy) NSString *time;
@end
