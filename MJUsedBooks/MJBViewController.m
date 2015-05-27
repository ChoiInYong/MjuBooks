//
//  MJBViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBViewController.h"


@interface MJBViewController ()

@end

@implementation MJBViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"홈";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // 현재 로그인된 사용자의 정보를 얻어옴
//    [KOSessionTask meTaskWithCompletionHandler:^(KOUser *result, NSError *error) {
//        if ([result propertyForKey:@"phone_number"] == Nil) {
//            self.addInfoViewController = [[MJBAddInfoViewController alloc] initWithNibName:nil bundle:nil];
//            self.addInfoViewController.title = @"추가정보입력";
//            self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.addInfoViewController];
//            [self.view.window.rootViewController presentViewController:self.navigationController animated:YES completion:^(){
//                NSLog(@"go add page");
//            }];
//        }
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    _homeNavItem = [[UINavigationItem alloc] init];
    _homeNavItem.title = @"명지대 중고책방";
    [newNavBar setItems:@[_homeNavItem]];
    
    [self.view addSubview:newNavBar];
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
