//
//  MJBCoverViewController.h
//  
//
//  Created by Kyuseon on 2015. 5. 18..
//
//

#import <UIKit/UIKit.h>
#import "MJBFacebookViewController.h"

@interface MJBCoverViewController : UIViewController{
    
}

@property (nonatomic, weak) IBOutlet UIButton *loginButton;

@property (strong, nonatomic) MJBFacebookViewController *faceView;
- (IBAction)login:(id)sender;
@end
