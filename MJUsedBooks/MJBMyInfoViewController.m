//
//  MJBMyInfoViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBMyInfoViewController.h"
#import "MJBAddInfoViewController.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

NSString *const LogoutSuccessNotification = @"LogoutSuccessNotification";

@interface MJBMyInfoViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *IDValueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic, readonly) NSString *nickName;

@end

@implementation MJBMyInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.tabBarItem.title = @"마이페이지";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    __weak MJBMyInfoViewController *weakSelf = self;
    // 현재 로그인된 사용자의 정보를 얻어옴
    [KOSessionTask meTaskWithCompletionHandler:^(KOUser *result, NSError *error) {
        [weakSelf showProfile:result];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonClicked:(id)sender {
    // 현재 기기에서 로그아웃한다
    [[KOSession sharedSession] logoutAndCloseWithCompletionHandler:^(BOOL success, NSError *error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:self];
    }];
}

- (void)showProfile:(KOUser *)profile {
    
    NSString *imageURL;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        imageURL = [profile propertyForKey:@"thumbnail_image"];
    } else {
        imageURL = [profile propertyForKey:@"profile_image"];
    }
    
    [_IDValueLabel setText:profile.ID.stringValue];
    [_userName setText:[profile propertyForKey:@"nickname"]];
    if ([imageURL isKindOfClass:[NSString class]]) {
        [_profileImage setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]]]];
    }

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
