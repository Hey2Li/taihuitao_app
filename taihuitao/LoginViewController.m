//
//  LoginViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/9.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "LoginViewController.h"
#import "HomeViewController.h"
#import "BaseTabBarViewController.h"
#import <UMSocialCore/UMSocialCore.h>
#import "RegisterViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>
@property (strong, nonatomic) UITextField *userNameTF;
@property (strong, nonatomic) UITextField *passwordTF;
@property (strong, nonatomic) UIImageView *headerImageView;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    self.title = @"";
    self.view.backgroundColor = [UIColor whiteColor];;
}
- (void)initWithView{
    UIImageView *topImageView = [UIImageView new];
    topImageView.image = [UIImage imageNamed:@"登录上部分背景"];
    [self.view addSubview:topImageView];
    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@((SCREEN_HEIGHT/3) - 40));
    }];
    
    UIImageView *headerView = [UIImageView new];
    [headerView.layer setCornerRadius:50];
    [headerView.layer setMasksToBounds:YES];
    headerView.image = [UIImage imageNamed:@"用户默认头像"];
    [topImageView addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@100);
        make.centerX.equalTo(topImageView.mas_centerX);
        make.centerY.equalTo(topImageView.mas_centerY).offset(20);
    }];
    
    UILabel *line1 = [UILabel new];
    line1.backgroundColor = UIColorFromRGB(0xaeaeae);
    [self.view addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.height.equalTo(@1);
        make.top.equalTo(topImageView.mas_bottom).offset(70);
    }];
    
    UIImageView *userImageView = [UIImageView new];
    userImageView.image = [UIImage imageNamed:@"输入手机号"];
    [self.view addSubview:userImageView];
    [userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line1.mas_left).offset(5);
        make.height.equalTo(@18);
        make.width.equalTo(@18);
        make.bottom.equalTo(line1.mas_top).offset(-5);
    }];
    
    UITextField *userNameTF = [UITextField new];
    userNameTF.placeholder = @"请输入您的手机号";
    userNameTF.borderStyle = UITextBorderStyleNone;
    userNameTF.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:userNameTF];
    [userNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userImageView.mas_right).offset(20);
        make.right.equalTo(line1.mas_right).offset(-10);
        make.height.equalTo(@30);
        make.centerY.equalTo(userImageView.mas_centerY);
    }];
    
    UILabel *line2 = [UILabel new];
    line2.backgroundColor = UIColorFromRGB(0xaeaeae);
    [self.view addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line1.mas_left);
        make.right.equalTo(line1.mas_right);
        make.height.equalTo(@1);
        make.top.equalTo(line1.mas_bottom).offset(60);
    }];
    
    UIImageView *passwordImageView = [UIImageView new];
    passwordImageView.image = [UIImage imageNamed:@"输入密码"];
    [self.view addSubview:passwordImageView];
    [passwordImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line2.mas_left).offset(5);
        make.height.equalTo(userImageView.mas_height);
        make.width.equalTo(userImageView.mas_width);
        make.bottom.equalTo(line2.mas_top).offset(-5);
    }];
    
    UITextField *passwordTF = [UITextField new];
    passwordTF.placeholder = @"请输入您的密码";
    passwordTF.borderStyle = UITextBorderStyleNone;
    passwordTF.secureTextEntry = YES;
    [self.view addSubview:passwordTF];
    [passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(passwordImageView.mas_right).offset(20);
        make.right.equalTo(line1.mas_right).offset(-10);
        make.height.equalTo(@30);
        make.centerY.equalTo(passwordImageView.mas_centerY);
    }];
    
    UIButton *forgetPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPasswordBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPasswordBtn setTitleColor:UIColorFromRGB(0xff4466) forState:UIControlStateNormal];
    [forgetPasswordBtn setBackgroundColor:UIColorFromRGB(0xffecef)];
    forgetPasswordBtn.titleLabel.font = [UIFont systemFontOfSize:10];
    [forgetPasswordBtn.layer setCornerRadius:10];
    [forgetPasswordBtn.layer setMasksToBounds:YES];
    [self.view addSubview:forgetPasswordBtn];
    [forgetPasswordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(line2.mas_right);
        make.width.equalTo(@70);
        make.centerY.equalTo(passwordTF.mas_centerY).offset(-2);
        make.height.equalTo(@20);
    }];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:UIColorFromRGB(0xff4466)];
    [loginBtn.layer setCornerRadius:17];
    [loginBtn.layer setMasksToBounds:YES];
    [self.view addSubview:loginBtn];
    [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.equalTo(@34);
        make.width.equalTo(@(SCREEN_WIDTH/3*2 + 20));
        make.top.equalTo(line2.mas_bottom).offset(30);
    }];
    
    UIButton *registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [registerBtn setTitleColor:UIColorFromRGB(0xff4466) forState:UIControlStateNormal];
    [registerBtn setBackgroundColor:[UIColor whiteColor]];
    [registerBtn.layer setCornerRadius:17];
    [registerBtn.layer setMasksToBounds:YES];
    [registerBtn.layer setBorderWidth:1];
    [registerBtn.layer setBorderColor:UIColorFromRGB(0xff4466).CGColor];
    [self.view addSubview:registerBtn];
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(loginBtn.mas_centerX);
        make.height.equalTo(loginBtn.mas_height);
        make.width.equalTo(loginBtn.mas_width);
        make.top.equalTo(loginBtn.mas_bottom).offset(10);
    }];

    UILabel *otherLabel = [UILabel new];
    otherLabel.text = @"其他方式登录";
    otherLabel.textAlignment = NSTextAlignmentCenter;
    otherLabel.textColor = UIColorFromRGB(0xaeaeae);
    otherLabel.font = [UIFont systemFontOfSize:18];
    [self.view addSubview:otherLabel];
    if (UI_IS_IPHONE5) {
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(registerBtn.mas_bottom).offset(50);
            make.width.equalTo(@120);
            make.height.equalTo(@30);
        }];
    }else{
        [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.top.equalTo(registerBtn.mas_bottom).offset(100);
            make.width.equalTo(@120);
            make.height.equalTo(@30);
        }];
    }
    UILabel *lineLeft = [UILabel new];
    lineLeft.backgroundColor = UIColorFromRGB(0xaeaeae);
    [self.view addSubview:lineLeft];
    [lineLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(line2.mas_left);
        make.right.equalTo(otherLabel.mas_left);
        make.height.equalTo(@1);
        make.centerY.equalTo(otherLabel.mas_centerY);
    }];
    
    UILabel *lineRight = [UILabel new];
    lineRight.backgroundColor = UIColorFromRGB(0xaeaeae);
    [self.view addSubview:lineRight];
    [lineRight mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(otherLabel.mas_right);
        make.right.equalTo(line2.mas_right);
        make.height.equalTo(@1);
        make.centerY.equalTo(otherLabel.mas_centerY);
    }];

    UIButton *weChatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [weChatBtn setImage:[UIImage imageNamed:@"微信默认"] forState:UIControlStateNormal];
    [weChatBtn setTitle:@"微信" forState:UIControlStateNormal];
    [weChatBtn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    weChatBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    weChatBtn.contentMode = UIViewContentModeCenter;
    [self.view addSubview:weChatBtn];
    [weChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineLeft.mas_left);
        make.width.equalTo(@((SCREEN_WIDTH - 30)/4));
        make.height.equalTo(@55);
        make.top.equalTo(otherLabel.mas_bottom).offset(30);
    }];
    [self setButtonContentCenter:weChatBtn];
    
    UIButton *weiBoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [weiBoBtn setImage:[UIImage imageNamed:@"微博默认"] forState:UIControlStateNormal];
    [weiBoBtn setTitle:@"微博" forState:UIControlStateNormal];
    [weiBoBtn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    weiBoBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    weiBoBtn.contentMode = UIViewContentModeCenter;
    [self.view addSubview:weiBoBtn];
    [weiBoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weChatBtn.mas_right);
        make.width.equalTo(@((SCREEN_WIDTH - 30)/4));
        make.height.equalTo(@55);
        make.top.equalTo(weChatBtn.mas_top);
    }];

    UIButton *qqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qqBtn setImage:[UIImage imageNamed:@"qq默认"] forState:UIControlStateNormal];
    [qqBtn setTitle:@"QQ" forState:UIControlStateNormal];
    [qqBtn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    qqBtn.titleLabel.font = [UIFont systemFontOfSize:12];

    qqBtn.contentMode = UIViewContentModeCenter;
    [self.view addSubview:qqBtn];
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weiBoBtn.mas_right);
        make.width.equalTo(@((SCREEN_WIDTH - 30)/4));
        make.height.equalTo(@55);
        make.top.equalTo(weChatBtn.mas_top);
    }];

    UIButton *otherUserBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [otherUserBtn setImage:[UIImage imageNamed:@"游客登录默认"] forState:UIControlStateNormal];
    [otherUserBtn setTitle:@"随便看看" forState:UIControlStateNormal];
    [otherUserBtn setTitleColor:UIColorFromRGB(0x6b6b6b) forState:UIControlStateNormal];
    otherUserBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    otherUserBtn.contentMode = UIViewContentModeCenter;
    [self.view addSubview:otherUserBtn];
    [otherUserBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(qqBtn.mas_right);
        make.width.equalTo(@((SCREEN_WIDTH - 30)/4));
        make.height.equalTo(@55);
        make.top.equalTo(weChatBtn.mas_top);
    }];
    
    [self setButtonContentCenter:weiBoBtn];
    [self setButtonContentCenter:qqBtn];
    [self setButtonContentCenter:otherUserBtn];
    
    [loginBtn addTarget:self action:@selector(loginClick:) forControlEvents:UIControlEventTouchUpInside];
    [registerBtn addTarget:self action:@selector(registerClick:) forControlEvents:UIControlEventTouchUpInside];
    [weChatBtn addTarget:self action:@selector(loginForWechat:) forControlEvents:UIControlEventTouchUpInside];
    [weiBoBtn addTarget:self action:@selector(loginForSina:) forControlEvents:UIControlEventTouchUpInside];
    [qqBtn addTarget:self action:@selector(loginForQQ:) forControlEvents:UIControlEventTouchUpInside];
    [otherUserBtn addTarget:self action:@selector(visitorsToLogin:) forControlEvents:UIControlEventTouchUpInside];
    [forgetPasswordBtn addTarget:self action:@selector(findPassword:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *backBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setImage:[UIImage  imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.view addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(5);
        make.height.equalTo(@50);
        make.width.equalTo(@30);
        make.top.equalTo(self.view).offset(30);
    }];

    
    self.userNameTF = userNameTF;
    self.passwordTF = passwordTF;
    self.userNameTF.delegate = self;
    self.passwordTF.delegate = self;
    self.headerImageView = headerView;
    
}
- (void)back:(UIButton *)btn{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark UITextFieldDelegate

#pragma mark 按钮图片文字垂直居中排列
-(void)setButtonContentCenter:(UIButton *)button
{
    CGSize imgViewSize,titleSize,btnSize;
    UIEdgeInsets imageViewEdge,titleEdge;
    CGFloat heightSpace = 10.0f;
    
    //设置按钮内边距
    imgViewSize = button.imageView.bounds.size;
    titleSize = button.titleLabel.bounds.size;
    btnSize = button.bounds.size;
    
    imageViewEdge = UIEdgeInsetsMake(heightSpace,0.0, btnSize.height -imgViewSize.height - heightSpace, - titleSize.width);
    [button setImageEdgeInsets:imageViewEdge];
    titleEdge = UIEdgeInsetsMake(imgViewSize.height +heightSpace, - imgViewSize.width, 0.0, 0.0);
    [button setTitleEdgeInsets:titleEdge];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"返回"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回"];
    //去掉左边的title
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //自定义一个NavigationBar
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    //PingFangSC
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Light" size:18],NSFontAttributeName, nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (USER_ID) {
//             [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_PHOTO] ]] placeholderImage:[UIImage imageNamed:@"用户默认头像"]];
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)loginClick:(UIButton *)btn{
    if ([Tool judgePhoneNumber:self.userNameTF.text]) {
        if (self.passwordTF.text.length > 5) {
          [LTHttpManager loginWithMobile:self.userNameTF.text andPassword:self.passwordTF.text andUUID:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
              if (result == LTHttpResultSuccess) {
                  SVProgressShowStuteText(@"登录成功", YES);
                  [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user_id"] forKey:USERID_KEY];
                  [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user_token"]forKey:USERTOKEN_KEY];
                   [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"photo"] forKey:USER_PHOTO];
                  [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"mobile"] forKey:USER_MOBILE];
                  [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"nickname"] forKey:USER_NICKNAME];
                  [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"read_num"] forKey:USER_READNUM];
                  [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"sex"] forKey:USER_SEX];
                   [[NSUserDefaults standardUserDefaults] synchronize];
                  [[NSNotificationCenter defaultCenter] postNotificationName:@"userlogin" object:nil];
                  [self presentViewController:[BaseTabBarViewController new] animated:YES completion:nil];
              }else{
                  SVProgressShowStuteText(@"登录失败", YES);
              }
          }];
        }else{
            SVProgressShowStuteText(@"密码不正确", NO);
        }
    }else{
        SVProgressShowStuteText(@"请输入正确的手机号码", NO);
    }
