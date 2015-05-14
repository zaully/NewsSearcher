//
//  CRWebViewViewController.h
//  newssearch
//
//  Created by Vince Liang on 2015-05-13.
//  Copyright (c) 2015 crowley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CRWebViewViewController : UIViewController <UIWebViewDelegate, UIScrollViewDelegate>
@property (nonatomic, weak)IBOutlet UIWebView *webView;
@property (nonatomic, copy)NSString *urlString;
@property (nonatomic, copy)NSString *htmlString;
@end
