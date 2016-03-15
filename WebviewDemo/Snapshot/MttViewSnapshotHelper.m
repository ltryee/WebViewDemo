//
//  MttViewSnapshotHelper.m
//  WebviewDemo
//
//  Created by vectorliu on 16/2/25.
//  Copyright © 2016年 com.text. All rights reserved.
//

#import "MttViewSnapshotHelper.h"

#define MttSnapShotDebug

dispatch_queue_t queue;

void addDebugMark(UIView *onView, NSInteger mark)
{
#if defined(MttSnapShotDebug)
    onView.layer.borderColor = [UIColor redColor].CGColor;
    onView.layer.borderWidth = 1.0;
    UILabel *counterLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    counterLabel.backgroundColor = [UIColor greenColor];
    counterLabel.text = @(mark).stringValue;
    counterLabel.textColor = [UIColor redColor];
    counterLabel.textAlignment = NSTextAlignmentCenter;
    [onView addSubview:counterLabel];
#endif
}

@implementation MttViewSnapshotHelper

+ (UIView *)snapshottedViewFromScrollView:(UIScrollView *)scrollView inRect:(CGRect)snapshotRect completeHandler:(void (^)(UIView * view))completeHandler
{
    queue = dispatch_queue_create("webviewdemo.snapshot", DISPATCH_QUEUE_SERIAL);
    
    CGSize pageSize = CGSizeMake(MIN(CGRectGetWidth(scrollView.frame), CGRectGetWidth(snapshotRect)),
                                 MIN(CGRectGetHeight(scrollView.frame), CGRectGetHeight(snapshotRect))); // 快照宽度不超过应用宽度
    CGPoint savedContentoffset = scrollView.contentOffset;
    CGFloat savedScale = scrollView.zoomScale;
    CGRect savedFrame = scrollView.frame;
    [scrollView setZoomScale:1.0 animated:NO];
    
    UIView *targetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pageSize.width, CGRectGetHeight(snapshotRect))];
    
    CGRect tempScrollViewRect = savedFrame;
    tempScrollViewRect.size.height = snapshotRect.size.height;
    [scrollView setContentOffset:CGPointMake(0, snapshotRect.origin.y) animated:NO];
    
    // 分块截取
    NSInteger step = 0;
    scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(tempScrollViewRect), CGRectGetHeight(tempScrollViewRect));
    
    while (pageSize.height * (step + 1) < CGRectGetHeight(snapshotRect)) {
        
        // 整块的view
            dispatch_sync(queue, ^{
                CGFloat offset = pageSize.height * step + CGRectGetMinX(snapshotRect);
                //        [scrollView setContentOffset:CGPointMake(0, offset) animated:NO];
                
                //            scrollView.frame = CGRectMake(0, 0 - offset, CGRectGetWidth(tempScrollViewRect), CGRectGetHeight(tempScrollViewRect));
                
                //        });
                //
                //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), queue, ^{
                //            CGFloat offset = pageSize.height * step + CGRectGetMinX(snapshotRect);
                UIView *piece = [scrollView resizableSnapshotViewFromRect:CGRectMake(snapshotRect.origin.x,
                                                                                     offset,
                                                                                     pageSize.width,
                                                                                     pageSize.height)
                                                       afterScreenUpdates:YES
                                                            withCapInsets:UIEdgeInsetsZero];
                piece.frame = CGRectMake(0, pageSize.height * step, pageSize.width, pageSize.height);
                [targetView addSubview:piece];
                
                addDebugMark(piece, step);
                NSLog(@"%f",offset);
                
                scrollView.frame = CGRectMake(0,
                                              0 - (pageSize.height * (step + 1) + CGRectGetMinX(snapshotRect)),
                                              CGRectGetWidth(tempScrollViewRect),
                                              CGRectGetHeight(tempScrollViewRect));
                [scrollView setNeedsDisplay];
            });
        
        step++;
    }
    
    // 最后一块
//    dispatch_sync(queue, ^{
//        CGFloat offset = pageSize.height * step + CGRectGetMinX(snapshotRect);
//        //    [scrollView setContentOffset:CGPointMake(0, offset) animated:NO];
//        scrollView.frame = CGRectMake(0, 0 - offset, CGRectGetWidth(tempScrollViewRect), CGRectGetHeight(tempScrollViewRect));
//    });
//    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), queue, ^{
//        CGFloat offset = pageSize.height * step + CGRectGetMinX(snapshotRect);
//        CGFloat height = CGRectGetMaxY(snapshotRect) - offset;
//        UIView *lastPiece = [scrollView resizableSnapshotViewFromRect:CGRectMake(snapshotRect.origin.x,
//                                                                                 offset,
//                                                                                 pageSize.width,
//                                                                                 height)
//                                                   afterScreenUpdates:YES
//                                                        withCapInsets:UIEdgeInsetsZero];
//        lastPiece.frame = CGRectMake(0, pageSize.height * step, pageSize.width, height);
//        [targetView addSubview:lastPiece];
//        
//        addDebugMark(lastPiece, step);
//        NSLog(@"%f",offset);
//    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), queue, ^{
//    dispatch_sync(queue, ^{
        // 主线程回调
        dispatch_async(dispatch_get_main_queue(), ^{
            // 恢复Scroll View
            [scrollView setContentOffset:savedContentoffset animated:NO];
            [scrollView setZoomScale:savedScale animated:NO];
            scrollView.frame = savedFrame;
            
            if (completeHandler) {
                completeHandler(targetView);
            }
        });
    });
    
    return targetView;
}

//+ (UIView *)snapshottedViewFromWebView:(UIWebView *)webview
//{
//    return [[self class] snapshottedViewFromScrollView:webview.scrollView
//                                                inRect:CGRectMake(0,
//                                                                  0,
//                                                                  webview.scrollView.contentSize.width,
//                                                                  webview.scrollView.contentSize.height)];
//}

+ (UIImageView *)snapshottedImageViewFromWebView:(UIWebView *)webview
{
    CGRect savedFrame = webview.scrollView.frame;
    CGPoint savedOffset = webview.scrollView.contentOffset;
    CGSize pageSize = webview.scrollView.contentSize;
    
    webview.scrollView.frame = CGRectMake(0, 0, pageSize.width, pageSize.height);
    [webview.scrollView setContentOffset:CGPointZero animated:NO];
    
    UIGraphicsBeginImageContext(pageSize);
    [webview.scrollView.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    webview.scrollView.frame = savedFrame;
    [webview.scrollView setContentOffset:savedOffset animated:NO];
    
    UIImageView *view = [[UIImageView alloc] initWithImage:image];
    return view;
}

@end
