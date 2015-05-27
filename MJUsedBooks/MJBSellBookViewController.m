//
//  MJBSellBookViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 24..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBSellBookViewController.h"

@interface MJBSellBookViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UITextField *bookTitle;
@property (nonatomic, strong) NSMutableData *responseData;
@end

@implementation MJBSellBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.responseData = [NSMutableData data];
    UIImage *defaultImage = [UIImage imageNamed:@"defaultImage.png"];
    _bookImage.image = defaultImage;
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

- (void)styleNavBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    [newNavBar setTintColor:[UIColor blackColor]];
    UINavigationItem *sellBookNavItem = [[UINavigationItem alloc] init];
    sellBookNavItem.title = @"책 판매하기";
    
    UIImage *backButtonImage = [UIImage imageNamed:@"Arrows-Back-icon-3.png"];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    
    sellBookNavItem.leftBarButtonItem = backBarButtonItem;
    
    [newNavBar setItems:@[sellBookNavItem]];
    [self.view addSubview:newNavBar];
}

- (void)backTapped:(id)sender {
//    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)registerButtonClicked:(id)sender
{
    __weak MJBSellBookViewController *weakSelf = self;
    [self connectForBookName:[_bookTitle text] professor:nil courseName:nil user:nil bookStatus:nil price:nil pictureUrl:nil];
    
    [weakSelf alertWithTitle:@"책 등록" message:@"등록을 완료하였습니다"];
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
}

- (void)connectForBookName:(NSString *)bookName professor:(NSString *)professor courseName:(NSString *)courseName user:(NSString *)user bookStatus:(NSString *)bookStatus price:(NSString *)price pictureUrl:(NSString *)pictureUrl
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/postBook"]];
    
    NSString *postString = [NSString stringWithFormat:@"{\"bookName\":\"%@\",\"professor\":\"%@\",\"courseName\":\"%@\",\"user\":\"%@\",\"bookStatus\":\"%@\",\"price\":\"%@\",\"pictureUrl\":\"%@\"}", bookName, professor, courseName, user, bookStatus, price, pictureUrl];
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

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
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
