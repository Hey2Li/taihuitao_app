//
//  RegisterViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/6/7.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "RegisterViewController.h"
#import "WebContentViewController.h"

@interface RegisterViewController ()<UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *setPasswordTF;
@property (weak, nonatomic) IBOutlet UIButton *readerUserBtn;
@property (weak, nonatomic) IBOutlet UIButton *passwordHideBtn;
@property (weak, nonatomic) IBOutlet UIButton *postCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *readerTitleBtn;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"注册";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initWithView];
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
}

- (void)initWithView{
    self.phoneTF.keyboardType = UIKeyboardTypePhonePad;
    self.codeTF.keyboardType = UIKeyboardTypePhonePad;
    self.setPasswordTF.secureTextEntry = YES;
    [self.registerBtn.layer setCornerRadius:self.registerBtn.bounds.size.height/2];
    [self.registerBtn.layer setMasksToBounds:YES];
    [self.registerBtn setBackgroundColor:UIColorFromRGB(0xff4466)];
    self.phoneTF.delegate = self;
    self.codeTF.delegate = self;
    self.setPasswordTF.delegate = self;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.phoneTF) {
        NSInteger strLength = textField.text.length - range.length + string.length;
        if (strLength > 11){
            return NO;
        }
        NSString *text = nil;
        //如果string为空，表示删除
        if (string.length > 0) {
            text = [NSString stringWithFormat:@"%@%@",textField.text,string];
        }else{
            text = [textField.text substringToIndex:range.location];
            [self.postCodeBtn setBackgroundColor:UIColorFromRGB(0xaeaeae)];
            [self.postCodeBtn setEnabled:NO];
        }
        if ([Tool judgePhoneNumber:text]) {
            [self.postCodeBtn setEnabled:YES];
            [self.postCodeBtn setBackgroundColor:UIColorFromRGB(0xff4466)];
        }else{
            [self.postCodeBtn setEnabled:NO];
            [self.postCodeBtn setBackgroundColor:UIColorFromRGB(0xaeaeae)];
        }
    }
    return YES;
}
- (IBAction)posetCodeBtn:(id)sender {
    if ([Tool judgePhoneNumber:self.phoneTF.text]) {
        [LTHttpManager sendCodeWithNumber:self.phoneTF.text Ntype:@1 Type:@1 Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                [self openCountdown];
                SVProgressShowStuteText([NSString stringWithFormat:@"%@",data[@"responseData"][@"msg"]],NO);
            }else{
                // [self.view makeToast:message];
            }
        }];
    }else{
        SVProgressShowStuteText(@"请输入正确的手机号码", NO);
    }
}
- (IBAction)registerBtn:(id)sender {
    if ([Tool judgePhoneNumber:self.phoneTF.text]) {
//        if ([self.codeTF.text isEqualToString:@"1111"]) {
            if ([Tool checkPassword:self.setPasswordTF.text]) {
                [LTHttpManager registerWithMobile:self.phoneTF.text andPassword:self.setPasswordTF.text andUUID:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
                    if (result == LTHttpResultSuccess) {
                        [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user_id"] forKey:USERID_KEY];
                        [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"user_token"]forKey:USERTOKEN_KEY];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"注册成功，请登录" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                    }else{
                       // [self.view makeToast:message];
                    }
                }];
            }else{
                SVProgressShowStuteText(@"请输入正确的密码", NO);
            }
//        }else{
//            SVProgressShowStuteText(@"请输入正确的验证码", NO);
//        }
    }else{
        SVProgressShowStuteText(@"请输入正确的手机号码", NO);
    }
//    if ([Tool judgePhoneNumber:self.phoneTF.text] && self.setPasswordTF.text.length > 6 && self.codeTF.text.length == 4){
//       
//    }else if (self.phoneTF.text.length == 0) {
//        [self.view makeToast:@"请输入手机号码"];
//        return;
//    }else if (self.setPasswordTF.text.length == 0){
//        [self.view makeToast:@"请输入密码"];
//        return;
//    }else if (self.phoneTF.text > 0){
//        if ( ![Tool judgePhoneNumber:self.phoneTF.text]) {
//            [self.view makeToast:@"请输入正确的手机号码"];
//            return;
//        }else if (self.setPasswordTF.text.length < 7) {
//            [self.view makeToast:@"请输入正确的密码"];
//            return;
//        }
//    }
}
- (IBAction)readerAgreement:(UIButton *)sender {
    sender.selected = !sender.selected;
    [sender setImage:[UIImage imageNamed:@"未鍍條款"] forState:UIControlStateSelected];
    if (sender.selected) {
        [self.readerTitleBtn setTitleColor:UIColorFromRGB(0xaeaeae) forState:UIControlStateNormal];
    }else{
        [self.readerTitleBtn setTitleColor:UIColorFromRGB(0x000000) forState:UIControlStateNormal];
    }

}
- (IBAction)readUserAgreement:(id)sender {
    WebContentViewController *vc =[[WebContentViewController alloc]init];
    vc.UrlString = @"https://shimo.im/doc/8DM33EnsQAUXR0is/";
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)hidePasswordBtn:(UIButton *)sender {
    sender.selected = !sender.selected;
    [sender setImage:[UIImage imageNamed:@"查看输入的密码"] forState:UIControlStateSelected];
    if (sender.selected) {
        self.setPasswordTF.secureTextEntry = NO;
    }else{
        self.setPasswordTF.secureTextEntry = YES;
    }
}
// 开启倒计时效果
-(void)openCountdown{
    
    __block NSInteger time = 59; //倒计时时间
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    
    dispatch_source_set_event_handler(_timer, ^{
        
        if(time <= 0){ //倒计时结束，关闭
            
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮的样式
                [self.postCodeBtn setTitle:@"重新发送" forState:UIControlStateNormal];
                [self.postCodeBtn setBackgroundColor:UIColorFromRGB(0xff4466)];
                self.postCodeBtn.userInteractionEnabled = YES;
            });
            
        }else{
            
            int seconds = time % 60;
            dispatch_async(dispatch_get_main_queue(), ^{
                
                //设置按钮显示读秒效果
                [self.postCodeBtn setTitle:[NSString stringWithFormat:@"重新发送(%.2d)", seconds] forState:UIControlStateNormal];
                [self.postCodeBtn setBackgroundColor:UIColorFromRGB(0xaeaeae)];
                self.postCodeBtn.userInteractionEnabled = NO;
            });
            time--;
        }
    });
    dispatch_resume(_timer);
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
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
