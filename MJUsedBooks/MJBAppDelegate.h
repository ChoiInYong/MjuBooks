//
//  MJBAppDelegate.h
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MJBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property MJBLoginViewController *loginViewController;
//@property MJBViewController *mainViewController;
- (void)showLoginView;

- (void)showMainView;

@end

