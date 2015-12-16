//
//  AgreementViewController.m
//  EAT
//
//  Created by beartech on 15/4/27.
//  Copyright (c) 2015年 KeKeStudio. All rights reserved.
//

#import "AgreementViewController.h"
#import "Defines.h"

@interface AgreementViewController ()<UIWebViewDelegate>

@end


@implementation AgreementViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"用户协议"];
    
//    [self setLeftBarButtonWithImage:@"btn_NavChaN.png"
//                             target:self
//                             action:@selector(back)];
    self.navBar.leftButton = AWCreateTextButton(CGRectMake(0, 0, 40, 40),
                                                @"返回",
                                                NAVBAR_HIGHLIGHT_TEXT_COLOR,
                                                self,
                                                @selector(back));

    UIWebView *myWebView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//    [myWebView cleanHeaderFooterBackgroundView];
    myWebView.delegate = self;
    [self.view addSubview:myWebView];
    [myWebView release];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"agreement.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:filePath];
    [myWebView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)back{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        
    }];
}


#pragma mark ==================================================
#pragma mark == UIWebViewDelegate
#pragma mark ==================================================
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    UIActivityIndicatorView *waitingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [waitingView startAnimating];
    [self.view addSubview:waitingView];
    waitingView.center = CGPointMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height/2.0);
    [waitingView release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    for (UIView *view in [self.view subviews]) {
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{

}


@end
