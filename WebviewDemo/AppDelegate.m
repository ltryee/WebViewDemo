//
//  AppDelegate.m
//  WebviewDemo
//
//  Created by 刘天扬 on 15/7/15.
//  Copyright (c) 2015年 com.text. All rights reserved.
//

#import "AppDelegate.h"
#import "DOGERootViewController.h"
#import <JSPatch/JPEngine.h>

@interface AppDelegate ()

@property (nonatomic, strong) DOGERootViewController *vc;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [JPEngine startEngine];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    DOGERootViewController *vc = [[DOGERootViewController alloc] init];
    self.window.rootViewController = vc;
    self.vc = vc;
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    NSURL *URL = [NSURL URLWithString:@"http://stdl.qq.com/stdl/ipadcover/development/demo_patch.js"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//    NSURLResponse * response = nil;
    NSError * error = nil;
//    NSData *data =[NSURLConnection sendSynchronousRequest:request
//                                        returningResponse:&response
//                                                    error:&error];
    NSString *remoteScript = [NSString stringWithContentsOfURL:URL
                                                    encoding:NSUTF8StringEncoding
                                                       error:&error];
    NSLog(@"remote script:\n%@", remoteScript);
    [JPEngine evaluateScript:remoteScript];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSString *urlString = url.absoluteString;
    NSString *identifier = @"WebViewDemo://";
    if ([urlString hasPrefix:identifier]) {
        urlString = [urlString substringFromIndex:identifier.length];
        [self.vc openURLString:urlString];
        return YES;
    }
    
    return NO;
}

@end
