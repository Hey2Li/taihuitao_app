//
//  CDetailViewController.m
//  BearUp
//
//  Created by Tebuy on 2017/5/16.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "CDetailViewController.h"
#import <WebKit/WebKit.h>
#import "DataInfo.h"
#import "ImageInfo.h"
//#import "CommentsTableViewCell.h"
//#import "BottomCommentView.h"
#import <UShareUI/UShareUI.h>
//#import "CommentModel.h"

@interface CDetailViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NSDictionary *htmlDict;
@property (strong, nonatomic) NSMutableArray *imagesArr;
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *commentDataArray;
@property (nonatomic, assign) int pageNum;
@property (nonatomic, strong) DataInfo *infoData;
@property (nonatomic, strong) NSNumber *isCollection;
@property (nonatomic, strong) NSMutableArray *danmuArray;
@property (nonatomic, strong) NSString *shareUrl;
@end

@implementation CDetailViewController
static NSString * const picMethodName = @"openBigPicture:";
static NSString * const videoMethodName = @"openVideoPlayer:";
static NSString *commentCell = @"commentCell";

- (NSMutableArray *)danmuArray{
    if (!_danmuArray) {
        _danmuArray = [NSMutableArray array];
    }
    return _danmuArray;
}
- (NSMutableArray *)commentDataArray{
    if (!_commentDataArray) {
        _commentDataArray = [NSMutableArray array];
    }
    return _commentDataArray;
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self.navigationController setNavigationBarHidden:NO animated:animated];

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initWithView];
    [self initWKWebView];
//    [self getContentHtml];
    [self loadData];
    self.title = @"详情";
//    [self footerLoadData];
    _pageNum = 1;
    self.view.backgroundColor = [UIColor whiteColor];
}
- (void)loadData{
    WeakSelf
    [LTHttpManager TnewsDetailWithId:self.cid  Value:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (LTHttpResultSuccess == result) {
            DataInfo *model = [DataInfo mj_objectWithKeyValues:[data objectForKey:@"responseData"][@"info"]];
            _isCollection = data[@"responseData"][@"info"][@"iscoll"];
//            _shareUrl = data[@"responseData"][@"info"][@"share_url"];
            _infoData = model;
            [weakSelf loadingHtmlNews:model];
        }else{
            // [self.view makeToast:message];
        }
    }];
}


/*
- (void)initWithView{
    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
    self.myTableView = [UITableView new];
    [self.view addSubview:self.myTableView];
    [self.myTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.bottomView.mas_top);
    }];
    self.myTableView.delegate = self;
    self.myTableView.dataSource = self;
    self.myTableView.showsVerticalScrollIndicator = NO;
    self.wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    [self.myTableView registerNib:[UINib nibWithNibName:@"CommentsTableViewCell" bundle:nil] forCellReuseIdentifier:commentCell];
    self.myTableView.rowHeight = UITableViewAutomaticDimension;
    self.myTableView.estimatedRowHeight = 130.5f;
    
    UIButton *lookforCommentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [lookforCommentBtn setTitle:@"看评论" forState:UIControlStateNormal];
    lookforCommentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [lookforCommentBtn setImage:[UIImage imageNamed:@"评论红"] forState:UIControlStateNormal];
    [lookforCommentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookforCommentBtn setBackgroundColor:DRGBCOLOR];
    [self.view addSubview:lookforCommentBtn];
    [self.view bringSubviewToFront:lookforCommentBtn];
    [lookforCommentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@35);
        make.width.equalTo(@80);
        make.bottom.equalTo(self.view.mas_bottom).offset(-200);
    }];
    [lookforCommentBtn addTarget:self action:@selector(lookForCommentWithBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setTitle:@"去分享" forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [shareBtn setImage:[UIImage imageNamed:@"分享红"] forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [shareBtn setBackgroundColor:DRGBCOLOR];
    [self.view addSubview:shareBtn];
    [self.view bringSubviewToFront:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(@35);
        make.width.equalTo(@80);
        make.top.equalTo(lookforCommentBtn.mas_bottom).offset(10);
    }];
    [shareBtn addTarget:self action:@selector(shareWithBtnClick:) forControlEvents:UIControlEventTouchUpInside];

}
 */
