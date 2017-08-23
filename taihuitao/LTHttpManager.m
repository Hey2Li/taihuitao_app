//
//  LTHttpManager.m
//  TwMall
//
//  Created by TaiHuiTao on 16/6/15.
//  Copyright © 2016年 TaiHuiTao. All rights reserved.
//

#import "LTHttpManager.h"
#import <MJExtension.h>
#import "LoginViewController.h"

@implementation LTHttpManager

/**
 注册帐号
 请求地址:api/register/index
 请求方式:POST
 
 @param mobile 手机号码
 @param password 密码
 @param complete block回调
 */

+ (void)registerWithMobile:(NSString *)mobile andPassword:(NSString *)password andUUID:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",password,@"password",user_uuid,@"user_uuid", nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/register/index",BaseURL] parameters:paramters complete:complete];
}

/**
 发送验证码
 请求地址:api/register/sendmsg
 
 @param mobile 手机号码
 @param complete block
 */
+ (void)registerSendCodeWithMobile:(NSString *)mobile Type:(NSNumber *)type Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",
                                      type,@"type",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/register/sendmsg",BaseURL] parameters:paramters complete:complete];

}

/**
 帐号登录
 请求地址:api/login/index
 请求方式:POST
 
 @param mobile 手机号码
 @param password  密码
 @param complete  block回调
 */
+ (void)loginWithMobile:(NSString *)mobile andPassword:(NSString *) password andUUID:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",password,@"password",user_uuid,@"user_uuid",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/login/index",BaseURL] parameters:paramters complete:complete];
}

/**
 提交新密码
 请求地址:api/register/checkcode
 
 @param mobile 手机号码
 @param code 验证码
 @param password 密码
 */
+ (void)submitNewPasswordWithMobile:(NSString *)mobile Code:(NSString *)code Password:(NSString *)password Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",
                                     code,@"code",
                                     password,@"password",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/register/checkcode",BaseURL] parameters:paramters complete:complete];
}


/**
 请求地址:api/index
 请求方式:POST
 功能描述：首页头部栏目
 
 @param limit 查询数量 要返回几个栏目
 @param cid 分类ID
 @param page 数据分页
 @param nlimit 推荐内容查询数量 初始显示数量
 @param complete block
 */
+ (void)homeTitleWithLimit:(NSNumber *)limit Cid:(NSNumber *)cid Page:(NSString *)page Nlimit:(NSString *)nlimit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit", cid,@"cid",page,@"page", nlimit,@"nlimit",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/index",BaseURL] parameters:paramters complete:complete];
}


/**
 请求地址:api/news/index
 请求方式:POST
 功能描述：获得文章列表
 
 
 @param limit 要返回几个栏目
 @param cid 分类ID
 @param complete block
 */
+ (void)newsListWithLimit:(NSNumber *)limit Cid:(NSNumber *)cid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit",
                                      cid,@"cid",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/index",BaseURL] parameters:paramters complete:complete];
}

/**
 下滑获取下一页数据
 请求地址:api/index/nextpage
 请求方式:POST
 
 
 @param page 数据分页
 @param limit 查询文章数量
 @param complete block
 */
+ (void)newListNextPageWithPage:(NSNumber *)page Limit:(NSNumber *)limit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:page,@"page",
                                      limit,@"limit",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/index/nextpage",BaseURL] parameters:paramters complete:complete];

}

/**
 首页推荐滑动获取更多：api/index/getmore
 
 @param page 数据分页
 @param limit 查询文章数量
 @param complete block
 */
+ (void)recommendGetMoreWithPage:(NSNumber *)page Limit:(NSNumber *)limit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:page,@"page",
                                      limit,@"limit",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/index/getmore",BaseURL] parameters:paramters complete:complete];

}

/**
 请求地址:api/news/show
 请求方式:POST
 功能描述：获得文章内容、评论
 
 
 @param ID 文章id
 @param value 查询字段
 @param complete block
 */
+ (void)newsDetailWithId:(NSNumber *)ID Value:(NSString *)value Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    if (![USER_ID isEqual:[NSNull null]]) {
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                          value,@"value",
                                          USER_ID,@"user_id",
                                          GETUUID,@"user_uuid",
                                          USER_TOKEN,@"user_token",
                                          nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/show",BaseURL] parameters:paramters complete:complete];

    }else{
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                          value,@"value",
                                          nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/show",BaseURL] parameters:paramters complete:complete];

    }
}


