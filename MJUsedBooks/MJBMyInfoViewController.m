//
//  MJBMyInfoViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBMyInfoViewController.h"
#import "MJBAddInfoViewController.h"



NSString *const LogoutSuccessNotification = @"LogoutSuccessNotification";

@interface MJBMyInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sellBookButton;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumber;
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
//    __weak MJBMyInfoViewController *weakSelf = self;
    // 현재 로그인된 사용자의 정보를 얻어옴
    if([FBSDKAccessToken currentAccessToken]) {
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonClicked:(id)sender {
    // 현재 기기에서 로그아웃한다
    FBSDKLoginManager *loginManager=[[FBSDKLoginManager alloc]init];
    [loginManager logOut];
    [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:self];
    
}



- (IBAction)sellBookButtonClicked:(id)sender
{
    // 책 판매하기 버튼 눌렀을때 작동하는 부분
    self.sellBookVC = [[MJBSellBookViewController alloc] init];
//    [self displayContentController:_sellBookVC];
    self.sellBookUINavC = [[UINavigationController alloc] initWithRootViewController:self.sellBookVC];
    [self.view.window.rootViewController presentViewController:self.sellBookUINavC animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self styleNavBar];
}

- (void)styleNavBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    [newNavBar setTintColor:[UIColor whiteColor]];
    UINavigationItem *myInfoNavItem = [[UINavigationItem alloc] init];
    myInfoNavItem.title = @"내 정보";
    [newNavBar setItems:@[myInfoNavItem]];
    
    [self.view addSubview:newNavBar];
}

- (void)displayContentController:(UIViewController *)content
{
    [self addChildViewController:content];
    content.view.frame = self.view.frame;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
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
