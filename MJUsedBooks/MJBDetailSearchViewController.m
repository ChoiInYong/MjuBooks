//
//  MJBDetailSearchViewController.m
//  MJUsedBooks
//
//  Created by Kyuseon on 2015. 5. 31..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBDetailSearchViewController.h"

@interface MJBDetailSearchViewController ()

@end

@implementation MJBDetailSearchViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"검색";
        [self.tabBarItem setImage:[UIImage imageNamed:@"search.png"]];
    }
    return self;
}
- (void)viewDidLoad {
    self.emptyView=[[UIView alloc]init];
    self.emptyLabel=[[UILabel alloc]init];
    self.emptyLabel.text=@"판매중인 책이 없어요ㅠㅠ";
    self.responseData=[NSMutableData data];
    self.detailList=[[NSArray alloc]init];
    self.detailSearchList=[[UITableView alloc]init];
    self.detailSearchList = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, 373, 630)];
    self.detailSearchList.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.detailSearchList.delegate = self;
    self.detailSearchList.dataSource = self;
    [self.view addSubview:self.detailSearchList];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    if (self.isProf==true) {
        [self connectForDetailPBookList:self.name];
    }else{
        [self connectForDetailCBookList:self.name];
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.detailList count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *SimpleCell = @"DetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SimpleCell];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:SimpleCell];
    }

    
    // Display recipe in the table cell
    
    
    cell.textLabel.text=[[self.detailList objectAtIndex:indexPath.row] objectForKey:@"bookName"];
    
    NSString *prof=[[self.detailList objectAtIndex:indexPath.row] objectForKey:@"professor"];
    NSString *price=[[self.detailList objectAtIndex:indexPath.row] objectForKey:@"price"];
    NSString *course=[[self.detailList objectAtIndex:indexPath.row] objectForKey:@"courseName"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"교수님: %@ 과목: %@ 가격: %@원", prof, course,price];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    NSString *pic=[[self.detailList objectAtIndex:indexPath.row] objectForKey:@"pictureUrl"];
    NSURL *pictureURL = [NSURL URLWithString:pic];
    NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
    imgView.image = [UIImage imageWithData:imageData];
    cell.imageView.image = imgView.image;

    
    //    cell.textLabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"professor"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
    [newNavBar setTintColor:[UIColor blackColor]];
    UINavigationItem *detailNavItem = [[UINavigationItem alloc] init];
    detailNavItem.title = @"검색";
    
    UIImage *backButtonImage = [UIImage imageNamed:@"Arrows-Back-icon-3.png"];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStyleBordered target:self action:@selector(backTapped:)];
    
    detailNavItem.leftBarButtonItem = backBarButtonItem;

    [newNavBar setItems:@[detailNavItem]];
    
    [self.view addSubview:newNavBar];
    
}
- (void)backTapped:(id)sender {
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
}
- (void)connectForDetailPBookList:(NSString *)professor{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/findProfessor"]];
    
    
    NSString *getString = [NSString stringWithFormat:@"{\"professor\":\"%@\"}", professor];
    [request setHTTPBody:[getString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    NSLog(@"%@",professor);
    if (connection) {
    }
    else {}
}
- (void)connectForDetailCBookList:(NSString *)courseName{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/findCourseName"]];
    
    
    NSString *getString = [NSString stringWithFormat:@"{\"courseName\":\"%@\"}", courseName];
    [request setHTTPBody:[getString dataUsingEncoding:NSUTF8StringEncoding]];
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
    NSLog(@"DetailSearch: Data Failure");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"DetailSearch: connectionDidFinishLoading");
    //    printf("\nSucceeded! Received %d bytes of data\n",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    ////    // extract specific value...
    
    
    self.detailList = [res objectForKey:@"books"];
    
    self.detailList=[self.detailList sortedArrayUsingDescriptors: [NSArray arrayWithObjects: [NSSortDescriptor sortDescriptorWithKey:@"bookId" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO], nil]];
        if ([self.detailList count]==0) {
            [self.detailSearchList setHidden:YES];
            [self.emptyView setFrame:CGRectMake(0, 50, 373, 630)];
            [self.emptyLabel setFrame:CGRectMake(100, 580/2, 200, 10)];
            [self.emptyView addSubview:self.emptyLabel];
            [self.view addSubview:self.emptyView];
        }else{
            [self.detailSearchList reloadData];
        }
    
    
//        for(id key in res) {
//    
//            id value = [res objectForKey:key];
//    
//            NSString *keyAsString = (NSString *)key;
//            NSString *valueAsString = (NSString *)value;
//    
//            NSLog(@"\nkey: %@", keyAsString);
//            NSLog(@"value: %@", valueAsString);
//        }
    
    
    
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
