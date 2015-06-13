//
//  MJBSearchViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBSearchViewController.h"

@interface MJBSearchViewController ()

@end

@implementation MJBSearchViewController

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
    self.isProf=true;
    self.responseData = [NSMutableData data];
    self.list=[[NSArray alloc]init];
    
    
    //tableview
    self.searchList=[[UITableView alloc]init];
    self.searchList = [[UITableView alloc] initWithFrame:CGRectMake(0, 145, self.view.frame.size.width, self.view.frame.size.height)];
    self.searchList.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.searchList.delegate = self;
    self.searchList.dataSource = self;
    [self.view addSubview:self.searchList];
    
    //create an intialize our segmented control
    self.mySegmentedControl = [[UISegmentedControl alloc]initWithFrame:CGRectMake(0,109, self.view.frame.size.width, 30)];
    [self.mySegmentedControl insertSegmentWithTitle:@"교수명" atIndex:0 animated:true];
    [self.mySegmentedControl insertSegmentWithTitle:@"강좌명" atIndex:1 animated:true];
    //default the selection to second item
    [self.mySegmentedControl setSelectedSegmentIndex:0];
    [self.mySegmentedControl addTarget:self
                                action:@selector(whichOne)
                      forControlEvents:UIControlEventValueChanged];
    
    //sege style
    self.mySegmentedControl.layer.cornerRadius=0.0;
    self.mySegmentedControl.layer.borderWidth=1;
    self.mySegmentedControl.layer.borderColor = [[UIColor whiteColor]CGColor];
    [self.mySegmentedControl setTintColor:[UIColor whiteColor]];
    [self.mySegmentedControl setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:90.0f/255.0f green:141.0f/255.0f blue:192.0f/255.0f alpha:1.0f]} forState:UIControlStateNormal];
    [self.mySegmentedControl setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f]} forState:UIControlStateSelected];
    
//    [self.mySegmentedControl setAction];
   
    //search bar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 65, self.view.frame.size.width,44)];
    self.searchBar.delegate = self;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    
    //design
    self.first =[[UIImageView alloc] initWithFrame:CGRectMake(0, 139, self.view.frame.size.width/2, 10)];
    self.first.image=[UIImage imageNamed:@"horizontal-line-blue.jpg"];
    [self.view addSubview:self.first];
    
    self.sec =[[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, 139, self.view.frame.size.width/2, 10)];
    self.sec.image=[UIImage imageNamed:@"horizontal-line-blue.jpg"];
    [self.view addSubview:self.sec];
    [self.sec setHidden:YES];
    //set
//    self.searchList.tableHeaderView=self.mySegmentedControl;
    [self.view addSubview:self.mySegmentedControl];
    [self.view addSubview:self.searchBar];
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [self connectForSearchList];
}
- (void) whichOne{
    
    //check if its the same control that triggered the change event
    if (self.mySegmentedControl.selectedSegmentIndex==0) {
        [self.first setHidden:NO];
        [self.sec setHidden:YES];
        self.isProf=true;
        self.list=[self.list sortedArrayUsingDescriptors: [NSArray arrayWithObjects: [NSSortDescriptor sortDescriptorWithKey:@"professor" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO], nil]];
    }else{
        [self.first setHidden:YES];
        [self.sec setHidden:NO];
        self.isProf=false;
        self.list=[self.list sortedArrayUsingDescriptors: [NSArray arrayWithObjects: [NSSortDescriptor sortDescriptorWithKey:@"courseName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO], nil]];
    }
    [self.searchList reloadData];
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate;
    if (self.isProf==true) {
        resultPredicate = [NSPredicate predicateWithFormat:@"professor CONTAINS[cd] %@", searchText];
    }else{
        resultPredicate = [NSPredicate predicateWithFormat:@"courseName CONTAINS[cd] %@", searchText];
    }
    self.searchResults = [self.list filteredArrayUsingPredicate:resultPredicate];
//     NSLog(@"find %@ using predicate", self.searchResults);
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchResults count];
    } else {
        return [self.list count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CustomTableCell";
    UITableViewCell *cell = [self.searchList dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Display recipe in the table cell
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if (self.isProf==true) {
            cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"professor"];
        }else{
            cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"courseName"];
        }
        
    }else {
        if (self.isProf==true) {
            cell.textLabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"professor"];
        }else{
            cell.textLabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"courseName"];
        }
    }

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"cell tapped");
    self.detail=[[MJBDetailSearchViewController alloc]init];
    self.myDetailUINavC = [[UINavigationController alloc] initWithRootViewController:self.detail];
    self.detail.isProf=self.isProf;
    self.detail.email=self.email;
    if (self.isProf==true) {
        self.detail.name=[[self.list objectAtIndex:indexPath.row] objectForKey:@"professor"];
    }else{
        self.detail.name=[[self.list objectAtIndex:indexPath.row] objectForKey:@"courseName"];
    }
    
    
//    [self presentViewController:self.myDetailUINavC animated:YES completion:nil];
    [self.navigationController pushViewController:self.detail animated:YES];
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
    UINavigationItem *searchNavItem = [[UINavigationItem alloc] init];
    searchNavItem.title = @"검색";

    [newNavBar setItems:@[searchNavItem]];
    [newNavBar setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:141.0f/255.0f blue:192.0f/255.0f alpha:1.0f]];
    [self.view addSubview:newNavBar];
}

- (void)connectForSearchList{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/showCourses"]];
    
    
    [request setHTTPMethod:@"GET"];
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
    NSLog(@"searchView: connectionDidFinishLoading");
    //    printf("\nSucceeded! Received %d bytes of data\n",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    ////    // extract specific value...
    
    
    self.list = [res objectForKey:@"courses"];
    
    
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
    if (self.mySegmentedControl.selectedSegmentIndex==0) {
        self.list=[self.list sortedArrayUsingDescriptors: [NSArray arrayWithObjects: [NSSortDescriptor sortDescriptorWithKey:@"professor" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO], nil]];
    }else{
        self.list=[self.list sortedArrayUsingDescriptors: [NSArray arrayWithObjects: [NSSortDescriptor sortDescriptorWithKey:@"courseName" ascending:YES], [NSSortDescriptor sortDescriptorWithKey:@"id" ascending:NO], nil]];
    }
    
    [self.searchList reloadData];
    
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