//    if ([Tool judgePhoneNumber:self.userNameTF.text] && self.passwordTF.text.length > 6){
//       
//    }else if (self.userNameTF.text.length == 0) {
//        [self.view makeToast:@"请输入手机号码"];
//        return;
//    }else if (self.passwordTF.text.length == 0){
//        [self.view makeToast:@"请输入密码"];
//        return;
//    }else if (self.userNameTF.text > 0){
//        if ( ![Tool judgePhoneNumber:self.userNameTF.text]) {
//            [self.view makeToast:@"请输入正确的手机号码"];
//            return;
//        }else if (self.passwordTF.text.length < 7) {
//            [self.view makeToast:@"请输入正确的密码"];
//            return;
//        }
//    }
}
- (void)registerClick:(UIButton *)sender{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BearUp" bundle:nil];
    UIViewController *vc = [storyBoard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
//    UINavigationController *naviVc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)loginForWechat:(id)sender {
      [self getAuthWithUserInfoFromWechat];
}
- (void)loginForSina:(id)sender {
    [self getAuthWithUserInfoFromSina];
}
- (void)loginForQQ:(id)sender {
    [self getAuthWithUserInfoFromQQ];
}
- (void)visitorsToLogin:(id)sender {
    BaseTabBarViewController *vc = [BaseTabBarViewController new];
    [self presentViewController:vc animated:YES completion:nil];
//    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)findPassword:(UIButton *)sender{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"BearUp" bundle:nil];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"FindPassword"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)getAuthWithUserInfoFromSina
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_Sina currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Sina uid: %@", resp.uid);
            NSLog(@"Sina accessToken: %@", resp.accessToken);
            NSLog(@"Sina refreshToken: %@", resp.refreshToken);
            NSLog(@"Sina expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Sina name: %@", resp.name);
            NSLog(@"Sina iconurl: %@", resp.iconurl);
            NSLog(@"Sina gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Sina originalResponse: %@", resp.originalResponse);
            [LTHttpManager thirdLoginReturnWithUUID:GETUUID OpenId:resp.uid Name:resp.name Gender:resp.gender Icon:resp.iconurl Type:@4 Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user_id"] forKey:USERID_KEY];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user_token"]forKey:USERTOKEN_KEY];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"photo"] forKey:USER_PHOTO];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"mobile"] forKey:USER_MOBILE];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"nickname"] forKey:USER_NICKNAME];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"read_num"] forKey:USER_READNUM];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"sex"] forKey:USER_SEX];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userlogin" object:nil];
                    SVProgressShowStuteText(@"登录成功", YES);
                    [self presentViewController:[BaseTabBarViewController new] animated:YES completion:nil];
                }else{
                    SVProgressShowStuteText(@"登录失败", NO);
                }
            }];
        }
    }];
}
- (void)getAuthWithUserInfoFromQQ
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"QQ uid: %@", resp.uid);
            NSLog(@"QQ openid: %@", resp.openid);
            NSLog(@"QQ accessToken: %@", resp.accessToken);
            NSLog(@"QQ expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"QQ name: %@", resp.name);
            NSLog(@"QQ iconurl: %@", resp.iconurl);
            NSLog(@"QQ gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"QQ originalResponse: %@", resp.originalResponse);
            [LTHttpManager thirdLoginReturnWithUUID:GETUUID OpenId:resp.openid Name:resp.name Gender:resp.gender Icon:resp.iconurl Type:@3 Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user_id"] forKey:USERID_KEY];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user_token"]forKey:USERTOKEN_KEY];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"photo"] forKey:USER_PHOTO];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"mobile"] forKey:USER_MOBILE];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"nickname"] forKey:USER_NICKNAME];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"read_num"] forKey:USER_READNUM];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"sex"] forKey:USER_SEX];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userlogin" object:nil];
                    SVProgressShowStuteText(@"登录成功", YES);
                    [self presentViewController:[BaseTabBarViewController new] animated:YES completion:nil];
                }else{
                    SVProgressShowStuteText(@"登录失败", YES);
                }
            }];
        }
    }];
}
- (void)getAuthWithUserInfoFromWechat
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.gender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            [LTHttpManager thirdLoginReturnWithUUID:GETUUID OpenId:resp.uid Name:resp.name Gender:resp.gender Icon:resp.iconurl Type:@2 Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user_id"] forKey:USERID_KEY];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user_token"]forKey:USERTOKEN_KEY];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"photo"] forKey:USER_PHOTO];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"mobile"] forKey:USER_MOBILE];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"nickname"] forKey:USER_NICKNAME];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"read_num"] forKey:USER_READNUM];
                    [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"sex"] forKey:USER_SEX];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"userlogin" object:nil];
                    SVProgressShowStuteText(@"登录成功", YES);
                    [self presentViewController:[BaseTabBarViewController new] animated:YES completion:nil];
                }else{
                    SVProgressShowStuteText(@"登录失败", NO);
                }
            }];
        }
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
