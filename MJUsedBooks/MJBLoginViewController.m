//
//  MJBLoginViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBLoginViewController.h"



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
    self.responseData=[NSMutableData data];
    self.count=0;
//    // logo display
    
    // 로그인버튼 보여주기
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    [self.view setFrame:CGRectMake(35, 600, 300, 50)];
    loginButton.frame=self.view.frame;
    [self.view addSubview:loginButton];
    
    
}


- (void)viewDidLoad {
    
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewDidAppear:) name:UIApplicationDidBecomeActiveNotification object:nil];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        if (self.count==0) {
            UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
            activityIndicator.center = self.view.center;
            [self.view addSubview: activityIndicator];
            
            [activityIndicator startAnimating];
            
            [self checkUser];
            self.count++;
        }
        
//        [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:self];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)checkUser{
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.email=[result objectForKey:@"id"];
             [self connectForUserCheck:self.email];
             
//             NSLog(@"email: %@", self.email);
         }else{
             NSLog(@"Get FBEmail failed");
         }
     }];
    
}
- (void)connectForUserCheck:(NSString *)email{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/userCheck"]];
    
    NSString *getString = [NSString stringWithFormat:@"{\"email\":\"%@\"}", email];
    [request setHTTPBody:[getString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
    }
    else {}
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Login: Data Failure");
}

// Following function will show you the result mainly
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Login: connectionDidFinishLoading");
    //    printf("\nSucceeded! Received %d bytes of data\n",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    ////    // extract specific value...
    
    id value = [res objectForKey:@"check"];
   
    if ((int)value==3) {
        self.addInfoViewController = [[MJBAddInfoViewController alloc] initWithNibName:nil bundle:nil];
        self.addInfoViewController.title = @"추가정보입력";
        self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.addInfoViewController];
        [self.view.window.rootViewController presentViewController:self.navigationController animated:YES completion:^(){NSLog(@"go add page");}];
    }else{
      [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNotification object:self];
        
    }
    
    
    
}

#pragma mark - actions



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
