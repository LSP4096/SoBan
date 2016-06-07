//
//  SOWebViewController.m
//  souban
//
//  Created by 周国勇 on 11/11/15.
//  Copyright © 2015 wajiang. All rights reserved.
//

#import "SOWebViewController.h"
#import <WebKit/WebKit.h>
#import "UIView+Layout.h"
#import <Masonry.h>
#import "OMHUDManager.h"
#import "kCommonMacro.h"


@interface SOWebViewController () <WKNavigationDelegate>

@property (strong, nonatomic) WKWebView *webView;

@end


@implementation SOWebViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.view addSubview:self.webView];
    __weak __typeof(&*self) weakSelf = self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view.mas_left);
        make.right.equalTo(weakSelf.view.mas_right);
        make.bottom.equalTo(weakSelf.view.mas_bottom);
        make.top.equalTo(weakSelf.view.mas_top);

    }];

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self url]]];
    [OMHUDManager showActivityIndicatorMessage:@"加载中..."];
    [self.webView loadRequest:request];
    self.webView.navigationDelegate = self;

    self.navigationItem.title = [self navTitle];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WKWebView Delegate
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    // Determine if we want the system to handle it.
    NSURL *url = navigationAction.request.URL;
    if ([url.scheme isEqualToString:kOMUniversalScheme]) {
        [[UIApplication sharedApplication] openURL:url];
        decisionHandler(WKNavigationActionPolicyCancel);
    } else {
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [OMHUDManager dismiss];
    if ([self navTitle].length == 0) {
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

- (NSString *)navTitle
{
    return self.userInfo[@"title"];
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
