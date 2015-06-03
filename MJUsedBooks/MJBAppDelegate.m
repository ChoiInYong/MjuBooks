//
//  MJBAppDelegate.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBAppDelegate.h"
#import "MJBViewController.h"
#import "MJBLoginViewController.h"
#import "MJBMyInfoViewController.h"
#import "MJBSearchViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <AWSCore.h>
#import <AWSCognito.h>
#import <AWSService.h>

@interface MJBAppDelegate ()
@property MJBLoginViewController *loginViewController;
@end

@implementation MJBAppDelegate

// 로그인 화면 보여주기
- (void)showLoginView {
    [FBSDKLoginButton class];
    self.loginViewController = [[MJBLoginViewController alloc] initWithNibName:nil bundle:nil];
    self.window.rootViewController = self.loginViewController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

// 메인 화면 보여주기
- (void)showMainView {
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    MJBViewController *mainViewController = [[MJBViewController alloc] init];
    MJBMyInfoViewController *myInfoViewController = [[MJBMyInfoViewController alloc] init];
    MJBSearchViewController *searchViewController = [[MJBSearchViewController alloc] init];
    
    mainViewController.email=self.loginViewController.email;
    searchViewController.email=self.loginViewController.email;
//    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    tabBarController.viewControllers = @[mainViewController, searchViewController, myInfoViewController];
    
    self.window.rootViewController = tabBarController;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // 카카오계정의 세션 연결 상태가 변했을 시,
    // Notification 을 kakaoSessionDidChangeWithNotification 메소드에 전달하도록 설정
    
    // name이라는 이름으로 전달된 메세지를 옵저버가 받아서 @selector(함수명)의 함수를 실행시킴
    // 카카오계정의 세션 연결상태
    
    
    // 로그인 화면에서 로그인 완료 메세지를 날리면 메인 화면을 보여주도록 설정
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showMainView)
                                                 name:LoginSuccessNotification
                                               object:nil];
    
    // 메인 화면에서 로그아웃 버튼을 누르면 로그인 화면을 보여주도록 설정
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showLoginView)
                                                 name:LogoutSuccessNotification
                                               object:nil];
    
    
    if ([FBSDKAccessToken currentAccessToken]) {
        [self showMainView];
    } else {
        [self showLoginView];
    }
    
    AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc]
                                                          initWithRegionType:AWSRegionUSEast1
                                                          identityPoolId:@"us-east-1:00c3f914-f438-45b1-8ff4-d255d5fe94c2"];
    
    AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1 credentialsProvider:credentialsProvider];
    AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
    
    
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];
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
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
