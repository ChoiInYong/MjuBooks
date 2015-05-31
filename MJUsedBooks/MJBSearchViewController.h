//
//  MJBSearchViewController.h
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJBSearchViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property UITableView *searchList;
@property (nonatomic, strong) NSMutableData *responseData;
@property NSMutableArray *searchData;
@property UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property NSArray *searchResults;
@property NSArray *list;
@end
