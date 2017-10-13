//
//  FindPasswordViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/6/8.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "FindPasswordViewController.h"
#import "BaseTabBarViewController.h"

@interface FindPasswordViewController ()<UIAlertViewDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *findBtn;
@property (weak, nonatomic) IBOutlet UIButton *hidePasswordBtn;
@property (weak, nonatomic) IBOutlet UIButton *hidePasswordagainBtn;
@property (weak, nonatomic) IBOutlet UIButton *postCodeBtn;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *inputPasswordTF;
@property (weak, nonatomic) IBOutlet UITextField *inputPasswordAgainTF;


@end

@implementation FindPasswordViewController

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
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"找回密码";
    [self initWithView];
}
- (void)initWithView{
    [self.findBtn.layer setCornerRadius:18];
    [self.findBtn.layer setMasksToBounds:YES];
    [self.findBtn addTarget:self action:@selector(findBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.phoneTF.delegate = self;
    self.codeTF.delegate = self;
    self.phoneTF.keyboardType = UIKeyboardTypePhonePad;
    self.codeTF.keyboardType = UIKeyboardTypePhonePad;
    self.inputPasswordTF.delegate = self;
    self.inputPasswordAgainTF.delegate = self;
    self.inputPasswordAgainTF.secureTextEntry = YES;
    self.inputPasswordTF.secureTextEntry = YES;
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

- (void)findBtnClick:(UIButton *)sender{
    if ([Tool judgePhoneNumber:self.phoneTF.text]) {
//        if ([self.codeTF.text isEqualToString:@"1111"]) {
            if (self.inputPasswordTF.text.length > 7 && self.inputPasswordAgainTF.text.length > 7) {
                if ([self.inputPasswordTF.text isEqualToString:self.inputPasswordAgainTF.text]) {
                    [LTHttpManager submitNewPasswordWithNumber:self.phoneTF.text Type:@1 Password:self.inputPasswordTF.text Code:self.codeTF.text Complete:^(LTHttpResult result, NSString *message, id data) {
                        if (result == LTHttpResultSuccess) {
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"找回密码成功，请登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }else{
                            // [self.view makeToast:message];
                        }
                    }];
                }else{
                    SVProgressShowStuteText(@"两次密码不一致", NO);
                }
            }else{
                SVProgressShowStuteText(@"请输入正确的密码", NO);
            }
//        }else{
//            [self.view makeToast:@"请输入正确的验证码"];
//        }
    }else{
        SVProgressShowStuteText(@"请输入正确的手机号码", NO);
    }
}
- (IBAction)postCode:(UIButton *)sender {
    if ([Tool judgePhoneNumber:self.phoneTF.text]) {
        [LTHttpManager sendCodeWithNumber:self.phoneTF.text Ntype:@2 Type:@1 Complete:^(LTHttpResult result, NSString *message, id data) {
            if (result == LTHttpResultSuccess) {
                [self openCountdown];
            }else{
                // [self.view makeToast:message];
            }
        }];
    }else{
        SVProgressShowStuteText(@"请输入正确的手机号码", NO);
    }
}

- (IBAction)hidePassword:(UIButton *)sender {
    sender.selected = !sender.selected;
    [sender setImage:[UIImage imageNamed:@"查看输入的密码"] forState:UIControlStateSelected];
    if (sender.selected) {
        self.inputPasswordTF.secureTextEntry = NO;
    }else{
        self.inputPasswordTF.secureTextEntry = YES;
    }

}

- (IBAction)hidePasswordAgain:(UIButton *)sender {
    sender.selected = !sender.selected;
    [sender setImage:[UIImage imageNamed:@"查看输入的密码"] forState:UIControlStateSelected];
    if (sender.selected) {
        self.inputPasswordAgainTF.secureTextEntry = NO;
    }else{
        self.inputPasswordAgainTF.secureTextEntry = YES;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
