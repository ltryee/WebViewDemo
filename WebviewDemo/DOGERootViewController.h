//
//  DOGERootViewController.h
//  WebviewDemo
//
//  Created by 刘天扬 on 15/7/15.
//  Copyright (c) 2015年 com.text. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DOGERootViewController : UIViewController<UIWebViewDelegate, UITextFieldDelegate>

- (void)openURLString:(NSString *)URLString;

@end

