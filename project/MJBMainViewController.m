//
//  MJBMainViewController.m
//  project
//
//  Created by Kyuseon on 2015. 5. 19..
//  Copyright (c) 2015년 Kyuseon. All rights reserved.
//

#import "MJBMainViewController.h"

@interface MJBMainViewController ()

@end

@implementation MJBMainViewController


- (void)viewDidLoad {
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Log Out" style:UIBarButtonItemStyleDone target:self action:@selector(back:)];
    [super viewDidLoad];    
    // Do any additional setup after loading the view from its nib.
       
}






- (void)back:(id)sender{
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
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
