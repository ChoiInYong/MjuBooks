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


- (void)viewDidLoad {
//    NSLog(@"myDealView: viewDidLoad Calling");
    self.isPhone=false;
    self.myList=[[NSArray alloc]init];
    self.mySList=[[NSMutableArray alloc]init];
    self.myBList=[[NSMutableArray alloc]init];
    self.mySBList=[[NSMutableArray alloc]init];
    self.responseData=[NSMutableData data];
    self.temp=[[NSArray alloc]init];
    [self.myTableV setBackgroundColor:[UIColor colorWithWhite: 0.90 alpha:1]];
    
    //segemented Style
    self.segmentedControl.layer.cornerRadius=0.0;
    self.segmentedControl.layer.borderWidth=1;
    self.segmentedControl.layer.borderColor = [[UIColor whiteColor]CGColor];
    [self.segmentedControl setTintColor:[UIColor whiteColor]];
    [self.segmentedControl setTitleTextAttributes:
  @{NSForegroundColorAttributeName:[UIColor colorWithRed:90.0f/255.0f green:141.0f/255.0f blue:192.0f/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [self.segmentedControl setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]} forState:UIControlStateSelected];
    
    [self.sec setHidden:YES];
    [self.third setHidden:YES];
    
    [super viewDidLoad];
    [self connectForMyList:self.email];
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
            [self.first setHidden:NO];
            [self.sec setHidden:YES];
            [self.third setHidden:YES];
            self.temp=self.mySList;
            break;
            //buy
        case 1:
            [self.first setHidden:YES];
            [self.sec setHidden:NO];
            [self.third setHidden:YES];
            self.temp=self.myBList;
            break;
            //successList
        case 2:
            [self.first setHidden:YES];
            [self.sec setHidden:YES];
            [self.third setHidden:NO];
            self.temp=self.mySBList;
            break;
        default:
            break;
    }
    [self.myTableV reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.segmentedControl.selectedSegmentIndex==0) {
        return [self.mySList count];
    }else if(self.segmentedControl.selectedSegmentIndex==1){
        return [self.myBList count];
    }else{
        return [self.mySBList count];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DealCell = @"DealCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:DealCell];
    

    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:DealCell];

    
    // Display recipe in the table cell
   
    
    cell.textLabel.text=[[self.temp objectAtIndex:indexPath.row] objectForKey:@"bookName"];
    
    NSString *prof=[[self.temp objectAtIndex:indexPath.row] objectForKey:@"professor"];
    NSString *price=[[self.temp objectAtIndex:indexPath.row] objectForKey:@"price"];
    NSString *course=[[self.temp objectAtIndex:indexPath.row] objectForKey:@"courseName"];
    cell.detailTextLabel.text=[NSString stringWithFormat:@"교수님: %@ 과목: %@ 가격: %@원", prof, course,price];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    NSString *pic=[[self.temp objectAtIndex:indexPath.row] objectForKey:@"pictureUrl"];
    NSURL *pictureURL = [NSURL URLWithString:pic];
    NSData *imageData = [NSData dataWithContentsOfURL:pictureURL];
    imgView.image = [UIImage imageWithData:imageData];
    cell.imageView.image = imgView.image;
    [cell setBackgroundColor:[UIColor colorWithWhite: 0.90 alpha:1]];
    
    //    cell.textLabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"professor"];
    if (self.segmentedControl.selectedSegmentIndex==2) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        
        //set the position of the button
        button.frame = CGRectMake(cell.frame.origin.x + 300, cell.frame.origin.y + 10, 50, 30);
        
        [button setTitle:@"번호" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showNumber:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor= [UIColor whiteColor];
        [button setTag:indexPath.row];
        button.layer.borderWidth=.5f;
        button.layer.borderColor=[[UIColor blueColor]CGColor];
        button.layer.cornerRadius=5;
        button.clipsToBounds=YES;
        [cell.contentView addSubview:button];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.accessoryType=UITableViewCellAccessoryNone;
        
    }else{
        if (self.segmentedControl.selectedSegmentIndex==0){
            UILabel *statLabel =
            [[UILabel alloc] initWithFrame:CGRectMake(cell.frame.origin.x + 290, cell.frame.origin.y + 11, 60, 30)];
            [statLabel setTag: indexPath.row];
            statLabel.font = [UIFont systemFontOfSize:14.0];
            statLabel.textColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
            if([[[self.temp objectAtIndex:indexPath.row] objectForKey:@"decision"] intValue]==0) {
                statLabel.text=@"판매중";
            }else{
                statLabel.text=@"판매요청";
            }
            [cell.contentView addSubview:statLabel];
        }
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
- (void)showNumber:(id)sender{
    NSIndexPath *index = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
    NSString *seller=[[self.temp objectAtIndex:index.row] objectForKey:@"seller"];
    NSString *buyer=[[self.temp objectAtIndex:index.row] objectForKey:@"buyer"];
    self.isPhone=true;
    if ([self.email isEqualToString:seller]) {
        [self connectForPhone:buyer];
    }else{
        [self connectForPhone:seller];
    }
}
- (void)showAlert:(NSString*)phoneNum{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"상대방 번호 입니다" message:phoneNum delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    
    [alert show];
}
- (void)connectForMyList:(NSString*)email{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/myList"]];
    
    NSString *getString = [NSString stringWithFormat:@"{\"email\":\"%@\"}", email];
    [request setHTTPBody:[getString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
    }
    else {}
}

- (void)connectForPhone:(NSString *)email{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/getPhoneNumber"]];
    
    NSString *getString = [NSString stringWithFormat:@"{\"email\":\"%@\"}", email];
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
    NSLog(@"MyDealView: Data Failure");
}

// Following function will show you the result mainly
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"MyDealView: connectionDidFinishLoading");
    //    printf("\nSucceeded! Received %d bytes of data\n",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    ////    // extract specific value...
    
    if (self.isPhone==true) {
        NSString* phoneNum=(NSString *)[res objectForKey:@"phone"];
        [self showAlert:phoneNum];
        self.isPhone=false;
    }else{
        
        self.myList=[res objectForKey:@"books"];
        self.myList=[self.myList sortedArrayUsingDescriptors: [NSArray arrayWithObjects: [NSSortDescriptor sortDescriptorWithKey:@"bookId" ascending:NO], [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO], nil]];
        [self classify];
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

    

    
   
    
}
//classify recieved array
- (void)classify{
    for (int i=0; i<[self.myList count]; i++) {
        NSString *sellerString=[[self.myList objectAtIndex:i] objectForKey:@"seller"];
        if([[[self.myList objectAtIndex:i] objectForKey:@"decision"]intValue]==2){
            [self.mySBList addObject:[self.myList objectAtIndex:i]];
        }else{
            if([self.email isEqualToString:sellerString]==true){
                [self.mySList addObject:[self.myList objectAtIndex:i]];
            }else{
                [self.myBList addObject:[self.myList objectAtIndex:i]];
            }
        }

    }
    self.temp=self.mySList;
    [self.myTableV reloadData];
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
