//
//  MJBPhoneViewController.h
//  project
//
//  Created by Kyuseon on 2015. 5. 19..
//  Copyright (c) 2015년 Kyuseon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MJBPhoneViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIButton *signUpButton;
@property (nonatomic, weak) IBOutlet UITextField *phonenumber;
@property (nonatomic, weak) NSString *name;
@property (nonatomic, weak) NSString *email;
@property (nonatomic, weak) UIImage *photo;
@end
