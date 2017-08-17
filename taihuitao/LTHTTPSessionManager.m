//
//  LTHTTPSessionManager.m
//  TwMall
//
//  Created by TaiHuiTao on 16/6/15.
//  Copyright © 2016年 TaiHuiTao. All rights reserved.
//

#import "LTHTTPSessionManager.h"

//解析数据返回错误
NSString *const kParseResponseError = @"解析数据失败";
NSString *const kHttpRequestFailure = @"网络连接错误";
//返回参数key值
NSString *const kKeyResult = @"errorCode";
NSString *const kKeyMessage = @"errorMsg";
NSString *const kKeyData = @"data";
NSString *const kKeyModelList = @"modellist";

@implementation LTHTTPSessionManager

- (instancetype)init{
    if (self = [super init]) {
        //将本地cookie放在网络请求header
        NSArray * cookies = [NSKeyedUnarchiver unarchiveObjectWithData: [[NSUserDefaults standardUserDefaults] objectForKey:@"kcookie"]];
        NSHTTPCookieStorage * cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        for (NSHTTPCookie * cookie in cookies){
            [cookieStorage setCookie: cookie];
        }
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",nil];
    }
    return self;
}
+ (instancetype)manager{
    return [[self alloc]init];
}
- (NSURLSessionDataTask *)POSTWithParameters:(NSString *)url parameters:(id)parameters complete:(completeBlock)complete{
    // 在此 添加网络加载动画
    SVProgressShowText(@"正在加载...");
    return [super POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SVProgressHiden();
        NSLog(@"成功");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"responseObject:%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else if(![responseObject[kKeyResult] isEqualToString:@"0000"]){
            complete(LTHttpResultFailure, responseObject[kKeyMessage], nil);
            //添加SV错误提示
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:responseObject[kKeyMessage]];
        }else{
            complete(LTHttpResultSuccess, responseObject[kKeyMessage], responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
        NSLog(@"失败");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"error:%@",error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
            SVProgressShowStuteText(kParseResponseError, NO);
        }else{
            complete(LTHttpResultFailure, kHttpRequestFailure, nil);
            SVProgressShowStuteText(kHttpRequestFailure, NO);
        }
    }];
}

- (NSURLSessionDataTask *)GETWithParameters:(NSString *)url parameters:(id)parameters complete:(completeBlock)complete{
    return [super GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"responseObject:%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else if([responseObject[kKeyResult] isEqualToString:@"ERROR"]){
            complete(LTHttpResultFailure, responseObject[kKeyMessage], nil);
        }else{
            complete(LTHttpResultSuccess, responseObject[kKeyMessage], responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"error:%@",error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else{
            complete(LTHttpResultFailure, kHttpRequestFailure, nil);
        }
    }];
}


- (NSURLSessionDataTask *)PUTWithParameters:(NSString *)url parameters:(id)parameters complete:(completeBlock)complete{
    return [super PUT:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"responseObject:%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else if([responseObject[kKeyResult] isEqualToString:@"ERROR"]){
            complete(LTHttpResultFailure, responseObject[kKeyMessage], nil);
        }else{
            complete(LTHttpResultSuccess, responseObject[kKeyMessage], responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"error:%@",error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else{
            complete(LTHttpResultFailure, kHttpRequestFailure, nil);
        }
    }];
}


- (NSURLSessionDataTask *)DELTEWithParameters:(NSString *)url parameters:(id)parameters complete:(completeBlock)complete{
    return [super DELETE:url parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"成功");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"responseObject:%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else if([responseObject[kKeyResult] isEqualToString:@"ERROR"]){
            complete(LTHttpResultFailure, responseObject[kKeyMessage], nil);
        }else{
            complete(LTHttpResultSuccess, responseObject[kKeyMessage], responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"error:%@",error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else{
            complete(LTHttpResultFailure, kHttpRequestFailure, nil);
        }
    }];
}
- (NSURLSessionDataTask *)UPLOADWithParameters:(NSString *)url parameters:(id)parameters photoArray:(NSArray *)photoArray complete:(completeBlock)complete{
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"multipart/form-data", @"application/json", @"text/html", @"image/jpeg", @"image/png", @"application/octet-stream", @"text/json", nil];
    // 在此 添加网络加载动画
    SVProgressShowText(@"正在加载...");
    return [super POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < photoArray.count; i++) {
            
            UIImage *image = photoArray[i];
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            [formatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *dateString = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString  stringWithFormat:@"%@.jpg", dateString];
            /*
             *该方法的参数
             1. appendPartWithFileData：要上传的照片[二进制流]
             2. name：对应网站上[upload.php中]处理文件的字段（比如upload）
             3. fileName：要保存在服务器上的文件名
             4. mimeType：上传的文件的类型
             */
            [formData appendPartWithFileData:imageData name:@"photo" fileName:fileName mimeType:@"image/jpeg"]; //
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        SVProgressHiden();
        NSLog(@"成功");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"responseObject:%@",responseObject);
        if (![responseObject isKindOfClass:[NSDictionary class]]) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
        }else if(![responseObject[kKeyResult] isEqualToString:@"0000"]){
            complete(LTHttpResultFailure, responseObject[kKeyMessage], nil);
            //添加SV错误提示
            [SVProgressHUD setMinimumDismissTimeInterval:1];
            [SVProgressHUD showErrorWithStatus:responseObject[kKeyMessage]];
        }else{
            complete(LTHttpResultSuccess, responseObject[kKeyMessage], responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败");
        NSLog(@"url:%@",url);
        NSLog(@"parameters:%@",parameters);
        NSLog(@"error:%@",error);
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        if (response.statusCode == 200) {
            complete(LTHttpResultFailure, kParseResponseError, nil);
            SVProgressShowStuteText(kParseResponseError, NO);
        }else{
            complete(LTHttpResultFailure, kHttpRequestFailure, nil);
            SVProgressShowStuteText(kHttpRequestFailure, NO);
        }
    }];
}
@end
