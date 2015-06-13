//
//  MJBMyInfoViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBMyInfoViewController.h"
#import "MJBAddInfoViewController.h"



NSString *const LogoutSuccessNotification = @"LogoutSuccessNotification";

@interface MJBMyInfoViewController ()
@property (weak, nonatomic) IBOutlet UIButton *sellBookButton;
@property (weak, nonatomic) IBOutlet UIButton *myDealButton;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (nonatomic, readonly) NSString *nickName;

@end

@implementation MJBMyInfoViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    self.IDValueLabel=@"";
    self.userName=@"";
    self.gender=@"";
    self.phoneNumber=@"";
    self.birthday=@"";
    self.email=@"";
    if (self) {
        self.tabBarItem.title = @"마이페이지";
        [self.tabBarItem setImage:[UIImage imageNamed:@"book.png"]];
    }
    
    return self;
}

- (void)viewDidLoad {
    self.isUpdatePhone=false;
    self.responseData=[NSMutableData data];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    __weak MJBMyInfoViewController *weakSelf = self;
    // 현재 로그인된 사용자의 정보를 얻어옴
    if([FBSDKAccessToken currentAccessToken]) {
        FBSDKLoginButton *permission = [[FBSDKLoginButton alloc] init];
        permission.readPermissions=@[@"public_profile", @"email"];
        self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        self.activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
        self.activityIndicator.center = self.view.center;
        [self.view addSubview: self.activityIndicator];
         self.isLoading=true;
        [self.activityIndicator startAnimating];

        [self showProfle];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logoutButtonClicked:(id)sender {
    // 현재 기기에서 로그아웃한다
    if (self.isLoading==false) {
        FBSDKLoginManager *loginManager=[[FBSDKLoginManager alloc]init];
        [loginManager logOut];
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutSuccessNotification object:self];
    }
    
}



- (IBAction)sellBookButtonClicked:(id)sender
{
    if (self.isLoading==false) {
        // 책 판매하기 버튼 눌렀을때 작동하는 부분
        self.sellBookVC = [[MJBSellBookViewController alloc] init];
        self.sellBookVC.user=self.IDValueLabel;
        //    [self displayContentController:_sellBookVC];
        self.sellBookUINavC = [[UINavigationController alloc] initWithRootViewController:self.sellBookVC];
        [self.view.window.rootViewController presentViewController:self.sellBookUINavC animated:YES completion:nil];
    }
    
}

- (IBAction)myDealButtonClicked:(id)sender
{
    if (self.isLoading==false) {
        // 내 거래
        self.myDealVC = [[MJBMyDealViewController alloc] init];
        self.myDealVC.email=self.IDValueLabel;
        self.myDealUINavC = [[UINavigationController alloc] initWithRootViewController:self.myDealVC];
        [self.view.window.rootViewController presentViewController:self.myDealUINavC animated:YES completion:nil];
    }
   
}

- (IBAction)phoneNumberChange:(id)sender
{
    if (self.isLoading==false) {
        //핸드폰 번호 수정 팝업
        self.isPhone=true;
        self.alert = [[UIAlertView alloc] initWithTitle:@"연락처를 수정해주세요" message:@"" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"수정", nil];
        self.alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        self.alertTextField = [self.alert textFieldAtIndex:0];
        //    self.alertTextField.keyboardType = UIKeyboardTypeNumberPad;//일단 에러가 떠서 막아놨어
        self.alertTextField.placeholder = @"01012345678";
        
        [self.alert show];
        
    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0){
        NSLog(@"cancel");
    }else{
        if (self.isPhone==true) {
            self.isUpdatePhone=true;
            self.phoneNumber = [self.alert textFieldAtIndex:0].text;
            [self connectForUpdatePhone:self.IDValueLabel phone:self.phoneNumber];
        }else{
            self.isUpdatePhone=true;
            self.email=[self.alert textFieldAtIndex:0].text;
            [self connectForUpdateEmail:self.IDValueLabel p_email:self.email];
        }
        
        [self.secT reloadData];
    }
}
- (IBAction)emailChange:(id)sender
{
    if (self.isLoading==false) {
        //핸드폰 번호 수정 팝업
        self.isPhone=false;
        
        self.alert = [[UIAlertView alloc] initWithTitle:@"이메일을 수정해주세요" message:@"" delegate:self cancelButtonTitle:@"취소" otherButtonTitles:@"수정", nil];
        self.alert.alertViewStyle = UIAlertViewStylePlainTextInput;
        
        self.alertTextField = [self.alert textFieldAtIndex:0];
        //    self.alertTextField.keyboardType = UIKeyboardTypeNumberPad;//일단 에러가 떠서 막아놨어
        self.alertTextField.placeholder = @"123@naver.com";
        
        [self.alert show];
        
    }
    
}

- (void)showProfle{
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             self.IDValueLabel=[result objectForKey:@"id"];
             self.userName=[result objectForKey:@"name"];
             self.gender=[result objectForKey:@"gender"];
             NSString *pic=[result objectForKey:@"id"];
             NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", pic]];
             NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
             UIImage *fbImage = [UIImage imageWithData:imageData];
             [self.profileImage setImage:fbImage];
             [self connectForPhone:self.IDValueLabel ];
             [self.activityIndicator stopAnimating];
             [self.firstT reloadData];
             [self.secT reloadData];
             self.isLoading=false;
             
         }else{
             NSLog(@"Get FBEmail failed");
         }
     }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.firstT) {
        return 2;
    }else{
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *infoTableIdentifier = @"infoTableCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:infoTableIdentifier];
    

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:infoTableIdentifier];

    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (tableView==self.firstT) {
        if (indexPath.row==0) {
            cell.textLabel.text=[NSString stringWithFormat:@"이름: %@", self.userName];
        }else{
            cell.textLabel.text=[NSString stringWithFormat:@"성별: %@", self.gender];
        }
        
    }else{
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(cell.frame.origin.x + 250, cell.frame.origin.y + 10, 50, 30);
        
        [button setTitle:@"수정" forState:UIControlStateNormal];
        button.backgroundColor= [UIColor whiteColor];
        [button setTag:indexPath.row];
        button.layer.borderWidth=.5f;
        button.layer.borderColor=[[UIColor blueColor]CGColor];
        button.layer.cornerRadius=5;
        button.clipsToBounds=YES;

        if(indexPath.row==0){
            cell.textLabel.text=[NSString stringWithFormat:@"계정: %@", self.IDValueLabel];
             [button setHidden:YES];
        }else if (indexPath.row==1) {
            cell.textLabel.text=[NSString stringWithFormat:@"가입일: %@", self.birthday];
            [button setHidden:YES];
        }else if(indexPath.row==2){
            cell.textLabel.text=[NSString stringWithFormat:@"핸드폰 번호: %@", self.phoneNumber];
            //set the position of the button
            [button addTarget:self action:@selector(phoneNumberChange:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            if (self.email == (id)[NSNull null] || self.email.length == 0) {
                cell.textLabel.text=[NSString stringWithFormat:@"이메일: "];
            } else {
                cell.textLabel.text=[NSString stringWithFormat:@"이메일: %@", self.email];
            }
            
            //set the position of the button
            [button addTarget:self action:@selector(emailChange:) forControlEvents:UIControlEventTouchUpInside];

        }
        [cell.contentView addSubview:button];
    }
       //    cell.textLabel.text = [recipes objectAtIndex:indexPath.row];
    return cell;
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
    UINavigationItem *myInfoNavItem = [[UINavigationItem alloc] init];
    myInfoNavItem.title = @"내 정보";
    [newNavBar setItems:@[myInfoNavItem]];
    [newNavBar setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:141.0f/255.0f blue:192.0f/255.0f alpha:1.0f]];
    [self.view addSubview:newNavBar];
}

