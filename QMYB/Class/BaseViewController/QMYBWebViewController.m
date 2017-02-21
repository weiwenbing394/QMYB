//
//  QMYBWebViewController.m
//  QMYB
//
//  Created by 大家保 on 2017/2/20.
//  Copyright © 2017年 大家保. All rights reserved.
//

#import "QMYBWebViewController.h"
#import <WebKit/WebKit.h>

@interface QMYBWebViewController ()<WKNavigationDelegate>

@property (nonatomic,strong) WKWebView *myWebView;

@end

@implementation QMYBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myWebView = [[WKWebView alloc] init];
    self.myWebView.navigationDelegate = self;
    self.myWebView.allowsBackForwardNavigationGestures = YES;
    [self.view insertSubview:self.myWebView atIndex:0];
    self.myWebView.sd_layout.leftSpaceToView(self.view,0).topSpaceToView(self.view,44.5).rightSpaceToView(self.view,0).bottomSpaceToView(self.view,0);
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [self.myWebView loadRequest:request];
    [self.myWebView setNeedsUpdateConstraints];
    [self addObservers];
}

- (void)addObservers {
    [self.myWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:NULL];
    [self.myWebView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.myWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        if (object == self.myWebView) {
            self.jinduProgress.progress=self.myWebView.estimatedProgress;
            self.jinduProgress.hidden=self.myWebView.estimatedProgress>=1?YES:NO;
            if (self.myWebView.estimatedProgress>=1) {
                self.jinduProgress.progress=0;
            }
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"title"]) {
        if (object == self.myWebView) {
            self.titleLabel.text = self.myWebView.title;
        }else{
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else if ([keyPath isEqualToString:@"contentSize"]){
        if (object == self.myWebView.scrollView) {
        }else {
            [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    self.jinduProgress.progress=0.1;
    self.refreshButton.hidden=YES;
    NSLog(@"开始加载");
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    self.refreshButton.hidden=YES;
    NSLog(@"返回内容");
};
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if ([self.myWebView canGoBack]) {
        self.closeButton.hidden=NO;
    }else{
        self.closeButton.hidden=YES;
    }
    self.refreshButton.hidden=YES;
    NSLog(@"加载完成");
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    //显示错误页面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.refreshButton.hidden=NO;
        NSLog(@"加载错误");
    });
}

//回退
- (IBAction)goBack:(id)sender {
    if ([self.myWebView canGoBack]) {
        [self.myWebView goBack];
        //是否隐藏叉叉
        if ([self.myWebView canGoBack]) {
            self.closeButton.hidden=NO;
        }else{
            self.closeButton.hidden=YES;
        }
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//关闭
- (IBAction)goPreViewController:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


//刷新
- (IBAction)reload:(id)sender {
    if ([self.myWebView canGoBack]) {
        [self.myWebView reload];
    }else{
        [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]]];
    }
}

- (void)dealloc {
    [self.myWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    [self.myWebView removeObserver:self forKeyPath:@"title"];
    [self.myWebView.scrollView removeObserver:self forKeyPath:@"contentSize"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
