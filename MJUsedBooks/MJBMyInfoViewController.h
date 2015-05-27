//
//  MJBMyInfoViewController.h
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJBSellBookViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
extern NSString *const LogoutSuccessNotification;

@interface MJBMyInfoViewController : UIViewController

@property (nonatomic, strong) MJBSellBookViewController *sellBookVC;
@property (nonatomic, strong) UINavigationController *sellBookUINavC;

- (IBAction)sellBookButtonClicked:(id)sender;

@end