- (void)initWKWebView{
    //创建一个WKWebView的配置对象
    WKWebViewConfiguration *configur = [[WKWebViewConfiguration alloc]init];
    
    //设置configur对象的preferences属性的信息
    WKPreferences *preferences = [[WKPreferences alloc]init];
    configur.preferences = preferences;
    
    //是否允许与js进行交互，默认是YES的，如果设置为NO，js的代码就不起作用了
    preferences.javaScriptEnabled = YES;
    
    /*设置configur对象的WKUserContentController属性的信息，也就是设置js可与webview内容交互配置
     1、通过这个对象可以注入js名称，在js端通过window.webkit.messageHandlers.自定义的js名称.postMessage(如果有参数可以传递参数)方法来发送消息到native；
     2、我们需要遵守WKScriptMessageHandler协议，设置代理,然后实现对应代理方法(userContentController:didReceiveScriptMessage:);
     3、在上述代理方法里面就可以拿到对应的参数以及原生的方法名，我们就可以通过NSSelectorFromString包装成一个SEL，然后performSelector调用就可以了
     4、以上内容是WKWebview和UIWebview针对JS调用原生的方法最大的区别(UIWebview中主要是通过是否允许加载对应url的那个代理方法，通过在js代码里面写好特殊的url，然后拦截到对应的url，进行字符串的匹配以及截取操作，最后包装成SEL，然后调用就可以了)
     */
    
    /*
     上述是理论说明，结合下面的实际代码再做一次解释，保你一看就明白
     1、通过addScriptMessageHandler:name:方法，我们就可以注入js名称了,其实这个名称最好就是跟你的方法名一样，这样方便你包装使用，我这里自己写的就是openBigPicture，对应js中的代码就是window.webkit.messageHandlers.openBigPicture.postMessage()
     2、因为我的方法是有参数的，参数就是图片的url，因为点击网页中的图片，要调用原生的浏览大图的方法，所以你可以通过字符串拼接的方式给"openBigPicture"拼接成"openBigPicture:"，我这里没有采用这种方式，我传递的参数直接是字典，字典里面放了方法名以及图片的url，到时候直接取出来用就可以了
     3、我的js代码中关于这块的代码是
     window.webkit.messageHandlers.openBigPicture.postMessage({methodName:"openBigPicture:",imageSrc:imageArray[this.index].src});
     4、js和原生交互这块内容离不开
     - (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{}这个代理方法，这个方法以及参数说明请到下面方法对应处
     
     */
    WKUserContentController *userContentController = [[WKUserContentController alloc]init];
    [userContentController addScriptMessageHandler:self name:@"openBigPicture"];
    [userContentController addScriptMessageHandler:self name:@"openVideoPlayer"];
    configur.userContentController = userContentController;
    
    WKWebView *wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) configuration:configur];
    
//    [self.view addSubview:wkWebView];
//    self.wkWebView = wkWebView;
    //设置内边距底部，主要是为了让网页最后的内容不被底部的toolBar挡着
//    wkWebView.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 104, 0);
    
    //这句代码是让竖直方向的滚动条显示在正确的位置
    wkWebView.scrollView.scrollIndicatorInsets = wkWebView.scrollView.contentInset;
    
    wkWebView.UIDelegate = self;
    
    wkWebView.navigationDelegate = self;
    
    wkWebView.scrollView.bounces = NO;
 
    self.wkWebView = wkWebView;
    [self.view addSubview:self.wkWebView];
