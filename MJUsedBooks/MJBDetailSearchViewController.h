//
//  MJBDetailSearchViewController.h
//  MJUsedBooks
//
//  Created by Kyuseon on 2015. 5. 31..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJBDetailSearchViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property UITableView *detailSearchList;
@property NSArray *detailList;
@property NSMutableData *responseData;
@property UIView *emptyView;
@property BOOL isProf;
@property UILabel *emptyLabel;
@property NSString *name;
@end
