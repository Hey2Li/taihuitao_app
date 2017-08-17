//
//  Tool.h
//  BearUp
//
//  Created by Tebuy on 2017/5/9.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tool : NSObject

void SVProgressShow();
void SVProgressShowText(NSString *text);
void SVProgressShowStuteText(NSString *text, BOOL isSucceed);//成功或失败用 0->失败
void SVProgressHiden();

NSAttributedString *returnNumAttr(NSString *str,NSInteger fontSize);
+ (NSDictionary *)MD5Dictionary:(NSMutableDictionary *)dic;
+ (NSString *)MD5:(NSString *)str;
+ (BOOL)judgePhoneNumber:(NSString *)phoneNum;
+ (BOOL)checkPassword:(NSString *) password;
- (UIViewController *)topViewController;
@end
