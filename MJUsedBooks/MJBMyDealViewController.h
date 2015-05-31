//
//  MJBMyDealViewController.h
//  MJUsedBooks
//
//  Created by 5407-04 on 2015. 5. 29..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJBMyDealViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIView *sellView;
@property (strong, nonatomic) IBOutlet UIView *buyView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;

- (IBAction)segmentedValueChanged:(id)sender;

@end
