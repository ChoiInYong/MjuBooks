//
//  MJBMyDealViewController.m
//  MJUsedBooks
//
//  Created by 5407-04 on 2015. 5. 29..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBMyDealViewController.h"

@interface MJBMyDealViewController ()

@end

@implementation MJBMyDealViewController
@synthesize sellView, buyView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    [self styleNavBar];
}

- (IBAction)segmentedValueChanged:(UISegmentedControl *)sender
{
    switch (sender.selectedSegmentIndex) {
            //sell
        case 0:
            self.sellView.hidden = NO;
            self.buyView.hidden = YES;
            break;
            //buy
        case 1:
            self.sellView.hidden = YES;
            self.buyView.hidden = NO;
            break;
            
        default:
            break;
    }
}

- (void)styleNavBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    [newNavBar setTintColor:[UIColor blackColor]];
    UINavigationItem *myDealNavItem = [[UINavigationItem alloc] init];
    myDealNavItem.title = @"내 거래";
    
    UIImage *backButtonImage = [UIImage imageNamed:@"Arrows-Back-icon-3.png"];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    
    myDealNavItem.leftBarButtonItem = backBarButtonItem;
    
    [newNavBar setItems:@[myDealNavItem]];
    [self.view addSubview:newNavBar];
}

- (void)backTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
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
