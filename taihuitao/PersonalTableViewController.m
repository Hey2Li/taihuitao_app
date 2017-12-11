//
//  PersonalTableViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/9/21.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "PersonalTableViewController.h"
#import "SettingTableViewController.h"
#import "NoContentViewController.h"
#import "LoginViewController.h"
#import "InfoSettingTableViewController.h"

@interface PersonalTableViewController ()
@property (weak, nonatomic) IBOutlet UIView *tableViewHeaderView;
@property (weak, nonatomic) IBOutlet UIButton *userHeaderImageBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation PersonalTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:NSStringFromClass([UITableViewCell class])];
    self.tableView.backgroundColor = RGBCOLOR(248, 248, 248);
    self.tableView.separatorStyle = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.userHeaderImageBtn addTarget:self action:@selector(gotoLogin:) forControlEvents:UIControlEventTouchUpInside];
//    self.tableView.frame = CGRectMake(-64, 0, ScreenWidth, ScreenHeight);
}
- (void)gotoLogin:(UIButton *)btn{
    if (USER_ID) {
        InfoSettingTableViewController *vc = [InfoSettingTableViewController new];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        
        UIViewController *presentVC = self.parentViewController;
        if ([presentVC isKindOfClass:[LoginViewController class]]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"BearUp" bundle:nil];
            LoginViewController *lvc = [storyBoard instantiateViewControllerWithIdentifier:@"loginNavi"];
            [self presentViewController:lvc animated:YES completion:nil];
        }
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:USER_PHOTO]) {
        [self.userHeaderImageBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_PHOTO]]] forState:UIControlStateNormal];
        if ([[NSUserDefaults standardUserDefaults]objectForKey:USER_NICKNAME]) {
             self.userNameLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:USER_NICKNAME]];
        }
    }else{
        if (USER_ID) {
            [self.userHeaderImageBtn setImage:[UIImage imageNamed:@"btg_icon_avatar_placeholder"] forState:UIControlStateNormal];
            self.userNameLabel.text = @"填写资料";
        }else{
            [self.userHeaderImageBtn setImage:[UIImage imageNamed:@"btg_icon_avatar_placeholder"] forState:UIControlStateNormal];
            self.userNameLabel.text = @"去登录";
        }
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    }else if (section == 1){
        return 1;
    }else{
        return 0;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
   return CGFLOAT_MIN;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = NO;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = RGBCOLOR(93, 93, 93);
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"我的收藏";
            cell.imageView.image = [UIImage imageNamed:@"我的收藏_17x17_"];
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"我的订单";
            cell.imageView.image = [UIImage imageNamed:@"我的订单_17x17_"];
            self.tableView.separatorStyle = YES;
        }else{
            cell.textLabel.text = @"我的原创";
            cell.imageView.image = [UIImage imageNamed:@"我的原创_17x17_"];
            self.tableView.separatorStyle = YES;
        }
    }
   else{
        cell.textLabel.text = @"设置";
        cell.imageView.image = [UIImage imageNamed:@"设置_17x17_"];
    }
//    }else if (indexPath.section == 1){
//        cell.textLabel.text = @"礼品兑换";
//        cell.imageView.image = [UIImage imageNamed:@"礼品兑换_17x17_"];
//    }
    return cell;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //分割线补全
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (USER_ID) {
        if (indexPath.section == 1 ) {
            SettingTableViewController *vc = [SettingTableViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            NoContentViewController *vc = [NoContentViewController new];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES
             ];
        }
    }else{
      SVProgressShowStuteText(@"请先登录", NO);
    }
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
