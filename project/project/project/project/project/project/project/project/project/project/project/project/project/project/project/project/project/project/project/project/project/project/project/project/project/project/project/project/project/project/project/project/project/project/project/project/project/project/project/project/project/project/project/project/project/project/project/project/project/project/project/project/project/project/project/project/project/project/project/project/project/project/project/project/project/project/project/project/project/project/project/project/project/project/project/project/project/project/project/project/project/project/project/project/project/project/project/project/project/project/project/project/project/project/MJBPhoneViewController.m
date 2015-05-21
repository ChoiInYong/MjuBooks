//
//  MJBPhoneViewController.m
//  project
//
//  Created by Kyuseon on 2015. 5. 19..
//  Copyright (c) 2015년 Kyuseon. All rights reserved.
//

#import "MJBPhoneViewController.h"

@interface MJBPhoneViewController ()

@end

@implementation MJBPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _signUpButton.layer.borderWidth=.5f;
    _signUpButton.layer.borderColor=[[UIColor blueColor]CGColor];
    _signUpButton.layer.cornerRadius=5;
    _signUpButton.clipsToBounds=YES;
    
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
