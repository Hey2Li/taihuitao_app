//
//  ArticleDetailViewController.m
//  taihuitao
//
//  Created by Tebuy on 2017/8/24.
//  Copyright © 2017年 Tebuy. All rights reserved.
//

#import "ArticleDetailViewController.h"
#import "GoodsDetailsTableViewCell.h"
#import "BuyGoodsTableViewCell.h"
#import "HorizontalTableViewCell.h"
#import "ArticleDetailModel.h"
#import "RecommedCellModel.h"
#import "WebContentViewController.h"
#import <WebKit/WebKit.h>
#import "DataInfo.h"
#import "ImageInfo.h"
#import "BottomBuyView.h"
#import "XLPhotoBrowser.h"


@interface ArticleDetailViewController ()<UITableViewDataSource, UITableViewDelegate, ZFPlayerDelegate, WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,BottomBuyViewDelegate>
@property (nonatomic, strong) UITableView *myTableView;
@property (nonatomic, strong) NSMutableArray *goodsMutableArray;
@property (nonatomic, strong) NSDictionary *infoDataDic;
@property (nonatomic, strong) NSMutableArray *recommendMutableArrray;

@property (nonatomic, strong) UIView *playerFatherView;
@property (nonatomic, strong) ZFPlayerView *playerView;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) ZFPlayerModel *playerModel;

@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) NSDictionary *htmlDict;
@property (nonatomic, strong) BottomBuyView *bottomView;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UITableView *buyGoodsTableView;
@end

