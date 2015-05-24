//
//  MJBLoginViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBLoginViewController.h"

#import <KakaoOpenSDK/KakaoOpenSDK.h>

NSString *const LoginSuccessNotification = @"LoginSuccessNotification";

@interface MJBLoginViewController ()

@end

@implementation MJBLoginViewController

// viewController의 초기화 메소드 재정의
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Login";
    }
    return self;
}

// 뷰컨트롤러가 만들어질 때 loadView메세지를 받음
- (void)loadView {
    [super loadView];
    
//    // logo display
//    UIImage *kakaoLogoImage = [KOImages kakaoLogo];
//    UIImageView *kakaoLogoImageView = [[UIImageView alloc] initWithImage:kakaoLogoImage];
//    kakaoLogoImageView.frame = CGRectMake(0, 0, kakaoLogoImage.size.width, kakaoLogoImage.size.height);
//    kakaoLogoImageView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//    kakaoLogoImageView.center = self.view.center;
//    
//    [self.view addSubview:kakaoLogoImageView];
    
    // 로그인버튼 보여주기
    UIButton *kakaoAccountConnectButton = [self createKakaoAccountConnectButton];
    [self.view addSubview:kakaoAccountConnectButton];
    
}

- (UIButton *)createKakaoAccountConnectButton {
    // button 위치 설정
    int xMargin = 30;
    int marginBottom = 25;
    CGFloat btnWidth = self.view.frame.size.width - xMargin * 2;
    int btnHeight = 42;
    
    UIButton *btnKakaoLogin
    = [[KOLoginButton alloc] initWithFrame:CGRectMake(xMargin, self.view.frame.size.height - btnHeight - marginBottom, btnWidth, btnHeight)];
    btnKakaoLogin.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    // 로그인 버튼 눌렀을 때 action
    [btnKakaoLogin addTarget:self action:@selector(invokeLoginWithTarget:) forControlEvents:UIControlEventTouchUpInside];
    
    return btnKakaoLogin;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

- (IBAction)invokeLoginWithTarget:(id)sender {
    // 현재 세션 정보를 인증 토큰을 제거하여 무효화
    [[KOSession sharedSession] close];
    
    // 기기의 로그인 수행 가능한 카카오 앱에 로그인 요청을 전달한다
    // 내부 블럭은 요청 완료시 실행될 block이며 오류 처리와 로그인 완료 작업을 수행한다
    [[KOSession sharedSession] openWithCompletionHandler:^(NSError *error) {
        // 현재 세션 정보가 인증되어있으면
        if ([[KOSession sharedSession] isOpen]) {
            // 로그인 성공
            NSLog(@"login success.");
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:self];
        } else {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"로그인 실패"
                                                                message:@"로그인 정보를 확인해주세요"
                                                               delegate:nil
                                                      cancelButtonTitle:@"확인"
                                                      otherButtonTitles:nil];
            [alertView show];
        }
        
    }];
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
