//
//  MJBViewController.h
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJBDetailViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
@interface MJBViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


//@property (nonatomic, strong) MJBAddInfoViewController *addInfoViewController;
//@property (nonatomic, strong) UINavigationController *navigationController;
@property (nonatomic) UINavigationItem *homeNavItem;
@property (nonatomic, strong) NSMutableData *responseData;
@property NSString *email;
@property NSArray *list;
@property UITableView *book;
@property UIActivityIndicatorView *activityIndicator;
@end
