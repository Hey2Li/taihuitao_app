//
//  Tool.m
//  BearUp
//
//  Created by Tebuy on 2017/5/9.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "Tool.h"
#import <CommonCrypto/CommonDigest.h>

#define iPhone4Height (480.f)
#define iPhone4Width  (320.f)

#define iPhone5Height (568.f)
#define iPhone5Width  (320.f)

#define iPhone6Height (667.f)
#define iPhone6Width  (375.f)

#define iPhone6PlusHeight (736.f)
#define iPhone6PlusWidth  (414.f)


@implementation Tool

+ (CGFloat)layoutForAlliPhoneHeight:(CGFloat)height {
    CGFloat layoutHeight = 0.0f;
    if (UI_IS_IPHONE4) {
        layoutHeight = ( height / iPhone6Height ) * iPhone4Height;
    } else if (UI_IS_IPHONE5) {
        layoutHeight = ( height / iPhone6Height ) * iPhone5Height;
    } else if (UI_IS_IPHONE6) {
        layoutHeight = ( height / iPhone6Height ) * iPhone6Height;
    } else if (UI_IS_IPHONE6PLUS) {
        layoutHeight = ( height / iPhone6Height ) * iPhone6PlusHeight;
    } else {
        layoutHeight = height;
    }
    return layoutHeight;
}

+ (CGFloat)layoutForAlliPhoneWidth:(CGFloat)width {
    CGFloat layoutWidth = 0.0f;
    if (UI_IS_IPHONE4) {
        layoutWidth = ( width / iPhone6Width ) * iPhone4Width;
    } else if (UI_IS_IPHONE5) {
        layoutWidth = ( width / iPhone6Width ) * iPhone5Width;
    } else if (UI_IS_IPHONE6) {
        layoutWidth = ( width / iPhone6Width ) * iPhone6Width;
    } else if (UI_IS_IPHONE6PLUS) {
        layoutWidth = ( width / iPhone6Width ) * iPhone6PlusWidth;
    }
    return layoutWidth;
}

void SVProgressShow(){
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD show];
}
void SVProgressShowText(NSString* text){
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD showWithStatus:text];
}
void SVProgressShowStuteText(NSString* text,BOOL isSucceed){
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeGradient];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setFadeOutAnimationDuration:.2];
    [SVProgressHUD setMinimumDismissTimeInterval:1.5];
    if (isSucceed) {
        [SVProgressHUD showSuccessWithStatus:text];
    }else{
        [SVProgressHUD showErrorWithStatus:text];
    }
}
void SVProgressHiden(){
    [SVProgressHUD dismiss];
}
void SVProgressShowErrorMessage(NSString *text){
    [SVProgressHUD setMinimumDismissTimeInterval:1];
    [SVProgressHUD showErrorWithStatus:text];
}
NSAttributedString *returnNumAttr(NSString *str,NSInteger fontSize){
    NSString *pattern = @"[0-9]{0,}";
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
    [regex enumerateMatchesInString:str options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, str.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (!result) return;
        NSRange range = result.range;
        if (range.location == NSNotFound || range.length < 1) return;
        NSRange bindlingRange = NSMakeRange(range.location, range.length);
        [attrStr addAttribute:NSForegroundColorAttributeName value:SUBJECT_COLOR range:bindlingRange];
        [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:fontSize] range:bindlingRange];
        
    }];
    return attrStr;
}
+ (NSDictionary *)MD5Dictionary:(NSMutableDictionary *)dic{
    NSDate *date =[NSDate date];
    NSDateFormatter  *dateformatter = [[NSDateFormatter alloc] init];
    //设置获取时间的格式
    [dateformatter setDateFormat:@"yyyyMMddHHmmss"];
    NSString *dateString =[dateformatter stringFromDate:date];
    NSDictionary *dics = @{
                          @"app_key":@"201706",
                          @"sign_method":@"md5",
                          @"timestamp":dateString
                          };
    [dic addEntriesFromDictionary:dics];
    //排序
    NSArray *keyArray = [dic allKeys];
    NSArray *sortArray = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    NSMutableArray *valueArray = [NSMutableArray array];
    for (NSString *sortString in sortArray) {
        [valueArray addObject:[dic objectForKey:sortString]];
    }
    NSMutableArray *signArray = [NSMutableArray array];
    for (int i = 0; i < sortArray.count; i++) {
        NSString *keyValueStr = [NSString stringWithFormat:@"%@%@",sortArray[i],valueArray[i]];
        [signArray addObject:keyValueStr];
    }
    NSString *dicStr = [signArray componentsJoinedByString:@""];
    NSString *signStr = [NSString stringWithFormat:@"qLOWUGCzyn9vx6y8DSxEfgnPoheEDdGZ%@qLOWUGCzyn9vx6y8DSxEfgnPoheEDdGZ",dicStr];
    NSString *md5Str = [self MD5:signStr].uppercaseString;
    NSDictionary *params = @{@"app_key":@"201706",
                             @"sign":md5Str,
                             @"timestamp":dateString,
                             @"sign_method":@"md5"};
    NSLog(@"signStr=%@,\nMD5=%@\n",signStr,md5Str);
    return params;
}
+ (NSString *)MD5:(NSString *)str{
    //要进行UTF8的转码
    const char* input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    return digest;
}

+ (BOOL)judgePhoneNumber:(NSString *)phoneNum
{
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    
    // 一个判断是否是手机号码的正则表达式
    NSString *pattern = [NSString stringWithFormat:@"(%@)|(%@)|(%@)",CM_NUM,CU_NUM,CT_NUM];
    
    NSRegularExpression *regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSString *mobile = [phoneNum stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11) {
        NO;
    }
    
    // 无符号整型数据接收匹配的数据的数目
    NSUInteger numbersOfMatch = [regularExpression numberOfMatchesInString:mobile options:NSMatchingReportProgress range:NSMakeRange(0, mobile.length)];
    if (numbersOfMatch>0) return YES;
    
    return NO;
    
}

+ (BOOL)checkPassword:(NSString *) password{
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:password];
    return isMatch;
    
}

- (UIViewController*)topViewController
{
    return [self topViewControllerWithRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}
@end
