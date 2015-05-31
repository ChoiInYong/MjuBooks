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
    }
    return self;
}

- (void)viewDidLoad {
    self.responseData = [NSMutableData data];
    self.list=[[NSArray alloc]init];
    self.searchList=[[UITableView alloc]init];
    self.searchList = [[UITableView alloc] initWithFrame:CGRectMake(0, 70, 373, 530)];
    self.searchList.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.searchList.delegate = self;
    self.searchList.dataSource = self;
    [self.view addSubview:self.searchList];
   
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    self.searchBar.delegate = self;
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    
    self.searchList.tableHeaderView = self.searchBar;
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}
- (void)viewDidAppear:(BOOL)animated{
    [self connectForSearchList];
    
}
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"professor CONTAINS[cd] %@", searchText];
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Display recipe in the table cell
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.textLabel.text = [[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"professor"];
//        NSLog(@"searchResults index: %@",[[self.searchResults objectAtIndex:indexPath.row] objectForKey:@"professor"]);
    }else {
        cell.textLabel.text = [[self.list objectAtIndex:indexPath.row] objectForKey:@"professor"];
    }
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
    [newNavBar setTintColor:[UIColor whiteColor]];
    UINavigationItem *searchNavItem = [[UINavigationItem alloc] init];
    searchNavItem.title = @"검색";
    [newNavBar setItems:@[searchNavItem]];
    
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
