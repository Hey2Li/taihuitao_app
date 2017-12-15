//
//  SettingTableViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/7/11.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "SettingTableViewController.h"
#import <WebKit/WebKit.h>
#import "LaunchScrollViewController.h"
#import "WebContentViewController.h"

@interface SettingTableViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self initWithView];
    self.title = @"设置";
}
- (void)initWithView{
    if (USER_ID) {
        UIButton *quitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.tableView addSubview:quitBtn];
        [quitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.tableView);
            make.height.equalTo(@36);
            make.width.equalTo(@200);
            make.bottom.equalTo(self.tableView.mas_bottom).offset(400);
        }];
        [quitBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        [quitBtn.layer setMasksToBounds:YES];
        [quitBtn.layer setCornerRadius:18];
        quitBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [quitBtn setBackgroundColor:UIColorFromRGB(0xff4466)];
        [quitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [quitBtn addTarget:self action:@selector(quitLogin) forControlEvents:UIControlEventTouchUpInside];

    }else{
        
    }
}
- (void)quitLogin{
    if (USER_ID) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERID_KEY];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:USERTOKEN_KEY];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:USER_PHOTO];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:USER_MOBILE];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:USER_NICKNAME];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:USER_READNUM];
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:USER_SEX];

        SVProgressShowStuteText(@"退出成功", YES);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userquit" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        SVProgressShowStuteText(@"请先登录", NO);
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    float tmpSize = [[SDImageCache sharedImageCache] getSize];
    NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.1fMB",tmpSize/(1024*1024)] : [NSString stringWithFormat:@"%.1fKB",tmpSize * 1024];
    NSLog(@"%@",clearCacheName);
    
    /***********************************************/
    NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
    
    NSString *libraryDir = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory,
                                                               NSUserDomainMask, YES)[0];
    NSString *bundleId  =  [[[NSBundle mainBundle] infoDictionary]
                            objectForKey:@"CFBundleIdentifier"];
    NSString *webkitFolderInLib = [NSString stringWithFormat:@"%@/WebKit",libraryDir];
    NSString *webKitFolderInCaches = [NSString
                                      stringWithFormat:@"%@/Caches/%@/WebKit",libraryDir,bundleId];
    NSString *webKitFolderInCachesfs = [NSString
                                        stringWithFormat:@"%@/Caches/%@/fsCachedData",libraryDir,bundleId];
    NSLog(@"%fkb,%fkb",[self folderSizeAtPath:webKitFolderInCaches], [self folderSizeAtPath:webkitFolderInLib]);
    
    NSError *error;
    /* iOS8.0 WebView Cache的存放路径 */
    //    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCaches error:&error];
    //    [[NSFileManager defaultManager] removeItemAtPath:webkitFolderInLib error:nil];
    //
    //    /* iOS7.0 WebView Cache的存放路径 */
    //    [[NSFileManager defaultManager] removeItemAtPath:webKitFolderInCachesfs error:&error];
    /**************************************/
}
- (void)cleanCache{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        NSSet *type = [NSSet setWithArray:@[
                                            WKWebsiteDataTypeDiskCache,
                                            WKWebsiteDataTypeMemoryCache
                                            ]];
        NSDate *dateFrom = [NSDate date];
        [[WKWebsiteDataStore defaultDataStore]removeDataOfTypes:type modifiedSince:dateFrom completionHandler:^{
            [[SDImageCache sharedImageCache] clearDisk];
            SVProgressShowStuteText(@"清理成功！", YES);
            [self.tableView reloadData];
            NSLog(@"清理WKWebView缓存");
            
        }];
    }else{
        NSString *libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        [[NSFileManager defaultManager]removeItemAtPath:cookiesFolderPath error:nil];
        NSLog(@"%fkb",[self folderSizeAtPath:cookiesFolderPath]);
        [[SDImageCache sharedImageCache] clearDisk];
        SVProgressShowStuteText(@"清理成功！", YES);
        [self.tableView reloadData];
    }
}
-(float)folderSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    long long folderSize=0;
    if ([fileManager fileExistsAtPath:cachePath])
    {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles)
        {
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            long long size=[self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            
        }
        //SDWebImage框架自身计算缓存的实现
        folderSize+=[[SDImageCache sharedImageCache] getSize];
        return folderSize/1024.0/1024.0;
    }
    return 0;
}
-(long long)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size=[fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size;
    }
    return 0;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self.tabBarController.tabBar setHidden:NO];
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
    return 6;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = NO;
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = RGBCOLOR(93, 93, 93);
    }
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"联系我们";
            break;
        case 1:
            cell.textLabel.text = @"关于我们";
            break;
        case 2:
            cell.textLabel.text = @"用户使用协议";
            break;
        case 3:
        {
            cell.textLabel.text = @"清理缓存";
            float tmpSize = [[SDImageCache sharedImageCache] getSize];
            NSString *clearCacheName = tmpSize >= 1 ? [NSString stringWithFormat:@"%.1fMB",tmpSize/(1024*1024)] : [NSString stringWithFormat:@"%.1fKB",tmpSize * 1024];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = clearCacheName;
        }

            break;
        case 4:
            cell.textLabel.text = @"给太会淘打个分";
            break;
        case 5:
        {
            cell.textLabel.text = @"版本信息";
            cell.detailTextLabel.text = @"1.0";
            cell.accessoryType = UITextAutocapitalizationTypeNone;
        }
            break;
        default:
            break;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
//            SVProgressShowStuteText(@"暂未开放", NO);
        {
            NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"025-88018310-810"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 1:
        {
            SVProgressShowStuteText(@"暂未开放", NO);
//            LaunchScrollViewController *vc = [LaunchScrollViewController new];
//            vc.type = @"1";
//            [self presentViewController:vc animated:YES completion:nil];
        }
            break;
        case 2:
        {
            WebContentViewController *vc =[[WebContentViewController alloc]init];
            vc.UrlString = @"http://shimo.im/doc/8DM33EnsQAUXR0is/";
            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case 3:
            [self cleanCache];
            break;
        case 4:
        {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1321280759&pageNumber=0&sortOrdering=2&type=Purple+Software&mt=8"]];
        }
            break;
        case 5:
            
            break;
        default:
            break;
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
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