//    self.myTableView.tableHeaderView = self.wkWebView;
}
- (void)getContentHtml{
    //AQ76LHPS00963VRO AQ4RPLHG00964LQ9轻松一刻
    NSString * detailID = @"AQ76LHPS00963VRO";//多张图片
    NSMutableString *urlStr = [NSMutableString stringWithString:@"http://c.3g.163.com/nc/article/nil/full.html"];
    //http://c.m.163.com/nc/article/nil/full.html
    [urlStr replaceOccurrencesOfString:@"nil" withString:detailID options:NSCaseInsensitiveSearch range:[urlStr rangeOfString:@"nil"]];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    WeakSelf
    [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        weakSelf.htmlDict = responseObject[detailID];
        
        //回到主线程刷新UI
//        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
//            self.navigationItem.title = self.htmlDict[@"title"];
//        }];
        DataInfo *model = [DataInfo mj_objectWithKeyValues:[responseObject objectForKey:detailID]];

        [weakSelf loadingHtmlNews:model];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        NSLog(@"%@",error);  //这里打印错误信息
    }];

}
- (void)loadingHtmlNews:(DataInfo *)data{
    NSMutableString *body = [data.content mutableCopy];
    
    //文章标题
    NSString *title = data.title;
    
    //来源
    NSString *sourceName = [NSString string];
    if (self.htmlDict[@"articleTags"]) {
        sourceName = self.htmlDict[@"articleTags"];
    }else {
        sourceName = data.source ? data.source : @"";
    }
    
    //发布时间
    NSString *sourceTime = data.ptime ? data.ptime : @"";
    //文章里面的图片
//    NSArray *imagArray = data.images;
    
    [data.images enumerateObjectsUsingBlock:^(NSDictionary *info, NSUInteger idx, BOOL * _Nonnull stop) {
        NSRange range = [body rangeOfString:info[@"ref"]];
        NSArray *wh = [info[@"pixel"] componentsSeparatedByString:@"*"];
        CGFloat width = [[wh objectAtIndex:0] floatValue];
        CGFloat height = [[wh objectAtIndex:1] floatValue];

        //占位图
        NSString *loadingImg = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"png"];
        NSString *imageStr = [NSString stringWithFormat:@"<div style = 'text-align:center'><img src = %@ width = '%.0f' height = '%.0f' hspace='0.0' vspace ='5'  /></div>",info[@"url"], width, height];
        NSLog(@"%@",imageStr);
        [body replaceOccurrencesOfString:info[@"ref"] withString:imageStr options:NSCaseInsensitiveSearch range:range];
    }];
//    [self getImageFromDownloaderOrDiskByImageUrlArray:data.images];

//    for (ImageInfo *imageDict in data.images) {
//        //图片在body中的占位标识，比如"<!--IMG#3-->"
//        NSString *imageRef = imageDict.ref;
//        //图片的url
//        NSString *imageSrc = imageDict.url;
//        //图片下面的文字说明
//        NSString *imageAlt = imageDict.alt;
//        
//        NSString *imageHtml  = [NSString string];
//
//        //把对应的图片url转换成html里面显示图片的代码
//        if (imageAlt) {
//            
//            imageHtml = [NSString stringWithFormat:@"<div><img width=\"100%%\" src=\"%@\"><div class=\"picDescribe\">%@</div></div>",imageSrc,imageAlt];
//        }else{
//            imageHtml = [NSString stringWithFormat:@"<div><img width=\"100%%\" src=\"%@\"></div>",imageSrc];
//        }
//        
//        //这一步是显示图片的关键，主要就是把body里面的图片的占位标识给替换成上一步已经生成的html语法格式的图片代码，这样WKWebview加载html之后图片就可以被加载显示出来了
////        body = [[body stringByReplacingOccurrencesOfString:imageRef withString:imageHtml] copy];
//    }
    
    //css文件的全路径
    NSURL *cssPath = [[NSBundle mainBundle] URLForResource:@"newDetail" withExtension:@"css"];
    
    //    NSURL *videoPath = [[NSBundle mainBundle] URLForResource:@"video-js" withExtension:@"css"];
    //js文件的路径
    NSURL *jsPath = [[NSBundle mainBundle] URLForResource:@"newDetail" withExtension:@"js"];
    
    
    //这里就是把前面的数据融入到html代码里面了，关于html的语法知识这里就不多说了，如果有不明白的可以咨询我或者亲自去w3c网站学习的-----“http://www.w3school.com.cn/”
    //OC中使用'\'就相当于说明了‘\’后面的内容和前面都是一起的
    
    NSString *html = [NSString stringWithFormat:@"\
                      <html lang=\"en\">\
                      <head>\
                      <meta name=\"viewport\" content=\"user-scalable=no\">\
                      <meta charset=\"UTF-8\">\
                      <link href=\"%@\" rel=\"stylesheet\">\
                      <link rel=\"stylesheet\" href=\"http://cdn.static.runoob.com/libs/bootstrap/3.3.7/css/bootstrap.min.css\">\
                      <script src=\"%@\"type=\"text/javascript\"></script>\
                      </head>\
                      <body id=\"mainBody\">\
                      <header>\
                      <div id=\"father\">\
                      <div id=\"mainTitle\">%@</div>\
                      <div id=\"sourceTitle\"><span class=\"source\">%@</span><span class=\"time\">%@</span></div>\
                      <div>%@</div>\
                      </div>\
                      </header>\
                      </body>\
                      </html>"\
                      ,cssPath,jsPath,@"",sourceName,sourceTime,body];
    
    self.title = title;
    NSLog(@"%@",html);
    
    //这里需要说明一下，(loadHTMLString:baseURL:)这个方法的第二个参数，之前用UIWebview写的时候只需要传递nil即可正常加载本地css以及js文件，但是换成WKWebview之后你再传递nil，那么css以及js的代码就不会起任何作用，当时写的时候遇到了这个问题，谷歌了发现也有朋友遇到这个问题，但是还没有找到比较好的解决答案，后来自己又搜索了一下，从一个朋友的一句话中有了发现，就修改成了现在的正确代码，然后效果就可以正常显示了
    //使用现在这种写法之后，baseURL就指向了程序的资源路径，这样Html代码就和css以及js是一个路径的。不然WKWebview是无法加载的。当然baseURL也可以写一个网络路径，这样就可以用网络上的CSS了
    [self.wkWebView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] resourcePath]]];
}

