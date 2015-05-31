//
//  MJBMyInfoViewController.h
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJBSellBookViewController.h"
#import "MJBMyDealViewController.h"
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
extern NSString *const LogoutSuccessNotification;

@interface MJBMyInfoViewController : UIViewController

@property (nonatomic, strong) MJBSellBookViewController *sellBookVC;
@property (nonatomic, strong) UINavigationController *sellBookUINavC;
@property (nonatomic, strong) MJBMyDealViewController *myDealVC;
@property (nonatomic, strong) UINavigationController *myDealUINavC;
@property (nonatomic, strong) NSMutableData *responseData;
@property UITextField * alertTextField;
@property UIAlertView *alert;
@property BOOL isUpdatePhone;
- (IBAction)sellBookButtonClicked:(id)sender;
- (IBAction)myDealButtonClicked:(id)sender;

- (IBAction)phoneNumberChange:(id)sender;

@end