/**
 请求地址:api/news/savecomment
 请求方式:POST
 
 @param ID 文章id
 @param content 评论内容
 @param complete block
 */
+ (void)commentNewsWithId:(NSNumber *)ID Content:(NSString *)content Complete:(completeBlock)complete{
    if (USER_ID) {
        LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                          content,@"content",
                                          USER_ID,@"user_id",
                                          USER_TOKEN,@"user_token",
                                          GETUUID,@"user_uuid",
                                          nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/savecomment",BaseURL] parameters:paramters complete:complete];
    }else{
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BearUp" bundle:nil];
        LoginViewController *lvc = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:lvc];
        [[[Tool alloc]topViewController] presentViewController:navi animated:YES completion:nil];
    }
}


/**
 请求地址:api/video/index
 请求方式:POST
 功能描述：获得视频列表
 
 
 @param limit 查询数量
 @param cid 分类ID
 @param complete complete
 */
+ (void)videoListWithLimit:(NSNumber *)limit Cid:(NSNumber *)cid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
     if (USER_ID) {
         NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit",
                                           cid,@"cid",
                                           GETUUID,@"user_uuid",
                                           USER_ID,@"user_id",
                                           USER_TOKEN,@"user_token",
                                           nil];
         [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
         [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/index",BaseURL] parameters:paramters complete:complete];

     }else{
         NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit",
                                           cid,@"cid",
                                           nil];
         [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
         [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/index",BaseURL] parameters:paramters complete:complete];

     }
}


/**
 请求地址:api/video/show
 请求方式:POST
 功能描述：获得视频内容、评论
 
 
 @param ID 文章id
 @param complete block
 */
+ (void)videoDetailWithId:(NSNumber *)ID Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
  
    if (![USER_ID isEqual:[NSNull null]]) {
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                          USER_ID,@"user_id",
                                          GETUUID,@"user_uuid",
                                        USER_TOKEN,@"user_token",
                                          nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/show",BaseURL] parameters:paramters complete:complete];
        
    }else{
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                          nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/show",BaseURL] parameters:paramters complete:complete];
        
    }
}


/**
 请求地址:api/news/savecomment
 请求方式:POST
 
 
 @param ID 文章id
 @param content 评论内容
 @param complete block
 */
/*
+ (void)commentViewWithId:(NSNumber *)ID Content:(NSString *)content Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                      content,@"content",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/savecomment",BaseURL] parameters:paramters complete:complete];
}
*/

/**
 个人中心主页
 请求地址:api/user/index
 请求方式:POST
 
 
 @param complete block
 */
+ (void)userInfoComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionary];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/index",BaseURL] parameters:paramters complete:complete];
}


/**
 系统消息
 请求地址:api/user/syslist
 请求方式:POST
 功能描述：系统消息列表
 
 
 @param limit 查询数量
 @param complete block
 */
+ (void)sysMessageListWithLimit:(NSNumber *)limit User_uuid:(NSString *)user_uuid User_id:(NSString *)user_id User_token:(NSString *)user_token Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit",user_uuid,@"user_uuid",user_id,@"user_id",user_token,@"user_token"
                                      ,                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/syslist",BaseURL] parameters:paramters complete:complete];
}


/**
 系统消息详情
 请求地址:api/user/sysinfo
 请求方式:POST
 
 
 @param ID 消息id
 @param complete block
 */
+ (void)sysMessageInfoWithId:(NSNumber *)ID User_uuid:(NSString *)user_uuid User_id:(NSString *)user_id User_token:(NSString *)user_token  Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",user_uuid,@"user_uuid",user_id,@"user_id",user_token,@"user_token",                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/sysinfo",BaseURL] parameters:paramters complete:complete];
}


/**
 保存用户意见
 请求地址:api/user/saveopinion
 请求方式:POST
 
 
 @param mobile 手机号
 @param content 建议内容
 @param complete block
 */
+ (void)saveUserOpinionWithMobile:(NSNumber *)mobile Content:(NSString *)content Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:mobile,@"mobile",
                                      content,@"content",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/saveopinion",BaseURL] parameters:paramters complete:complete];
}


/**
 用户订阅管理
 请求地址:api/user/myatten
 请求方式:POST
 
 
 @param complete block
 */
