//
//  MJBAppDelegate.h
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
@interface MJBAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
//@property MJBLoginViewController *loginViewController;
//@property MJBViewController *mainViewController;
//@property (nonatomic) UILabel *progressLabel;
//@property AWSRegionType const CognitoRegionType;
//@property AWSRegionType const DefaultServiceRegionType;
//@property NSString *const CognitoIdentityPoolId;
//@property NSString *const S3BucketName;
- (void)showLoginView;

- (void)showMainView;

@end