- (void)displayContentController:(UIViewController *)content
{
    [self addChildViewController:content];
    content.view.frame = self.view.frame;
    [self.view addSubview:content.view];
    [content didMoveToParentViewController:self];
}
- (void)connectForPhone:(NSString *)email{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/getUser"]];
    
    NSString *getString = [NSString stringWithFormat:@"{\"email\":\"%@\"}", email];
    [request setHTTPBody:[getString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
    }
    else {}
}
- (void)connectForUpdatePhone:(NSString *)email phone:(NSString *)phone{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/updatePhone"]];
    
    NSString *getString = [NSString stringWithFormat:@"{\"email\":\"%@\",\"phone\":\"%@\"}", email,phone];
    [request setHTTPBody:[getString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
    }
    else {}
}
- (void)connectForUpdateEmail:(NSString *)email p_email:(NSString *)p_email{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/updateEmail"]];
    
    NSString *getString = [NSString stringWithFormat:@"{\"email\":\"%@\",\"profileEmail\":\"%@\"}", email,p_email];
    [request setHTTPBody:[getString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"PUT"];
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
    NSLog(@"View: Data Failure");
}

// Following function will show you the result mainly
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"MyInfo: connectionDidFinishLoading");
    //    printf("\nSucceeded! Received %d bytes of data\n",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    ////    // extract specific value...
    if (self.isUpdatePhone==false) {
        id value= [res objectForKey:@"phone"];
        id signData=[res objectForKey:@"Date"];
        id profileEmail=[res objectForKey:@"profileEmail"];
        self.phoneNumber=(NSString *)value;
        self.birthday=(NSString*)signData;
        self.birthday = [[self.birthday componentsSeparatedByString:@"T"] objectAtIndex:0];
        self.email=(NSString*)profileEmail;
        [self.secT reloadData];
    }else{
        self.isUpdatePhone=false;
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