+ (void)userSubscripWithUser_uuid:(NSString *)user_uuid User_id:(NSString *)user_id User_token:(NSString *)user_token Complete:(completeBlock)complete{    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:user_uuid,@"user_uuid",user_id,@"user_id",user_token,@"user_token"
,                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/myatten",BaseURL] parameters:paramters complete:complete];
}



/**
 商品列表
 请求地址:api/user/commodity
 请求方式:POST
 
 
 @param complete block
 */
+ (void)userCommodityComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionary];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/commodity",BaseURL] parameters:paramters complete:complete];
}


/**
 商品详情
 请求地址:api/user/comminfo
 请求方式:POST
 
 
 @param ID 商品id
 @param complete block
 */
+ (void)usercommInfoWithId:(NSNumber *)ID Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/comminfo",BaseURL] parameters:paramters complete:complete];
}


/**
 换商品
 请求地址:api/user/buycommodity
 请求方式:POST
 
 
 @param ID 商品id
 @param num 兑换数量
 @param recipient 收件人
 @param mobile 收件人电话
 @param city 省市
 @param address 详细地址
 @param complete block
 */
+ (void)buyCommodityWithId:(NSNumber *)ID Num:(NSNumber *)num Recipient:(NSString *)recipient Mobile:(NSNumber *)mobile City:(NSString *)city Address:(NSString *)address Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id",
                                      num,@"num",
                                      recipient,@"recipient",
                                      mobile,@"mobile",
                                      city,@"city",
                                      address,@"address",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/buycommodity",BaseURL] parameters:paramters complete:complete];
}


/**
 获得评论
 请求地址:api/user/getcmment
 请求方式:POST
 
 
 @param type 类型
 @param page 页数
 @param complete block
 */
+ (void)getCommentWithType:(NSNumber *)type Page:(NSNumber *)page Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:type,@"type",
                                     page,@"page",
                                      nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/getcmment",BaseURL] parameters:paramters complete:complete];

}

/**
 发现首页api/explore/index
 
 @param complete block
 */
+ (void)foundIndexComplete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionary];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/index",BaseURL] parameters:paramters complete:complete];
}

/**
 排行榜
 请求地址:api/explore/toplist
 
 @param type 0-总榜；1-文章榜；2-视频榜
 @param limit 每次查询的排行数量
 @param complete block
 */
+ (void)topListWithType:(NSString *)type Limit:(NSNumber *)limit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:type,@"type", limit,@"limit",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/toplist",BaseURL] parameters:paramters complete:complete];
}

/**
 热门分类
 请求地址:api/explore/hotcolumn
 
 
 @param limit 每次查询的排行数量
 @param complete block
 */
+ (void)hotCategoryWithLimit:(NSNumber *)limit Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    if (USER_ID) {
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",USER_ID,@"user_id",USER_TOKEN,@"user_token",GETUUID,@"user_uuid",nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/hotcolumn",BaseURL] parameters:paramters complete:complete];
    }else{
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/hotcolumn",BaseURL] parameters:paramters complete:complete];
    }

}


/**
 分类详情
 请求地址:api/explore/getcolumn
 
 @param limit 每次查询的排行数量
 @param ID 分类id
 @param complete block
 */
+ (void)categoryDetailWithLimit:(NSNumber *)limit ID:(NSNumber *)ID Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    if (USER_ID) {
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",ID,@"id",USER_ID,@"user_id",USER_TOKEN,@"user_token",GETUUID,@"user_uuid",nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/getcolumn",BaseURL] parameters:paramters complete:complete];
    }else{
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",ID,@"id",nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/getcolumn",BaseURL] parameters:paramters complete:complete];
    }
}


/**
 关注类别
 请求地址:api/explore/attention
 
 @param cid 分类id
 @param complete block
 */
+ (void)focusCategoryWithCid:(NSNumber *)cid Complete:(completeBlock)complete{
    if (USER_ID) {
        LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: cid,@"cid",USER_ID,@"user_id",USER_TOKEN,@"user_token",GETUUID,@"user_uuid",nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/attention",BaseURL] parameters:paramters complete:complete];
    }else{
         UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BearUp" bundle:nil];
        LoginViewController *lvc = [storyBoard instantiateViewControllerWithIdentifier:@"loginViewController"];
        UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:lvc];
        [[[Tool alloc]topViewController] presentViewController:navi animated:YES completion:nil];
    }
}

