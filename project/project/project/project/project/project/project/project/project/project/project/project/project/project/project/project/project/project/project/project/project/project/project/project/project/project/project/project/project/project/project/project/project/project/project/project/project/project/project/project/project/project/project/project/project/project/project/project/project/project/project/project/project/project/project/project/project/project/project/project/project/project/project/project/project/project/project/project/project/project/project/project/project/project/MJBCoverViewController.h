//
//  MJBCoverViewController.h
//  
//
//  Created by Kyuseon on 2015. 5. 18..
//
//

#import <UIKit/UIKit.h>

@class MJBMainViewController;//import the MJBMainViewController class
@interface MJBCoverViewController : UIViewController{
    MJBMainViewController *mainView;//make the property of MJBMainController
}

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UIButton *facebookButton;

- (IBAction)login:(id)sender;
@end
