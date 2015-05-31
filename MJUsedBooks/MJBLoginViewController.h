//
//  MJBLoginViewController.h
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJBAddInfoViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
extern NSString *const LoginSuccessNotification;

@interface MJBLoginViewController : UIViewController
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic, strong) MJBAddInfoViewController *addInfoViewController;
@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property NSString *email;
@property int count;
@end
