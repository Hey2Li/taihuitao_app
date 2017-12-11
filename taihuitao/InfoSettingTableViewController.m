//
//  InfoSettingTableViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/7/12.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "InfoSettingTableViewController.h"
#import "TZImagePickerController.h"

@interface InfoSettingTableViewController ()<TZImagePickerControllerDelegate>
@property (nonatomic, strong) UIButton *headerBtn;
@property (nonatomic, strong) UITextField *nickNameTextFiled;
@property (nonatomic, strong) NSNumber *sex;
@property (nonatomic, strong) UIButton *tempBtn;
@property (nonatomic, strong) NSArray *photosArr;
@end

@implementation InfoSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    self.title = @"资料设置";
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveBtn:)];
    self.navigationItem.rightBarButtonItem = item;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)saveBtn:(UIButton *)btn{
    if (self.nickNameTextFiled.text.length > 0) {
        if ([_sex integerValue] == 1 || [_sex integerValue] == 2) {
            [LTHttpManager saveUserInfoWithSex:_sex Nickname:self.nickNameTextFiled.text User_token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
                if (LTHttpResultSuccess == result) {
                    [LTHttpManager uploadPhotoWithPhotoArray:_photosArr User_token:USER_TOKEN User_id:USER_ID User_uuid:GETUUID Complete:^(LTHttpResult result, NSString *message, id data) {
                        if (LTHttpResultSuccess == result) {
                            [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"photo"] forKey:USER_PHOTO];
                            [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"mobile"] forKey:USER_MOBILE];
                            [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"nickname"] forKey:USER_NICKNAME];
                            [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"read_num"] forKey:USER_READNUM];
                            [[NSUserDefaults standardUserDefaults]setObject:data[@"responseData"][@"sex"] forKey:USER_SEX];
                            [[NSUserDefaults standardUserDefaults]synchronize];
                            SVProgressShowStuteText(@"保存成功", YES);
                            [self.navigationController popViewControllerAnimated:YES];
                        }else{
                             SVProgressShowStuteText(@"保存失败", NO);
                        }
                    }];
                }
            }];
        }else{
            SVProgressShowStuteText(@"请选择性别", NO);
        }
    }else{
        SVProgressShowStuteText(@"请输入昵称", NO);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 120;
    }else{
        return 50;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = NO;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = RGBCOLOR(93, 93, 93);
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (indexPath.row == 0) {
        UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cell.contentView addSubview:headerBtn];
        [headerBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_PHOTO] ]]  forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"btg_icon_avatar_placeholder"]];
        [headerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(cell.contentView);
            make.height.equalTo(@80);
            make.width.equalTo(@80);
        }];
        [headerBtn.layer setMasksToBounds:YES];
        [headerBtn.layer setCornerRadius:40];
        [headerBtn addTarget:self action:@selector(uploadPhoto:) forControlEvents:UIControlEventTouchUpInside];
        self.headerBtn = headerBtn;
        NSArray *array = @[self.headerBtn.imageView.image];
        _photosArr = array;
        return cell;

    }else if (indexPath.row == 1){
        cell.textLabel.text = @"昵称";
        UITextField *textfield = [UITextField new];
        textfield.placeholder = @"请输入昵称";
        textfield.clearButtonMode = UITextFieldViewModeAlways;
        textfield.borderStyle = UITextBorderStyleNone;
        [cell.contentView addSubview:textfield];
        [textfield mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(80);
            make.right.equalTo(cell.contentView).offset(-10);
            make.centerY.equalTo(cell.contentView);
            make.height.equalTo(@35);
        }];
        self.nickNameTextFiled = textfield;
        self.nickNameTextFiled.text = [NSString stringWithFormat:@"%@",[userDefaults objectForKey:USER_NICKNAME] ? [userDefaults objectForKey:USER_NICKNAME]:@""];
        return cell;

    }else if (indexPath.row == 2){
        cell.textLabel.text = @"性别";
        UIButton *girlBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [girlBtn setTitle:@"我是女生" forState:UIControlStateNormal];
        [girlBtn setTitleColor:UIColorFromRGB(0xffbcc8) forState:UIControlStateNormal];
        [cell.contentView addSubview:girlBtn];
        [girlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView.mas_left).offset(80);
            make.centerY.equalTo(cell.contentView);
            make.width.equalTo(@100);
            make.height.equalTo(@24);
        }];
        [girlBtn.layer setMasksToBounds:YES];
        [girlBtn.layer setCornerRadius:12];
        [girlBtn.layer setBorderWidth:1];
        [girlBtn.layer setBorderColor:UIColorFromRGB(0xffbcc8).CGColor];
        UIButton *boyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [boyBtn setTitleColor:UIColorFromRGB(0x9da3b0) forState:UIControlStateNormal];
        [boyBtn setTitle:@"我是男生" forState:UIControlStateNormal];
        [cell.contentView addSubview:boyBtn];
        [boyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-20);
            make.centerY.equalTo(cell.contentView);
            make.width.equalTo(girlBtn);
            make.height.equalTo(girlBtn);
        }];
        [boyBtn.layer setMasksToBounds:YES];
        [boyBtn.layer setCornerRadius:12];
        [boyBtn.layer setBorderWidth:1];
        [boyBtn.layer setBorderColor:UIColorFromRGB(0x9da3b0).CGColor];
        
        [girlBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [boyBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        boyBtn.tag = 1;
        girlBtn.tag = 2;
        [boyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [girlBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        if ([[userDefaults objectForKey:USER_SEX] isEqual:@1]) {
            [self btnClick:boyBtn];
        }else if ([[userDefaults objectForKey:USER_SEX] isEqual:@2]){
            [self btnClick:girlBtn];
        }else{
            
        }

        return cell;
    }else{
        return 0;
    }
}
- (void)btnClick:(UIButton *)btn{
    if (_tempBtn == nil) {
        btn.selected = YES;
        _tempBtn = btn;
    }else if (_tempBtn != nil && _tempBtn == btn){
        btn.selected = YES;
    }else if (_tempBtn != nil && _tempBtn != btn){
        btn.selected = YES;
        _tempBtn.selected = NO;
        _tempBtn = btn;
    }
    _sex = @(btn.tag) ;
    if (btn.tag == 1&& btn.selected) {
        [btn setBackgroundColor:UIColorFromRGB(0x9da3b0)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        UIButton *button = [btn.superview viewWithTag:2];
        button.backgroundColor = [UIColor whiteColor];
    }else if(btn.tag == 2 && btn.selected ){
        [btn setBackgroundColor:UIColorFromRGB(0xffbcc8)];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        UIButton *button = [btn.superview viewWithTag:1];
        button.backgroundColor = [UIColor whiteColor];

    }
}
- (void)uploadPhoto:(UIButton *)btn{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.needCircleCrop = YES;
    imagePickerVc.circleCropRadius = 30;
    imagePickerVc.navigationBar.translucent = NO;
    //这句话设置导航栏不透明(!!!!!!!!!!!!!!!!!!!!!!!!!  解决问题)
    
    imagePickerVc.navigationBar.backIndicatorImage = [UIImage imageNamed:@"返回白"];
    imagePickerVc.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"返回白"];
    
    //自定义一个NavigationBar
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //消除阴影
    imagePickerVc.navigationBar.shadowImage = [UIImage new];
    //PingFangSCd自定义title字体
    imagePickerVc.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"PingFangSC-Light" size:18],NSFontAttributeName, nil];
    imagePickerVc.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    
    [imagePickerVc.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi"] forBarMetrics:UIBarMetricsDefault];

    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets ,BOOL isSelectOriginalPhoto) {
        NSLog(@"%@%@",photos, assets);
        [self.headerBtn setImage:photos[0] forState:UIControlStateNormal];
        self.headerBtn.layer.cornerRadius = 40;
        self.headerBtn.layer.masksToBounds = YES;
        self.photosArr = photos;
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