/**
 详情页评论分页
 请求地址:api/news/getMore
 功能描述：获得文章更多评论
 
 
 @param ID 文章id
 @param page 分页 初始值为2
 @param complete complete
 */
+ (void)getMoreNewsCommentWithID:(NSNumber *)ID Page:(NSNumber *)page Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: ID,@"id",page,@"page",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/getMore",BaseURL] parameters:paramters complete:complete];

}


/**
 获得更多文章
 请求地址:api/news/getnews
 功能描述：获得更多文章
 
 
 @param limit 查询数量
 @param page 分页
 @param cid 文章类别
 @param complete block
 */
+ (void)getMoreNewsWithLimit:(NSNumber *)limit Page:(NSNumber *)page Cid:(NSNumber *)cid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",page,@"page",cid,@"cid",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/getnews",BaseURL] parameters:paramters complete:complete];

}


/**
 详情页评论分页
 请求地址:api/video/getMore
 功能描述：获得视频更多评论
 
 
 @param ID 视频id
 @param page 分页 初始值为2
 @param complete blcok
 */
+ (void)getMoreVideoCommentWithId:(NSNumber *) ID Page:(NSNumber *)page Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: ID,@"id",page,@"page",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/getMore",BaseURL] parameters:paramters complete:complete];
}


/**
 获得更多视频
 请求地址:api/video/getvideo
 功能描述：获得更多视频
 
 
 @param limit 查询数量
 @param page 分页
 @param cid 视频类别
 @param complete block
 */
+ (void)getMoreVideoWithLimit:(NSNumber *)limit Page:(NSNumber *)page Cid:(NSNumber *)cid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    if (USER_ID) {
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit",page,@"page",cid,@"cid",
                                          GETUUID,@"user_uuid",
                                          USER_ID,@"user_id",
                                        USER_TOKEN,@"user_token",
                                          nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/getvideo",BaseURL] parameters:paramters complete:complete];
        
    }else{
        NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit",page,@"page",cid,@"cid",
                                          nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/getvideo",BaseURL] parameters:paramters complete:complete];
        
    }

}
/**
 收藏文章请求地址：api/news/collecnews
 
 @param ID 文章ID
 @param user_uuid UUID
 @param user_id 用户ID
 @param user_token token
 */
+ (void)collectionNewsWithNewID:(NSNumber *)ID UUID:(NSString *)user_uuid User_id:(NSNumber *)user_id Token:(NSString *)user_token Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: ID,@"id",user_uuid,@"user_uuid",user_id,@"user_id",user_token,@"user_token",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/collecnews",BaseURL] parameters:paramters complete:complete];
}


/**
 收藏视频请求地址：api/video/collecvideo
 @param ID 视频ID
 @param user_uuid UUID
 @param user_id 用户ID
 @param user_token token
 */
+ (void)collectionVideoWithNewID:(NSNumber *)ID UUID:(NSString *)user_uuid User_id:(NSNumber *)user_id Token:(NSString *)user_token Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: ID,@"id",user_uuid,@"user_uuid",user_id,@"user_id",user_token,@"user_token",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/collecvideo",BaseURL] parameters:paramters complete:complete];
}


/**
 第三方登录
 api/register/thirdparty
 
 @param user_uuid UUID
 @param openid openID
 @param name name
 @param gender gender
 @param type 登录来源 2微信3QQ4新浪
 @param complete block
 */
+ (void)thirdLoginReturnWithUUID:(NSString *)user_uuid OpenId:(NSString *)openid Name:(NSString *)name Gender:(NSString *)gender Icon:(NSString *)iconurl Type:(NSNumber *)type Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: gender,@"gender",user_uuid,@"user_uuid",openid,@"openid",name,@"name",iconurl,@"iconurl",type,@"type",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/register/thirdparty",BaseURL] parameters:paramters complete:complete];
}

/**
 分享文章返回 api/news/share
 
 @param Id 文章ID
 @param user_uuid UUID
 @param user_id 用户ID
 @param user_token token
 */
+ (void)shareNewsWithId:(NSNumber *)Id UUID:(NSString *)user_uuid User_id:(NSNumber *)user_id Token:(NSString *)user_token Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: user_uuid,@"user_uuid",Id,@"id",user_id,@"user_id",user_token,@"user_token",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/share",BaseURL] parameters:paramters complete:complete];
}