#pragma mark scrollview delegate (计算contentOffset的值，根据上下距离来决定bounces)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat top = scrollView.contentOffset.y;
    if ([scrollView isKindOfClass:[UITableView class]]) {
        if (top  > (self.myTableView.contentSize.height - SCREEN_HEIGHT - 100)) {
            self.myTableView.bounces = YES;
        }else{
            self.myTableView.bounces = NO;
        }
    }else if(scrollView == self.wkWebView.scrollView){
        if (top > 30) {
            self.myTableView.bounces = NO;
        }else{
            self.myTableView.bounces = YES;
        }
    }
    if (self.myTableView.contentOffset.y > 0) {
        self.wkWebView.scrollView.scrollEnabled = NO;
    }else {
        self.wkWebView.scrollView.scrollEnabled = YES;
    }
}


#pragma mark - bottomComment delegate
//- (void)danmuWithBtnClick:(UIButton *)btn{
//    if (!btn.selected) {
//        [_render start];
//        [btn setImage:[UIImage imageNamed:@"弹幕红"] forState:UIControlStateNormal];
//    }else{
//        [_render stop];
//        [btn setImage:[UIImage imageNamed:@"弹幕灰"] forState:UIControlStateNormal];
//    }
//}
- (void)lookForCommentWithBtnClick:(UIButton *)btn{
    //看评论 
    if (self.commentDataArray.count > 0) {
         [self.myTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }else{
        SVProgressShowStuteText(@"暂无评论", NO);
    }
}
//- (void)collectWithBtnClick:(UIButton *)btn{
//    if (!btn.selected) {
//        [LTHttpManager collectionNewsWithNewID:@([self.cid integerValue] ) UUID:GETUUID User_id:USER_ID Token:USER_TOKEN Complete:^(LTHttpResult result, NSString *message, id data) {
//            if (LTHttpResultSuccess == result) {
//                SVProgressShowStuteText(@"收藏成功", YES);
//                btn.selected = YES;
//                [btn setImage:[UIImage imageNamed:@"收藏红"] forState:UIControlStateSelected];
//            }else{
//
//            }
//        }];
//    }else{
//        [LTHttpManager collectionNewsWithNewID:@([self.cid integerValue] ) UUID:GETUUID User_id:USER_ID Token:USER_TOKEN Complete:^(LTHttpResult result, NSString *message, id data) {
//            if (LTHttpResultSuccess == result) {
//                SVProgressShowStuteText(@"取消收藏成功", YES);
//                btn.selected = NO;
//                [btn setImage:[UIImage imageNamed:@"收藏灰"] forState:UIControlStateSelected];
//            }else{
//
//            }
//        }];
//    }
//}
- (void)shareWithBtnClick:(UIButton *)btn{
    [UMSocialShareUIConfig shareInstance].sharePageGroupViewConfig.sharePageGroupViewPostionType = UMSocialSharePageGroupViewPositionType_Bottom;
    [UMSocialShareUIConfig shareInstance].sharePageScrollViewConfig.shareScrollViewPageItemStyleType = UMSocialPlatformItemViewBackgroudType_None;
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSLog(@"%ld---%@",(long)platformType, userInfo);
        [self shareWebPageToPlatformType:platformType];
    }];
}
//- (void)commentTextFieldShouldReturn:(UITextField *)textfiled{
//    [LTHttpManager commentNewsWithId:@(textfiled.tag) Content:textfiled.text Complete:^(LTHttpResult result, NSString *message, id data) {
//        if (LTHttpResultSuccess == result) {
//            SVProgressShowStuteText(@"评论成功", YES);
//            [textfiled resignFirstResponder];
//            textfiled.text = nil;
//            [LTHttpManager getMoreNewsCommentWithID:@([self.cid integerValue]) Page:@1 Complete:^(LTHttpResult result, NSString *message, id data) {
//                if (LTHttpResultSuccess == result) {
//                    NSArray *array = data[@"responseData"][@"data"];
//                    [self.commentDataArray removeAllObjects];
//                    for (NSDictionary *dic in array) {
//                        CommentModel *model = [CommentModel mj_objectWithKeyValues:dic];
//                        [self.commentDataArray addObject:model];
//                    }
//                        [self.myTableView reloadData];
//                    [self lookForCommentWithBtnClick:nil];
//                }else{
//
//                }
//            }];
//        }else{
//            SVProgressShowStuteText(@"评论失败", NO);
//        }
//    }];
//}
//网页分享
- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_infoData.title descr:_infoData.title thumImage:[UIImage imageNamed:@"微博点击"]];
    //设置网页地址
    if (_shareUrl.length > 5) {
        shareObject.webpageUrl =_shareUrl;
    }
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    

        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
            if (error) {
                UMSocialLogInfo(@"************Share fail with error %@*********",error);
                SVProgressShowStuteText(@"分享失败", NO);
            }else{
                if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                    UMSocialShareResponse *resp = data;
                    //分享结果消息
                    UMSocialLogInfo(@"response message is %@",resp.message);
                    //第三方原始返回的数据
                    UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                    SVProgressShowStuteText(@"分享成功", YES);
                    
                }else{
                    UMSocialLogInfo(@"response data is %@",data);
                }
            }
    }];
}
#pragma mark - TableViewDelegate
/*
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.commentDataArray.count > 0) {
//        return self.commentDataArray.count;
//    }else{
        return 0;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.commentDataArray.count > 0) {
        self.myTableView.estimatedRowHeight = 135.0f;
        self.myTableView.rowHeight = UITableViewAutomaticDimension;
        return self.myTableView.rowHeight;
    }else{
        return 200;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label = [UILabel new];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"全部评论";
    label.textColor = UIColorFromRGB(0x000000);
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = UIColorFromRGB(0xf5f5f5);
    return label;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.commentDataArray.count > 0) {
        CommentsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:commentCell];
        cell.model = self.commentDataArray[indexPath.row];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"没有评论"]];
        imageView.contentMode = UIViewContentModeCenter;
        [cell.contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView);
            make.top.equalTo(cell.contentView);
            make.bottom.equalTo(cell.contentView);
        }];
        return cell;
    }
}
 */
