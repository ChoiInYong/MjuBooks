//
//  MJBFacebookViewController.m
//  project
//
//  Created by Kyuseon on 2015. 5. 21..
//  Copyright (c) 2015년 Kyuseon. All rights reserved.
//

#import "MJBFacebookViewController.h"


@interface MJBFacebookViewController ()

@end

@implementation MJBFacebookViewController

- (void)viewDidLoad {
    
    self.loginButton.readPermissions = @[@"user_about_me", @"email",@"user_photo"];
    [self.view addSubview:self.loginButton];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
- (void)viewDidAppear:(BOOL)animated{
    
    if ([FBSDKAccessToken currentAccessToken]){
        // User is logged in, do work such as go to next view controller.
        self.mainView=[[MJBMainViewController alloc]initWithNibName:nil bundle:nil];//alloc the main view
        self.mainView.title=@"메인";
        
        self.navC=[[UINavigationController alloc]initWithRootViewController:self.mainView];
        
        [self presentModalViewController:self.navC animated:YES];//if click the login button, then the MJBMainViewController appear
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//- (void)l
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