/**
 分享文章返回 api/video/share
 
 @param Id 文章ID
 @param user_uuid UUID
 @param user_id 用户ID
 @param user_token token
 */
+ (void)shareVideoWithId:(NSNumber *)Id UUID:(NSString *)user_uuid User_id:(NSNumber *)user_id Token:(NSString *)user_token Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: user_uuid,@"user_uuid",Id,@"id",user_id,@"user_id",user_token,@"user_token",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/share",BaseURL] parameters:paramters complete:complete];
}

/**
 我的动态
 请求地址:api/user/mynotices
 
 @param limit 每页数量
 @param user_token Token
 @param user_id 会员id
 @param user_uuid 设备号
 @param complete blcok
 */
+ (void)myStateWithLimit:(NSNumber *)limit Token:(NSString *)user_token User_id:(NSString *)user_id User_uuid:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",user_uuid,@"user_uuid",user_id,@"user_id",user_token,@"user_token",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/mynotices",BaseURL] parameters:paramters complete:complete];
}


/**
 更多动态
 请求地址:api/user/morenotices
 
 @param limit 每页数量
 @param page 所属分页 初始数字2
 @param user_token Token
 @param user_id 会员id
 @param user_uuid 设备号
 @param complete block
 */
+ (void)myStateMoreWithLimit:(NSNumber *)limit Page:(NSNumber *)page Token:(NSString *)user_token User_id:(NSString *)user_id User_uuid:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",page,@"page",user_uuid,@"user_uuid",user_id,@"user_id",user_token,@"user_token",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/morenotices",BaseURL] parameters:paramters complete:complete];
}


/**
 我的收藏
 请求地址:api/user/mycollecs
 
 @param limit 每页数量
 @param user_token Token
 @param user_id 会员id
 @param user_uuid 设备号
 @param complete block
 */
+ (void)myCollectionsWithLimit:(NSNumber *)limit User_token:(NSString *)user_token User_id:(NSNumber *)user_id User_uuid:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",user_uuid,@"user_uuid",user_id,@"user_id",user_token,@"user_token",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/mycollecs",BaseURL] parameters:paramters complete:complete];
}


/**
 更多收藏
 请求地址:api/user/morecollecs
 
 @param limit 每页数量
 @param page 所属分页
 @param user_token Token
 @param user_id 会员id
 @param user_uuid 设备号
 @param complete block
 */
+ (void)myCollectionsMoreWithLimit:(NSNumber *)limit Page:(NSNumber *)page User_token:(NSString *)user_token User_id:(NSNumber *)user_id User_uuid:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters  =[NSMutableDictionary dictionaryWithObjectsAndKeys: limit,@"limit",page,@"page",user_uuid,@"user_uuid",user_id,@"user_id",user_token,@"user_token",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/morecollecs",BaseURL] parameters:paramters complete:complete];
}
/**
 保存个人信息
 请求地址:api/user/saveinfo
 
 @param sex 性别
 @param nickname 昵称
 @param user_token token
 @param user_id ID
 @param user_uuid UUID
 */
+ (void)saveUserInfoWithSex:(NSNumber *)sex Nickname:(NSString *)nickname User_token:(NSString *)user_token User_id:(NSString *)user_id User_uuid:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys: sex,@"sex",nickname,@"nickname",user_token,@"user_token",user_id,@"user_id",user_uuid,@"user_uuid",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/saveinfo",BaseURL] parameters:paramters complete:complete];
}

/**
 保存头像
 
 @param user_token user_token
 @param user_id id
 @param user_uuid uuid
 @param complete block
 */
+ (void)uploadPhotoWithPhotoArray:(NSArray *)array User_token:(NSString *)user_token User_id:(NSString *)user_id User_uuid:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys: user_token,@"user_token",user_id,@"user_id",user_uuid,@"user_uuid",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager UPLOADWithParameters:[NSString stringWithFormat:@"%@api/user/savephoto",BaseURL] parameters:paramters photoArray:array complete:complete];
}

/**
 我的消息 api/user/mymsgs
 
 @param limit 每页数量
 @param user_token token
 @param user_id ID
 @param user_uuid UUID
 @param complete block
 */
