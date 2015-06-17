//
//  MJBSellBookViewController.h
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 24..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AWSS3/AWSS3.h>
#import <AWSCore/AWSCore.h>
#import <AWSCognito/AWSCognito.h>
//#import <AWSCore/AWSCore.h>
//#import <AWSCore/AWSService.h>
//#import <AWSS3/AWSS3.h>

@interface MJBSellBookViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate,UITextFieldDelegate>

@property NSString* user;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *registerButton;

@property (weak, nonatomic) IBOutlet UIButton *lowQ;
@property (weak, nonatomic) IBOutlet UIButton *middleQ;
@property (weak, nonatomic) IBOutlet UIButton *highQ;
@property (weak, nonatomic) IBOutlet UIImageView *bookImageView;
@property (weak, nonatomic) IBOutlet UITextField *bookTitle;
@property (nonatomic) UIImage *bookImage;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic) NSString *bookState;
@property (nonatomic,strong) AWSS3TransferManagerUploadRequest *uploadRequest;
@property (nonatomic) uint64_t filesize;
@property (nonatomic) uint64_t amountUploaded;
//@property (nonatomic) UIView *loadingBg;
//@property (nonatomic) UIView *progressView;
@property (nonatomic) UILabel *progressLabel;
@property int picNum;
//@property (nonatomic) AWSS3TransferManagerUploadRequest *uploadRequest;
//@property (nonatomic) uint64_t filesize;
//@property (nonatomic) uint64_t amountUploaded;

@end