#pragma mark - WKWebViewDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    SVProgressShowText(@"正在加载");
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
//    CGFloat height = self.wkWebView.scrollView.contentSize.height;
//    [self.wkWebView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, height)];
//    NSLog(@"%f",height);
//    [self.myTableView reloadData];
    SVProgressHiden();
}
#pragma mark - WKScriptMessageHandler

/*
 1、js调用原生的方法就会走这个方法
 2、message参数里面有2个参数我们比较有用，name和body，
 2.1 :其中name就是之前已经通过addScriptMessageHandler:name:方法注入的js名称
 2.2 :其中body就是我们传递的参数了，我在js端传入的是一个字典，所以取出来也是字典，字典里面包含原生方法名以及被点击图片的url
 */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    //NSLog(@"%@,%@",message.name,message.body);
    
    NSDictionary *imageDict = message.body;
    NSString *src = [NSString string];
    if (imageDict[@"imageSrc"]) {
        src = imageDict[@"imageSrc"];
    }else{
        src = imageDict[@"videoSrc"];
    }
    NSString *name = imageDict[@"methodName"];
    
    //如果方法名是我们需要的，那么说明是时候调用原生对应的方法了
    if ([picMethodName isEqualToString:name]) {
        SEL sel = NSSelectorFromString(picMethodName);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        //写在这个中间的代码,都不会被编译器提示PerformSelector may cause a leak because its selector is unknown类型的警告
        [self performSelector:sel withObject:src];
#pragma clang diagnostic pop
    }else if ([videoMethodName isEqualToString:name]){
        
        SEL sel = NSSelectorFromString(name);
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Warc-performSelector-leaks"
        
        [self performSelector:sel withObject:src];
#pragma clang diagnostic pop
        
    }
}

