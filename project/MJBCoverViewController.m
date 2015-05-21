//
//  MJBCoverViewController.m
//  
//
//  Created by Kyuseon on 2015. 5. 18..
//
//

#import "MJBCoverViewController.h"
//#import "MJBMainViewController.h"//import the MJBMainViewController

@interface MJBCoverViewController ()

@end

@implementation MJBCoverViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.loginButton.layer.borderWidth=.5f;
    self.loginButton.layer.borderColor=[[UIColor blueColor]CGColor];
    self.loginButton.layer.cornerRadius=5;
    self.loginButton.clipsToBounds=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender{
    self.faceView=[[MJBFacebookViewController alloc]init];
    [FBSDKLoginButton class];
    [self.view addSubview:self.faceView.view];
    
 
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
