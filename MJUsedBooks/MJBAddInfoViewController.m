//
//  MJBAddInfoViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 24..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBAddInfoViewController.h"
#import "MJBMyInfoViewController.h"



@interface MJBAddInfoViewController ()
//@property (weak, nonatomic) IBOutlet UINavigationBar *addInfoNavi;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumber;

@end

@implementation MJBAddInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
//        self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleBordered target:nil action:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)saveButtonClicked:(id)sender
{
    __weak MJBAddInfoViewController *weakSelf = self;
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    if ([_phoneNumber text].length > 0) {
        properties[@"phone_number"] = [_phoneNumber text];
    } else {
        [weakSelf alertWithTitle:@"오류" message:@"휴대폰 번호를 입력해주세요"];
    }
    
//    [KOSessionTask profileUpdateTaskWithProperties:properties completionHandler:^(BOOL success, NSError *error) {
//        if (success) {
//            [weakSelf alertWithTitle:@"update" message:@"성공적으로 저장되었습니다"];
//        } else {
//            [weakSelf alertWithTitle:@"update" message:@"저장하는데 실패하였습니다"];
//            NSLog(@"%@", error);
//        }
//    }];
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
//
//    MJBMyInfoViewController *myInfoViewController = [[MJBMyInfoViewController alloc] initWithNibName:@"MJBMyInfoViewController" bundle:nil];
//    [self presentViewController:myInfoViewController animated:YES completion:^(){
//        NSLog(@"phone number update");
//    }];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
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