#pragma mark - WKUIDelegate(js弹框需要实现的代理方法)
//使用了WKWebView后，在JS端调用alert()是不会在HTML中显式弹出窗口，是我们需要在该方法中手动弹出iOS系统的alert的
//该方法中的message参数就是我们JS代码中alert函数里面的参数内容
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    //    NSLog(@"js弹框了");
    UIAlertController *alertView = [UIAlertController alertControllerWithTitle:@"JS-Coder" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [alertView addAction:[UIAlertAction actionWithTitle:@"Sure" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //一定要调用下这个block
        //API说明：The completion handler to call after the alert panel has been dismissed
        completionHandler();
    }]];
    [self presentViewController:alertView animated:YES completion:nil];
    
}


#pragma mark - JS调用 OC的方法进行图片浏览
- (void)openBigPicture:(NSString *)imageSrc
{
    NSLog(@"%@",imageSrc);
}


#pragma mark - JS调用 OC的方法进行视频播放
- (void)openVideoPlayer:(NSString *)videoSrc
{
    NSLog(@"%@",videoSrc);
    
}
- (void)getImageFromDownloaderOrDiskByImageUrlArray:(NSArray *)imageArray {
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    self.imagesArr = [NSMutableArray array];
    __weak typeof(self)weakSelf = self;
    for (ImageInfo *info in imageArray) {
        NSURL *imageUrl = [NSURL URLWithString:info.url];
        [self.imagesArr addObject:imageUrl];
        [imageManager diskImageExistsForURL:imageUrl completion:^(BOOL isInCache) {
            isInCache ? [weakSelf handleExistCache:imageUrl] : [weakSelf handleNotExistCache:imageUrl];
        }];
    }
}

//已经有图片缓存
- (void)handleExistCache:(NSURL *)imageUrl {
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    NSString *cacheKey = [imageManager cacheKeyForURL:imageUrl];
    NSString *imagePath = [imageManager.imageCache defaultCachePathForKey:cacheKey];
    
    NSString *sendData = [NSString stringWithFormat:@"replaceimage%@,%@", imageUrl.absoluteString, imagePath];
//    [self.bridge callHandler:@"replaceImage" data:sendData responseCallback:^(id responseData) {
//        NSLog(@"%@", responseData);
//    }];
}

//本地没有图片缓存
- (void)handleNotExistCache:(NSURL *)imageUrl {
    SDWebImageManager *imageManager = [SDWebImageManager sharedManager];
    __weak typeof(self)weakSelf = self;
    
    [imageManager downloadImageWithURL:imageUrl options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image && finished) {
            NSLog(@"下载成功");
            [weakSelf handleExistCache:imageUrl];
        } else {
            NSLog(@"图片下载失败");
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
