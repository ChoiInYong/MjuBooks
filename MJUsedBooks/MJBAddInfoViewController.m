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
    self.responseData = [NSMutableData data];
    self.count=0;
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
    if ([self.phoneNumber text].length > 0) {
        properties[@"phone_number"] = [_phoneNumber text];
        if (self.count==0) {
            [self saveUser];
            self.count++;
        }
        [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
        //        MJBMyInfoViewController *myInfoViewController = [[MJBMyInfoViewController alloc] initWithNibName:@"MJBMyInfoViewController" bundle:nil];
        //        [self presentViewController:myInfoViewController animated:YES completion:^(){
        //            NSLog(@"phone number update");
        //        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginSuccessNotification" object:self];
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
    //

}
- (void)saveUser{
    
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.email=[result objectForKey:@"id"];
             [self connectForUser:self.email phone:[self.phoneNumber text]];
         }else{
             NSLog(@"Get FBEmail failed");
         }
     }];
    
}
- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [alert show];
}
- (void)connectForUser:(NSString *)email phone:(NSString *)phone
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/signUp"]];
    
    NSString *postString = [NSString stringWithFormat:@"{\"email\":\"%@\",\"phone\":\"%@\"}", email, phone];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
    }
    else {}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Data Failure");
}

// Following function will show you the result mainly
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    //    printf("\nSucceeded! Received %d bytes of data\n",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"\nkey: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
    
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
