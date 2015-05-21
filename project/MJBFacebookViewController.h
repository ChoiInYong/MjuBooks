//
//  MJBFacebookViewController.h
//  project
//
//  Created by Kyuseon on 2015. 5. 21..
//  Copyright (c) 2015년 Kyuseon. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJBMainViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>


@interface MJBFacebookViewController : UIViewController

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (nonatomic, strong) MJBMainViewController *mainView;
@property (strong, nonatomic) UINavigationController *navC;
@end
