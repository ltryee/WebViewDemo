//
//  ShareViewController.m
//  Share
//
//  Created by 刘天扬 on 16/3/15.
//  Copyright © 2016年 com.text. All rights reserved.
//

#import "ShareViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ShareViewController ()

@end

@implementation ShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadExtensionItem];
    
    [self.extensionContext completeRequestReturningItems:nil completionHandler:NULL];
}

- (void)loadExtensionItem
{
    NSExtensionItem *extensionItem = [self.extensionContext.inputItems firstObject];
    
    __weak __typeof(self) __weak_self = self;
    for(NSItemProvider *itemProvider in [extensionItem attachments]) {
        if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
            [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(id<NSSecureCoding>  _Nullable item, NSError * _Null_unspecified error) {
                
                __typeof(__weak_self) strongSelf = __weak_self;
                
                NSURL *URL = (NSURL *)item;
                if (![URL isFileURL]) {
                    NSString *destURLString = [@"WebViewDemo://" stringByAppendingString:URL.absoluteString];
                    
                    UIResponder* responder = strongSelf;
                    while ((responder = [responder nextResponder]) != nil){
                        if([responder respondsToSelector:@selector(openURL:)] == YES){
                            [responder performSelector:@selector(openURL:) withObject:[NSURL URLWithString:destURLString]];
                        }
                    }
                }
            }];
        }
    }
}

@end
