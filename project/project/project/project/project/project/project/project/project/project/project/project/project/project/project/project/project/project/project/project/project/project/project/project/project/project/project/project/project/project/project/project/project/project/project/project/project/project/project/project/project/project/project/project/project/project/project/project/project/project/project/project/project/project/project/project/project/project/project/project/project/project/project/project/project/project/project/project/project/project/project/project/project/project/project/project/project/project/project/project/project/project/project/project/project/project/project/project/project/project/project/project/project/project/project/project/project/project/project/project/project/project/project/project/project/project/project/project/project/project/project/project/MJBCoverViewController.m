//
//  MJBCoverViewController.m
//  
//
//  Created by Kyuseon on 2015. 5. 18..
//
//

#import "MJBCoverViewController.h"
#import "MJBMainViewController.h"//import the MJBMainViewController

@interface MJBCoverViewController ()

@end

@implementation MJBCoverViewController
@synthesize loginButton;//if you want to transit to ViewController, then make it!!

- (void)viewDidLoad {
    [super viewDidLoad];
    
    mainView=[[MJBMainViewController alloc]init];//alloc the main view
    
    // Do any additional setup after loading the view from its nib.
    loginButton.layer.borderWidth=.5f;
    loginButton.layer.borderColor=[[UIColor redColor]CGColor];
    loginButton.layer.cornerRadius=5;
    loginButton.clipsToBounds=YES;
    
    _facebookButton.layer.borderWidth=.5f;
    _facebookButton.layer.borderColor=[[UIColor blueColor]CGColor];
    _facebookButton.layer.cornerRadius=5;
    _facebookButton.clipsToBounds=YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender{
    [self.view addSubview:mainView.view];//if click the login button, then the MJBMainViewController appear
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
