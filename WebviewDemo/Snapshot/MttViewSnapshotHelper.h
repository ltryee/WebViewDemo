//
//  MttViewSnapshotHelper.h
//  WebviewDemo
//
//  Created by 刘天扬 on 16/2/25.
//  Copyright © 2016年 com.text. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MttViewSnapshotHelper : NSObject

+ (UIView *)snapshottedViewFromScrollView:(UIScrollView *)scrollView inRect:(CGRect)snapshotRect completeHandler:(void (^)(UIView * view))completeHandler;
//+ (UIView *)snapshottedViewFromWebView:(UIWebView *)webview;
+ (UIImageView *)snapshottedImageViewFromWebView:(UIWebView *)webview;

@end