@implementation ArticleDetailViewController
static NSString * const picMethodName = @"openBigPicture:";

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
        _maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        [self.view addSubview:_maskView];
        [self.view bringSubviewToFront:_maskView];
        [_maskView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.top.equalTo(self.view);
            make.bottom.equalTo(self.bottomView.mas_top);
        }];
        _maskView.hidden = YES;
    }
    return _maskView;
}
- (BottomBuyView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BottomBuyView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 50, SCREEN_WIDTH, 50)];
        _bottomView.delegate = self;
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}
- (NSMutableArray *)recommendMutableArrray{
    if (!_recommendMutableArrray) {
        _recommendMutableArrray = [NSMutableArray array];
    }
    return _recommendMutableArrray;
}
- (NSMutableArray *)goodsMutableArray{
    if (!_goodsMutableArray) {
        _goodsMutableArray = [NSMutableArray array];
    }
    return _goodsMutableArray;
}
- (UITableView *)myTableView{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 50) style:UITableViewStylePlain];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
        _myTableView.separatorStyle = NO;
        [_myTableView registerNib:[UINib nibWithNibName:@"GoodsDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"gooddetailcell"];
        [_myTableView registerNib:[UINib nibWithNibName:@"BuyGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"buygoodcell"];
        [_myTableView registerClass:[HorizontalTableViewCell class] forCellReuseIdentifier:NSStringFromClass([HorizontalTableViewCell class])];
        _myTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _myTableView;
}
- (UITableView *)buyGoodsTableView{
    if (!_buyGoodsTableView) {
        _buyGoodsTableView = [[UITableView alloc]init];
        _buyGoodsTableView.delegate = self;
        _buyGoodsTableView.dataSource = self;
        _buyGoodsTableView.separatorStyle = NO;
        [_buyGoodsTableView registerNib:[UINib nibWithNibName:@"GoodsDetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"gooddetailcell"];
        [_buyGoodsTableView registerNib:[UINib nibWithNibName:@"BuyGoodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"buygoodcell"];
        _buyGoodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_buyGoodsTableView.layer setMasksToBounds:YES];
        [_buyGoodsTableView.layer setCornerRadius:10];
    }
    return _buyGoodsTableView;
}
- (ZFPlayerModel *)playerModel {
    if (!_playerModel) {
        _playerModel                  = [[ZFPlayerModel alloc] init];
        //        _playerModel.title            = @"这里设置视频标题";
        //        _playerModel.videoURL         = self.videoURL;
        _playerModel.placeholderImage = [UIImage imageNamed:@"loading_bgView1"];
        _playerModel.fatherView       = self.playerFatherView;
    }
    return _playerModel;
}

- (ZFPlayerView *)playerView {
    if (!_playerView) {
        _playerView = [[ZFPlayerView alloc] init];
        
        /*****************************************************************************************
         *   // 指定控制层(可自定义)
         *   // ZFPlayerControlView *controlView = [[ZFPlayerControlView alloc] init];
         *   // 设置控制层和播放模型
         *   // 控制层传nil，默认使用ZFPlayerControlView(如自定义可传自定义的控制层)
         *   // 等效于 [_playerView playerModel:self.playerModel];
         ******************************************************************************************/
        [_playerView playerControlView:nil playerModel:self.playerModel];
        
        // 设置代理
        _playerView.delegate = self;
        
        //（可选设置）可以设置视频的填充模式，内部设置默认（ZFPlayerLayerGravityResizeAspect：等比例填充，直到一个维度到达区域边界）
        // _playerView.playerLayerGravity = ZFPlayerLayerGravityResize;
        
        // 打开下载功能（默认没有这个功能）
        //        _playerView.hasDownload    = YES;
        
        // 打开预览图
        _playerView.hasPreviewView = YES;
        
    }
    return _playerView;
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self.view addSubview:self.myTableView];
        [self.view addSubview:self.bottomView];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.tabBarController.tabBar setHidden:YES];
    if (self.isVideo.length > 2) {
        if (self.navigationController.viewControllers.count == 2 && self.playerView && self.isPlaying) {
            self.isPlaying = NO;
            self.playerView.playerPushedOrPresented = NO;
        }
    }
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.isVideo.length > 2) {
        // push出下一级页面时候暂停
        if (self.navigationController.viewControllers.count == 3 && self.playerView && !self.playerView.isPauseByUser)
        {
            self.isPlaying = YES;
            //        [self.playerView pause];
            self.playerView.playerPushedOrPresented = YES;
        }else{
            [self.playerView resetPlayer];
        }
    } 
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self initWKWebView];
}
#pragma mark WebView
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
    
    WKWebView *wkWebView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64) configuration:configur];
    
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
    
    self.myTableView.tableHeaderView = self.wkWebView;
}
#pragma mark - WKScriptMessageHandler
    
    /*
     1、js调用原生的方法就会走这个方法
     2、message参数里面有2个参数我们比较有用，name和body，
     2.1 :其中name就是之前已经通过addScriptMessageHandler:name:方法注入的js名称
     2.2 :其中body就是我们传递的参数了，我在js端传入的是一个字典，所以取出来也是字典，字典里面包含原生方法名以及被点击图片的url
     */
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
     NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
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
    }
}
#pragma mark - JS调用 OC的方法进行图片浏览
- (void)openBigPicture:(NSString *)imageSrc{
        NSLog(@"%@",imageSrc);
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:imageView];
    imageView.contentMode = UIViewContentModeCenter;
    imageView.backgroundColor = [UIColor blackColor];
    [imageView sd_setImageWithURL:[NSURL URLWithString:imageSrc]];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeImageView:)];
    [imageView addGestureRecognizer: tap];
    imageView.userInteractionEnabled = YES;
}
- (void)removeImageView:(UITapGestureRecognizer *)tap{
    tap.view.hidden = !tap.view.hidden;
    [tap.view removeFromSuperview];
}
    
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    SVProgressShow();
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    SVProgressHiden();
}
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error{
    SVProgressShowStuteText(@"加载失败", NO);
}
- (void)loadingHtmlNews:(DataInfo *)data{
    NSMutableString *body = [data.content mutableCopy];
    
    //文章标题
    NSString *title = data.title;
    self.title = data.title;
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
                      ,cssPath,jsPath,title,sourceName,sourceTime,body];
    
    
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
- (void)setIsVideo:(NSString *)isVideo{
    _isVideo = isVideo;
    self.playerFatherView = [[UIView alloc] init];
    [self.myTableView addSubview:self.playerFatherView];
    [self.playerFatherView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTableView.mas_top);
        make.leading.trailing.mas_equalTo(0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.mas_equalTo(self.playerFatherView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    [self.playerView autoPlayTheVideo];
}
- (void)zf_playerBackAction {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setArticleId:(NSNumber *)articleId{
    _articleId = articleId;
    WeakSelf
    [LTHttpManager TnewsDetailWithId:articleId Value:@"" Complete:^(LTHttpResult result, NSString *message, id data) {
        if (result == LTHttpResultSuccess) {
            DataInfo *model = [DataInfo mj_objectWithKeyValues:[data objectForKey:@"responseData"][@"info"]];
            [weakSelf loadingHtmlNews:model];
//            self.infoDataDic = data[@"responseData"][@"info"];
            NSArray *dataArray = data[@"responseData"][@"commodity"];
            [self.goodsMutableArray removeAllObjects];
            for (NSDictionary *dic in dataArray) {
                ArticleDetailModel *model = [ArticleDetailModel mj_objectWithKeyValues:dic];
                [self.goodsMutableArray addObject:model];
            }
            NSArray *recomdArray = data[@"responseData"][@"recomd"];
            [self.recommendMutableArrray removeAllObjects];
            for (NSDictionary *dic in recomdArray) {
                RecommedCellModel *model = [RecommedCellModel mj_objectWithKeyValues:dic];
                [self.recommendMutableArrray addObject:model];
            }
            if (self.isVideo.length > 2) {
                self.playerModel.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.infoDataDic[@"url"]]];
                [self.playerView resetToPlayNewVideo:self.playerModel];
            }
            [self.myTableView reloadData];
        }else{
            [self.playerView resetPlayer];
        }
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark BotttomDeleagte
- (void)buyWithBtnClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        self.maskView.hidden = NO;
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.maskView addSubview:self.buyGoodsTableView];
        [self.buyGoodsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.maskView).offset(30);
            make.right.equalTo(self.maskView).offset(-30);
            make.centerX.equalTo(self.maskView.mas_centerX);
            make.bottom.equalTo(self.maskView.mas_bottom);
            make.height.equalTo(@(ScreenHeight/2));
        }];
        [self.maskView addSubview:closeBtn];
        [closeBtn setImage:[UIImage imageNamed:@"buysign_close_30x30_"] forState:UIControlStateNormal];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(_buyGoodsTableView.mas_right);
            make.top.equalTo(_buyGoodsTableView);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        [self.maskView bringSubviewToFront:closeBtn];
        [closeBtn addTarget:self action:@selector(closeTableView) forControlEvents:UIControlEventTouchUpInside];
    }else{
        self.maskView.hidden = YES;
    }
}
- (void)backWithBtnClick:(UIButton *)btn{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)closeTableView{
     self.maskView.hidden = YES;
}
#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.buyGoodsTableView) {
        return 1;
    }
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.buyGoodsTableView) {
        return self.goodsMutableArray.count;
    }
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.buyGoodsTableView) {
        return 0;
    }
    if (section == 0) {
        return 50;
    }else{
        return 0;
    }
   
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.buyGoodsTableView) {
        return 0;
    }
    UIView *view = [UIView new];
    if (section == 0) {
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = @"猜你喜欢";
        nameLabel.textColor = [UIColor blackColor];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.font = [UIFont systemFontOfSize:14];
        [view addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.equalTo(@100);
        }];
        UILabel *leftLine = [UILabel new];
        leftLine.backgroundColor = [UIColor grayColor];
        [view addSubview:leftLine];
        [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view.mas_left).offset(10);
            make.right.equalTo(nameLabel.mas_left).offset(-10);
            make.height.equalTo(@1);
            make.centerY.equalTo(nameLabel.mas_centerY);
        }];
        UILabel *rightLine = [UILabel new];
        rightLine.backgroundColor = [UIColor grayColor];
        [view addSubview:rightLine];
        [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(nameLabel.mas_right).offset(10);
            make.right.equalTo(view.mas_right).offset(-10);
            make.height.equalTo(@1);
            make.centerY.equalTo(nameLabel.mas_centerY);
        }];
    }
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.buyGoodsTableView) {
        return 120;
    }
  if (indexPath.section == 0){
      return [Tool layoutForAlliPhoneHeight:120];
    }else if (indexPath.section == 1){
        return 50;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.buyGoodsTableView) {
            BuyGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"buygoodcell"];
            cell.model = self.goodsMutableArray[indexPath.row];
            ArticleDetailModel *model = self.goodsMutableArray[indexPath.row];
            cell.buyGoodsBlock = ^(UIButton *btn) {
                [LTHttpManager getPlatformWithID:model.ID Complete:^(LTHttpResult result, NSString *message, id data) {
                    WebContentViewController *vc = [[WebContentViewController alloc]init];
                    vc.UrlString = data[@"responseData"][0][@"url"];
                    [self.navigationController pushViewController:vc animated:YES];
                }];
            };
            return cell;
    }
   if (indexPath.section == 0){
       HorizontalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HorizontalTableViewCell class])];
       WeakSelf
       cell.HorCollectionCellClick = ^(NSIndexPath *indexPath) {
           RecommedCellModel *model = weakSelf.recommendMutableArrray[indexPath.row];
           ArticleDetailViewController *vc = [ArticleDetailViewController new];
           vc.articleId = model.ID;
           [self.navigationController pushViewController:vc animated:YES];
       };
       cell.modelArray = self.recommendMutableArrray;
       return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        cell.userInteractionEnabled = NO;
        cell.backgroundColor = [UIColor whiteColor];
        return cell;
    }else{
        return 0;
    }
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
