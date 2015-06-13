//
//  MJBDetailViewController.m
//  MJUsedBooks
//
//  Created by 5407-04 on 2015. 6. 3..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBDetailViewController.h"

@interface MJBDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *bookStatus;
@end

@implementation MJBDetailViewController


- (void)viewDidLoad {
    self.areYouSeller=false;
    self.responseData = [NSMutableData data];
    
    //[self.button setTitle:@"구매하기" forState:UIControlStateNormal];
    
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

- (void)viewDidAppear:(BOOL)animated
{
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
    self.activityIndicator.center = self.view.center;
    [self.view addSubview: self.activityIndicator];
    
    [self.activityIndicator startAnimating];

    [self connectForDetail:self.bookId];
}

- (IBAction)buttonClicked:(id)sender
{
    NSError *error = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    
    id butt = [res objectForKey:@"decision"];
    NSNumber *num;
    num = (NSNumber *)butt;
    int intnum = [num intValue];
    
    if (intnum == 0){
        if (self.areYouSeller==false) {
            [self connectForBuy:self.bookId email:self.email];
            [self.button setTitle:@"구매자 대기" forState:UIControlStateNormal];
            [self alert:@"구매요청을 완료되었습니다"];
            [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
            
        }
    } else if (intnum == 1){
        if (self.areYouBuyer==false) {
            [self connectForSell:self.bookId ];
            [self.button setTitle:@"거래 완료" forState:UIControlStateNormal];
            [self alert:@"거래가 완료되었습니다."];
            [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
        }
    }
    
    
}
- (void)alert:(NSString*)msg{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:@"내거래에서 확인해 주세요" delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    
    [alert show];
}
- (void)styleNavBar
{
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    [newNavBar setTintColor:[UIColor blackColor]];
    UINavigationItem *sellBookNavItem = [[UINavigationItem alloc] init];
    sellBookNavItem.title = @"상세정보";
    
    UIImage *backButtonImage = [UIImage imageNamed:@"Arrows-Back-icon-3.png"];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    
    sellBookNavItem.leftBarButtonItem = backBarButtonItem;
    
    [newNavBar setItems:@[sellBookNavItem]];
    [newNavBar setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:141.0f/255.0f blue:192.0f/255.0f alpha:1.0f]];
    [self.view addSubview:newNavBar];
}

- (void)backTapped:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
    [self.navigationController popViewControllerAnimated:YES];
}

//Detail
- (void)connectForDetail:(NSString *)bkid
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/detail"]];
    
    NSString *getString = [NSString stringWithFormat:@"{\"bookId\":\"%@\"}", bkid];
    
    [request setHTTPBody:[getString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection){
    } else {}
}

//구매상태 - 구매자가 구매하기 눌렀을 때
- (void)connectForBuy:(NSString *)bkid email:(NSString *)email
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/buy"]];
    
    //
    NSString *getString = [NSString stringWithFormat:@"{\"bookId\":\"%@\",\"email\":\"%@\"}",bkid, email];
    [request setHTTPBody:[getString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection){
    } else {}
}

//구매상태 - 판매자가 판매완료 눌렀을 때
- (void)connectForSell:(NSString *)bkid
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/sell"]];
    
    //
    NSString *getString = [NSString stringWithFormat:@"{\"bookId\":\"%@\"}", bkid];
    [request setHTTPBody:[getString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"PUT"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection){
    } else {}
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"detailView: connectionDidFinishLoading");
    
    NSError *error = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&error];
    
    id name = [res objectForKey:@"bookName"];
    self.bookName.text = (NSString *)name;
    
    id status = [res objectForKey:@"bookStatus"];
    self.bookStatus.text = (NSString *)status;
    
    id course = [res objectForKey:@"courseName"];
    self.courseName.text = (NSString *)course;
    
    id prof = [res objectForKey:@"professor"];
    self.professor.text = (NSString *)prof;
    
    id cost = [res objectForKey:@"price"];
    self.price.text = (NSString *)cost;
    
    id seller=[res objectForKey:@"seller"];
    NSString *sellerP=(NSString *)seller;
    
    id buyer=[res objectForKey:@"buyer"];
    NSString *buyerP=(NSString*)buyer;
    
    NSString *pic=[res objectForKey:@"pictureUrl"];
    NSURL *pictureURL = [NSURL URLWithString:pic];
    NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
    self.picture.image = [UIImage imageWithData:imageData];
    
    //Button
    id butt = [res objectForKey:@"decision"];
    
    NSNumber *num;
    num = (NSNumber *)butt;
    int intnum = [num intValue];
    
    if (intnum == 0){
        [self.button setTitle:@"구매하기" forState:UIControlStateNormal];
        if ([sellerP isEqualToString:self.email]) {
            self.areYouSeller=true;
            [self.button setBackgroundColor:[UIColor colorWithWhite: 0.70 alpha:1]];
        }
    } else if (intnum == 1) {
        [self.button setTitle:@"구매자 대기" forState:UIControlStateNormal];
        if ([buyerP isEqualToString:self.email]) {
            self.areYouBuyer=true;
            [self.button setBackgroundColor:[UIColor colorWithWhite: 0.70 alpha:1]];
        }
    } else if (intnum == 2) {
        [self.button setTitle:@"거래 완료" forState:UIControlStateNormal];
    }
    [self.activityIndicator stopAnimating];
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