+ (void)myMessageWithLimit:(NSNumber *)limit User_token:(NSString *)user_token User_id:(NSString *)user_id User_uuid:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:limit,@"limit", user_token,@"user_token",user_id,@"user_id",user_uuid,@"user_uuid",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/mymsgs",BaseURL] parameters:paramters complete:complete];
}

/**
 我的消息 api/user/moremsgs
 
 @param page 所属分页 初始2
 @param limit 每页数量
 @param user_token token
 @param user_id ID
 @param user_uuid UUID
 @param complete block
 */
+ (void)myMoreMessageWithPage:(NSNumber *)page Limit:(NSNumber *)limit User_token:(NSString *)user_token User_id:(NSString *)user_id User_uuid:(NSString *)user_uuid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:page,@"page",limit,@"limit", user_token,@"user_token",user_id,@"user_id",user_uuid,@"user_uuid",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/user/moremsgs",BaseURL] parameters:paramters complete:complete];
}

/**
 发现首页广告api/explore/index
 
 @param aid 广告ID
 @param complete block
 */
+ (void)foundIndexADWithAid:(NSNumber *)aid Complete:(completeBlock)complete{
    LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
    
    NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:aid,@"aid",nil];
    [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
    [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/explore/index",BaseURL] parameters:paramters complete:complete];
}

/**
 点赞文章
 
 @param ID 文章ID
 @param user_uuid UUID
 @param user_id ID
 @param user_token token
 @param complete block
 */
+ (void)agreeNewsWithId:(NSNumber *)ID User_uuid:(NSString *)user_uuid User_id:(NSString *)user_id User_token:(NSString *)user_token Complete:(completeBlock)complete{
    if (USER_ID) {
        LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
        NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id", user_token,@"user_token",user_id,@"user_id",user_uuid,@"user_uuid",nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/new/agreenews",BaseURL] parameters:paramters complete:complete];
    }else{
        SVProgressShowStuteText(@"需要登录才能点赞哦~", NO);
    }
}


/**
 点赞视频
 
 @param ID 视频ID
 @param user_uuid UUDi
 @param user_id ID
 @param user_token token
 @param complete block
 */
+ (void)agreeVideosWithId:(NSNumber *)ID User_uuid:(NSString *)user_uuid User_id:(NSString *)user_id User_token:(NSString *)user_token Complete:(completeBlock)complete{
    if (USER_ID) {
        LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
        NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id", user_token,@"user_token",user_id,@"user_id",user_uuid,@"user_uuid",nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/agreevideo",BaseURL] parameters:paramters complete:complete];
    }else{
        SVProgressShowStuteText(@"需要登录才能点赞哦~", NO);
    }
}

/**
 点赞视频评论api/video/agreeconment
 
 @param ID 评论ID
 @param user_uuid UUID
 @param user_id ID
 @param user_token token
 @param complete block
 */
+ (void)agreeVideoCommentWithId:(NSNumber *)ID User_uuid:(NSString *)user_uuid User_id:(NSString *)user_id User_token:(NSString *)user_token Complete:(completeBlock)complete{
    if (USER_ID) {
        LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
        NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id", user_token,@"user_token",user_id,@"user_id",user_uuid,@"user_uuid",nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/video/agreeconment",BaseURL] parameters:paramters complete:complete];
    }else{
        SVProgressShowStuteText(@"需要登录才能点赞哦~", NO);
    }
}

/**
 点赞文章评论api/news/agreeconment
 
 @param ID 评论ID
 @param user_uuid UUID
 @param user_id ID
 @param user_token token
 @param complete block
 */
+ (void)agreeNewCommentWithId:(NSNumber *)ID User_uuid:(NSString *)user_uuid User_id:(NSString *)user_id User_token:(NSString *)user_token Complete:(completeBlock)complete{
    if (USER_ID) {
        LTHTTPSessionManager *manager = [LTHTTPSessionManager new];
        NSMutableDictionary *paramters = [NSMutableDictionary dictionaryWithObjectsAndKeys:ID,@"id", user_token,@"user_token",user_id,@"user_id",user_uuid,@"user_uuid",nil];
        [paramters addEntriesFromDictionary:[Tool MD5Dictionary:paramters]];
        [manager POSTWithParameters:[NSString stringWithFormat:@"%@api/news/agreeconment",BaseURL] parameters:paramters complete:complete];
    }else{
        SVProgressShowStuteText(@"需要登录才能点赞哦~", NO);
    }
}
@end
