//
//  MJBDetailViewController.h
//  MJUsedBooks
//
//  Created by 5407-04 on 2015. 6. 3..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJBDetailViewController : UIViewController

@property NSString *bookId;
@property NSString *email;

@property (weak, nonatomic) IBOutlet UIButton *button;
- (IBAction)buttonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *courseName;
@property (weak, nonatomic) IBOutlet UILabel *professor;
@property (weak, nonatomic) IBOutlet UILabel *price;

@property (nonatomic, strong) NSMutableData *responseData;
@property NSArray *list;
@property BOOL areYouSeller;
@property BOOL areYouBuyer;

@property UIActivityIndicatorView *activityIndicator;
@end
