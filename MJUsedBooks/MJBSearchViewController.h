//
//  MJBSearchViewController.h
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJBDetailSearchViewController.h"
@interface MJBSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property UITableView *searchList;
@property (nonatomic, strong) NSMutableData *responseData;
@property NSMutableArray *searchData;
@property UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) MJBDetailSearchViewController *detail;
@property (nonatomic, strong) UINavigationController *myDetailUINavC;
@property (nonatomic, strong) UISegmentedControl *mySegmentedControl;
@property NSArray *searchResults;
@property NSArray *list;
@property UIImageView *first,*sec;
@property NSString* email;
@property BOOL isProf;
@end
