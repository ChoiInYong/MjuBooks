//
//  MJBMyDealViewController.h
//  MJUsedBooks
//
//  Created by 5407-04 on 2015. 5. 29..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJBDetailViewController.h"
@interface MJBMyDealViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView *myDealTV;
@property NSString *email;
@property NSArray *myList;
@property NSMutableArray *mySList;
@property NSMutableArray *myBList;
@property NSMutableArray *mySBList;
@property BOOL isPhone;
@property NSIndexPath *index;
@property (nonatomic, strong) NSMutableData *responseData;
@property NSArray *temp;
@property (nonatomic, weak) IBOutlet UIImageView *first;
@property (nonatomic, weak) IBOutlet UIImageView *sec;
@property (nonatomic, weak) IBOutlet UIImageView *third;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property UIActivityIndicatorView *activityIndicator;
- (IBAction)segmentedValueChanged:(id)sender;
@property (nonatomic, weak) IBOutlet UITableView *myTableV;
@end
