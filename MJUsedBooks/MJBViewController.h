//
//  MJBViewController.h
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 23..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJBAddInfoViewController.h"

@interface MJBViewController : UIViewController

@property (nonatomic, strong) MJBAddInfoViewController *addInfoViewController;
@property (nonatomic, strong) UINavigationController *navigationController;

@end
