//
//  SOGiftsDetailViewController.m
//  souban
//
//  Created by 周国勇 on 1/4/16.
//  Copyright © 2016 wajiang. All rights reserved.
//

#import "SOGiftsDetailViewController.h"
#import <WebKit/WebKit.h>
#import "Masonry.h"
#import "UIView+Layout.h"
#import "OMHUDManager.h"
#import "UIWebView+MakeCall.h"

@interface SOGiftsDetailViewController ()<WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end

@implementation SOGiftsDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    __weak __typeof(&*self) weakSelf = self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom).with.offset(-75);
        make.top.equalTo(weakSelf.view.mas_top);
    }];
    
    [OMHUDManager showActivityIndicatorMessage:@"加载中..."];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self url]]];
    
    [self.view sendSubviewToBack:self.webView];

    [self.webView loadRequest:request];

    self.webView.navigationDelegate = self;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (IBAction)telTapped:(id)sender {
    [UIWebView callWithString:@"4000571806"];
}

#pragma mark - WebView Delegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [OMHUDManager dismiss];
    if ([self.userInfo[@"title"] length] == 0) {
        self.navigationItem.title = webView.title;
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [OMHUDManager showErrorWithStatus:@"加载失败!"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.navigationController popViewControllerAnimated:YES];
    });
}

#pragma mark - Getter
- (NSString *)url
{
    return self.userInfo[@"url"];
}

- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    }
    return _webView;
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
