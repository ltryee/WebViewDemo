//
//  ViewController.m
//  WebviewDemo
//
//  Created by 刘天扬 on 15/7/15.
//  Copyright (c) 2015年 com.text. All rights reserved.
//

#import "ViewController.h"
#import "MttViewSnapshotHelper.h"
#import <SafariServices/SafariServices.h>

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *backwardButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *refreshButton;
@property (nonatomic, strong) UIButton *goButton;
@property (nonatomic, strong) UIButton *snapshotButton;
@property (nonatomic, strong) UIButton *safariButton;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger buttonCount = 6;
    CGRect webViewFrame = self.view.bounds;
    webViewFrame.size.height -= 44 * 2 + 20;
    webViewFrame.origin.y += 44 * 2 + 20;
    self.webView = [[UIWebView alloc] initWithFrame:webViewFrame];
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    
    CGSize buttonSize = CGSizeMake(CGRectGetWidth(self.webView.frame) / buttonCount, 44);
    const CGFloat buttonY = CGRectGetMinY(self.webView.frame) - 44;
    self.backwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.backwardButton.frame = CGRectMake(0, buttonY, buttonSize.width, buttonSize.height);
    self.backwardButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin;
    self.backwardButton.backgroundColor = [UIColor grayColor];
    [self.backwardButton setTitle:@"后退" forState:UIControlStateNormal];
    [self.backwardButton addTarget:self action:@selector(onClickedBackwardButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.backwardButton];
    
    self.forwardButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forwardButton.frame = CGRectMake(buttonSize.width, buttonY, buttonSize.width, buttonSize.height);
    self.forwardButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.forwardButton.backgroundColor = [UIColor darkGrayColor];
    [self.forwardButton setTitle:@"前进" forState:UIControlStateNormal];
    [self.forwardButton addTarget:self action:@selector(onClickedForwardButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.forwardButton];
    
    self.refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshButton.frame = CGRectMake(buttonSize.width * 2, buttonY, buttonSize.width, buttonSize.height);
    self.refreshButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.refreshButton.backgroundColor = [UIColor grayColor];
    [self.refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    [self.refreshButton addTarget:self action:@selector(onClickedRefreshButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.refreshButton];
    
    self.goButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goButton.frame = CGRectMake(buttonSize.width * 3, buttonY, buttonSize.width, buttonSize.height);
    self.goButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.goButton.backgroundColor = [UIColor darkGrayColor];
    [self.goButton setTitle:@"前往" forState:UIControlStateNormal];
    [self.goButton addTarget:self action:@selector(onClickedGoButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.goButton];
    
    self.snapshotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.snapshotButton.frame = CGRectMake(buttonSize.width * 4, buttonY, buttonSize.width, buttonSize.height);
    self.snapshotButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    self.snapshotButton.backgroundColor = [UIColor grayColor];
    [self.snapshotButton setTitle:@"截图" forState:UIControlStateNormal];
    [self.snapshotButton addTarget:self action:@selector(onClickedSnapshotButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.snapshotButton];
    
    self.safariButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.safariButton.frame = CGRectMake(buttonSize.width * 5, buttonY, buttonSize.width, buttonSize.height);
    self.safariButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin;
    self.safariButton.backgroundColor = [UIColor darkGrayColor];
    [self.safariButton setTitle:@"Safari" forState:UIControlStateNormal];
    [self.safariButton addTarget:self action:@selector(onClickedSafariButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.safariButton];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 20, CGRectGetWidth(self.view.bounds), 44)];
    self.textField.placeholder = @"http://";
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.textField.delegate = self;
    [self.textField addTarget:self action:@selector(onClickedGoButton:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.view addSubview:self.textField];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSURL *URL = [NSURL URLWithString:@"http://www.qq.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)onClickedBackwardButton:(id)sender {
    [self.webView goBack];
    [self.textField resignFirstResponder];
}

- (void)onClickedForwardButton:(id)sender {
    [self.webView goForward];
    [self.textField resignFirstResponder];
}

- (void)onClickedRefreshButton:(id)sender {
    if (self.webView.isLoading) {
        [self.webView stopLoading];
    }
    else {
        [self.webView reload];
    }
    [self.textField resignFirstResponder];
}

- (void)onClickedGoButton:(id)sender {
    NSString *URLString = self.textField.text;
    if (![URLString hasPrefix:@"http://"]) {
        URLString = [NSString stringWithFormat:@"http://%@", URLString];
    }
    NSURL *URL = [NSURL URLWithString:URLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    [self.webView loadRequest:request];
    
    [self.textField resignFirstResponder];
}

- (void)onClickedSafariButton:(id)sender
{
    SFSafariViewController *vc = [[SFSafariViewController alloc] initWithURL:self.webView.request.URL
                                                     entersReaderIfAvailable:YES];
    [self presentViewController:vc
                       animated:YES
                     completion:NULL];
}

- (void)onClickedSnapshotButton:(id)sender {
//    UIView *snapshotView = [self.webView snapshotViewAfterScreenUpdates:YES];
    
//    UIView *snapshotView = [MttViewSnapshotHelper snapshottedViewFromWebView:self.webView];
    [MttViewSnapshotHelper snapshottedViewFromScrollView:self.webView.scrollView
                                                  inRect:CGRectMake(0, 0, self.webView.scrollView.contentSize.width, self.webView.scrollView.contentSize.height)
                                         completeHandler:^(UIView *snapshotView) {
                                             
                                             NSLog(@"%@", [snapshotView subviews]);
                                             
                                             snapshotView.tag = 10086;
                                             snapshotView.frame = CGRectMake(0, 0, CGRectGetWidth(snapshotView.bounds), CGRectGetHeight(snapshotView.bounds));
                                             snapshotView.hidden = NO;
                                             snapshotView.alpha = 1.0;
                                             
                                             UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
                                             scrollView.backgroundColor = [UIColor blackColor];
                                             scrollView.tag = 1024;
                                             scrollView.minimumZoomScale = 0.1;
                                             scrollView.maximumZoomScale = 10.0;
                                             scrollView.delegate = self;
                                             [scrollView addSubview:snapshotView];
                                             
                                             UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                                             closeButton.backgroundColor = [UIColor redColor];
                                             closeButton.frame = CGRectMake(0, 20, 44, 44);
                                             [closeButton addTarget:self action:@selector(closeSnapShotView:) forControlEvents:UIControlEventTouchUpInside];
                                             [scrollView addSubview:closeButton];
                                             
                                             [self.view addSubview:scrollView];
                                         }];
}

- (void)closeSnapShotView:(id)sender
{
    UIView *view = [self.view viewWithTag:1024];
    if (view) {
        [view removeFromSuperview];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}

#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *URLString = [request.URL absoluteString];
    if ([URLString isEqualToString:self.textField.text]) {
        return NO;
    }
    else {
        self.textField.text = URLString;
        return YES;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self.refreshButton setTitle:@"停止" forState:UIControlStateNormal];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    
    if (webView.canGoBack) {
        [self.backwardButton setTitle:@"<后退" forState:UIControlStateNormal];
    }
    else {
        [self.backwardButton setTitle:@"后退" forState:UIControlStateNormal];
    }
    
    if (webView.canGoForward) {
        [self.forwardButton setTitle:@"前进>" forState:UIControlStateNormal];
    }
    else {
        [self.forwardButton setTitle:@"前进" forState:UIControlStateNormal];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.refreshButton setTitle:@"刷新" forState:UIControlStateNormal];
    
    if (webView.canGoBack) {
        [self.backwardButton setTitle:@"<后退" forState:UIControlStateNormal];
    }
    else {
        [self.backwardButton setTitle:@"后退" forState:UIControlStateNormal];
    }
    
    if (webView.canGoForward) {
        [self.forwardButton setTitle:@"前进>" forState:UIControlStateNormal];
    }
    else {
        [self.forwardButton setTitle:@"前进" forState:UIControlStateNormal];
    }
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return [scrollView viewWithTag:10086];
}

@end
