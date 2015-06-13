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
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"home_filled.png"]];
        [self.tabBarItem setImage:[UIImage imageNamed:@"home.png"]];
        
    }
    
    return self;
}

- (void)viewDidLoad {
    self.list=[[NSArray alloc]init];
    self.responseData = [NSMutableData data];
    self.book=[[UITableView alloc]init];
    self.book = [[UITableView alloc] initWithFrame:CGRectMake(0, 111, 375, 566)];
    self.book.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.book.delegate = self;
    self.book.dataSource = self;
    [self.book setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];    // Do any additional setup after loading the view from its nib.
    
    UILabel *sellLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 75, 375,20)];
    sellLabel.textAlignment=NSTextAlignmentCenter;
    sellLabel.text=@"매      물      리      스      트";
    sellLabel.font = [sellLabel.font fontWithSize:13];
    [self.view addSubview:sellLabel];
    
    UIImageView *first =[[UIImageView alloc] initWithFrame:CGRectMake(0, 95, self.view.frame.size.width, 10)];
    first.image=[UIImage imageNamed:@"horizontal-line-blue.jpg"];
    [self.view addSubview:first];

    
    [self.view addSubview:self.book];
    [super viewDidLoad];
     self.activityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityIndicator.frame = CGRectMake(10.0, 0.0, 40.0, 40.0);
    self.activityIndicator.center = self.view.center;
    [self.view addSubview: self.activityIndicator];
    
    [self.activityIndicator startAnimating];
    
    // 현재 로그인된 사용자의 정보를 얻어옴
    

}

- (void)viewDidAppear:(BOOL)animated{
    [self connectForBookList];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableCell";
    UILabel *titleLabel;
    UILabel *profLabel;
    UILabel *priceLable;
    UILabel *courseLable;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 0, cell.frame.size.width-130, 20)];
        titleLabel.tag = 1;
        titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleLabel];
        
        profLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, 20, cell.frame.size.width-130, 15)];
        profLabel.tag = 2;
        profLabel.font = [UIFont systemFontOfSize:12.0];
        profLabel.backgroundColor = [UIColor clearColor];
        profLabel.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:profLabel];
        
        priceLable = [[UILabel alloc] initWithFrame:CGRectMake(130, 35, cell.frame.size.width-130, 15)];
        priceLable.tag = 3;
        priceLable.font = [UIFont systemFontOfSize:12.0];
        priceLable.backgroundColor = [UIColor clearColor];
        priceLable.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:priceLable];

        courseLable = [[UILabel alloc] initWithFrame:CGRectMake(130, 50, cell.frame.size.width-130, 15)];
        courseLable.tag = 4;
        courseLable.font = [UIFont systemFontOfSize:12.0];
        courseLable.backgroundColor = [UIColor clearColor];
        courseLable.textAlignment=NSTextAlignmentRight;
        [cell.contentView addSubview:courseLable];

    }else{
        titleLabel = (UILabel *)[cell.contentView viewWithTag:1];
        profLabel = (UILabel *)[cell.contentView viewWithTag:2];
        priceLable = (UILabel *)[cell.contentView viewWithTag:3];
        courseLable = (UILabel *)[cell.contentView viewWithTag:4];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *title=[[self.list objectAtIndex:indexPath.row] objectForKey:@"bookName"];
    NSString *prof=[[self.list objectAtIndex:indexPath.row] objectForKey:@"professor"];
    NSString *price=[[self.list objectAtIndex:indexPath.row] objectForKey:@"price"];
    NSString *course=[[self.list objectAtIndex:indexPath.row] objectForKey:@"courseName"];

    titleLabel.text=title;
    profLabel.text=[NSString stringWithFormat:@"교수님: %@ ", prof];
    priceLable.text=[NSString stringWithFormat:@"가격: %@ 원", price];
    courseLable.text=[NSString stringWithFormat:@"과목: %@", course];
    //    cell.textLabel.text=[NSString stringWithFormat:@"책 제목: %@ 가격: %@원", title,price];
//    cell.detailTextLabel.text=[NSString stringWithFormat:@"교수님: %@ 과목: %@", prof, course];
    
    UIImageView *imgView = [[UIImageView alloc] init];
    
    NSString *pic=[[self.list objectAtIndex:indexPath.row] objectForKey:@"pictureUrl"];
    NSURL *pictureURL = [NSURL URLWithString:pic];
    NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
    imgView.image = [UIImage imageWithData:imageData];

    cell.imageView.image = imgView.image;

    CGSize itemSize = CGSizeMake(100, 50);
    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
    [cell.imageView.image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MJBDetailViewController *detailVC = [[MJBDetailViewController alloc] init];
    NSString* temp = [[self.list objectAtIndex:indexPath.row] objectForKey:@"bookId"];
    detailVC.bookId = temp;
    detailVC.email=self.email;
//    UINavigationController *detailUINavC = [[UINavigationController alloc] initWithRootViewController:detailVC];
//    [self presentViewController:detailUINavC animated:YES completion:nil];
    
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
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
    self.homeNavItem = [[UINavigationItem alloc] init];
    self.homeNavItem.title = @"명지대 중고책방";
    [newNavBar setItems:@[self.homeNavItem]];
    [newNavBar setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:141.0f/255.0f blue:192.0f/255.0f alpha:1.0f]];
    [self.view addSubview:newNavBar];
}

- (void)connectForBookList{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/list"]];
    

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
    NSLog(@"View: Data Failure");
}

// Following function will show you the result mainly
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"View: connectionDidFinishLoading");
    //    printf("\nSucceeded! Received %d bytes of data\n",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    ////    // extract specific value...
    
    
    self.list = [res objectForKey:@"books"];
    self.list=[self.list sortedArrayUsingDescriptors: [NSArray arrayWithObjects: [NSSortDescriptor sortDescriptorWithKey:@"bookId" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO], nil]];

    
//    for(id key in res) {
//        
//        id value = [res objectForKey:key];
//        
//        NSString *keyAsString = (NSString *)key;
//        NSString *valueAsString = (NSString *)value;
//        
//        NSLog(@"\nkey: %@", keyAsString);
//        NSLog(@"value: %@", valueAsString);
//    }

    
    [self.book reloadData];
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
