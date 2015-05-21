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
@synthesize mainView, navC, loginButton;//if you want to transit to ViewController, then make it!!




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    loginButton.layer.borderWidth=.5f;
    loginButton.layer.borderColor=[[UIColor blueColor]CGColor];
    loginButton.layer.cornerRadius=5;
    loginButton.clipsToBounds=YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)login:(id)sender{
    mainView=[[MJBMainViewController alloc]initWithNibName:nil
                                                     bundle:nil];//alloc the main view
    self.mainView.title=@"메인";
    
    self.navC=[[UINavigationController alloc]initWithRootViewController:self.mainView];
    
    [self presentModalViewController:self.navC animated:YES];//if click the login button, then the MJBMainViewController appear
    
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
