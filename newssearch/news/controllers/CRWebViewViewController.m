//
//  CRWebViewViewController.m
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import "CRWebViewViewController.h"
#import "GTScrollNavigationBar.h"

@interface CRWebViewViewController ()

@end

@implementation CRWebViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*
     some logic to load correct html string. if string is not present, load it from the url
     */
    self.webView.delegate = self;
    if (!self.htmlString) {
        if ([self.urlString rangeOfString:@"http://"].location == NSNotFound) {
            self.urlString = [NSString stringWithFormat:@"http://%@", self.urlString];
        }
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    } else {
        [self.webView loadHTMLString:self.htmlString baseURL:[NSURL URLWithString:self.urlString]];
    }
    self.webView.scrollView.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.scrollNavigationBar.scrollView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.navigationController.scrollNavigationBar.scrollView = self.webView.scrollView;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[[UIAlertView alloc]
      initWithTitle:NSLocalizedString(@"Error", nil)
      message:NSLocalizedString(error.localizedDescription, nil)
      delegate:nil
      cancelButtonTitle:NSLocalizedString(@"Okay", nil)
      otherButtonTitles: nil] show];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self.navigationController.scrollNavigationBar resetToDefaultPositionWithAnimation:NO];
}

@end
