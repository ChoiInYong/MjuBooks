//
//  MJBFacebookViewController.m
//  project
//
//  Created by Kyuseon on 2015. 5. 21..
//  Copyright (c) 2015년 Kyuseon. All rights reserved.
//

#import "MJBFacebookViewController.h"
//#import "MyTokenCachingStrategy.h"

@interface MJBFacebookViewController ()

@end

@implementation MJBFacebookViewController

- (void)viewDidLoad {
    
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    [self.view addSubview:self.loginButton];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    if ([FBSDKAccessToken currentAccessToken]){
        
        // User is logged in, do work such as go to next view controller.
       
       /* if ([FBSDKAccessToken currentAccessToken]) {
            [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
             startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                 if (!error) {
                     NSString *pic=[result objectForKey:@"id"];
                     NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", pic]];
                     NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
                     UIImage *fbImage = [UIImage imageWithData:imageData];
                     [self.fbImageV setImage:fbImage];
        
                     self.info.text=[result objectForKey:@"email"];
                 }
             }];
        }*/
        
        self.mainView=[[MJBMainViewController alloc]initWithNibName:nil bundle:nil];//alloc the main view
        self.mainView.title=@"메인";
        self.navC=[[UINavigationController alloc]initWithRootViewController:self.mainView];
        
        
        [self.view.window.rootViewController presentViewController:self.navC animated:YES completion:nil];

    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
