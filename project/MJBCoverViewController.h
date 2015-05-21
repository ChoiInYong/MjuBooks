//
//  MJBCoverViewController.h
//  
//
//  Created by Kyuseon on 2015. 5. 18..
//
//

#import <UIKit/UIKit.h>
#import "MJBMainViewController.h"


@interface MJBCoverViewController : UIViewController{
    
}

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) MJBMainViewController *mainView;
@property (strong, nonatomic) UINavigationController *navC;

- (IBAction)login:(id)sender;
@end
