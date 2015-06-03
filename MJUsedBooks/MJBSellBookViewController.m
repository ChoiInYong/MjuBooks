//
//  MJBSellBookViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 24..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBSellBookViewController.h"

#import <AWSCore.h>
#import <AWSS3TransferManager.h>
#import <AWSCredentialsProvider.h>
#import <AWSS3.h>

@interface MJBSellBookViewController ()
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *professorName;
@property (weak, nonatomic) IBOutlet UITextField *lectureName;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;

@end

@implementation MJBSellBookViewController

- (void)uploadFileToS3:(NSString*)fileName
{
    
    NSString *directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [directoryPath stringByAppendingPathComponent:fileName];
//    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    AWSS3TransferManagerUploadRequest *uploadRequest = [[AWSS3TransferManagerUploadRequest alloc]init];
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    uploadRequest.bucket = @"mjbs3";
    uploadRequest.key = fileName;
    uploadRequest.body = [NSURL fileURLWithPath:filePath];
    BFTask *task = [transferManager upload:uploadRequest];
    [task continueWithBlock:^id(BFTask *task)
     {
         if (task.error)
         {
             if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain])
             {
                 switch (task.error.code)
                 {
                     case AWSS3TransferManagerErrorCancelled:
                         NSLog(@"Upload failed (cancel): [%@]", task.error);
                         break;
                     case AWSS3TransferManagerErrorPaused:
                         NSLog(@"Upload failed (pause): [%@]", task.error);
                         break;
                     default:
                         NSLog(@"Upload failed (default): [%@]", task.error);
                         break;
                 }
             } else
             {
                 NSLog(@"Upload failed (other): [%@]", task.error);
             }
         }
         if (task.result)
         {
         }
         return nil;
     }];
}

- (NSString*)getUniqueFileName
{
    NSString *fileName = [[[NSProcessInfo processInfo] globallyUniqueString] stringByAppendingString:@".png"];
    return fileName;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.responseData = [NSMutableData data];
    _bookImage = [UIImage imageNamed:@"defaultImage.png"];
    [_bookImageView setImage:_bookImage];
    _bookState = @"";
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.hidesBottomBarWhenPushed = YES;
    [self styleNavBar];
}

- (void)styleNavBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    [newNavBar setTintColor:[UIColor blackColor]];
    UINavigationItem *sellBookNavItem = [[UINavigationItem alloc] init];
    sellBookNavItem.title = @"책 판매하기";
    
    UIImage *backButtonImage = [UIImage imageNamed:@"Arrows-Back-icon-3.png"];
    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
    
    sellBookNavItem.leftBarButtonItem = backBarButtonItem;
    
    [newNavBar setItems:@[sellBookNavItem]];
    [self.view addSubview:newNavBar];
}

- (void)backTapped:(id)sender {
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:@"확인" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)registerButtonClicked:(id)sender
{
    __weak MJBSellBookViewController *weakSelf = self;
    if ([[_bookTitle text] isEqualToString:@""]) {
        [weakSelf alertWithTitle:@"책 등록" message:@"책 제목을 입력하여 주십시오"];
    }else if ([[_professorName text] isEqualToString:@""]) {
        [weakSelf alertWithTitle:@"책 등록" message:@"교수명을 입력하여 주십시오"];
    }else if ([[_lectureName text] isEqualToString:@""]) {
        [weakSelf alertWithTitle:@"책 등록" message:@"강좌명을 입력하여 주십시오"];
    }else if ([_bookState isEqualToString:@""]) {
        [weakSelf alertWithTitle:@"책 등록" message:@"책 상태를 선택하여 주십시오"];
    }else if ([[_price text] isEqualToString:@""]) {
        [weakSelf alertWithTitle:@"책 등록" message:@"가격을 입력하여 주십시오"];
    }else {
        [self connectForBookName:[_bookTitle text] professor:[_professorName text] courseName:[_lectureName text] user:nil bookStatus:_bookState price:[_price text]];
        [self uploadFileToS3:[self getUniqueFileName]];
        //        [self createLoadingView];
        //        [self uploadToS3];
        [weakSelf alertWithTitle:@"책 등록" message:@"등록을 완료하였습니다"];
        [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
    }
}

- (void)connectForBookName:(NSString *)bookName professor:(NSString *)professor courseName:(NSString *)courseName user:(NSString *)user bookStatus:(NSString *)bookStatus price:(NSString *)price
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/postBook"]];
    
    NSString *postString = [NSString stringWithFormat:@"{\"bookName\":\"%@\",\"professor\":\"%@\",\"courseName\":\"%@\",\"user\":\"%@\",\"bookStatus\":\"%@\",\"price\":\"%@\"}", bookName, professor, courseName, user, bookStatus, price];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
    }
    else {}
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [self.responseData setLength:0];
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Data Failure");
}

// Following function will show you the result mainly
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    
    // 이 아래 지워도되는것 다지우기
    
    //    printf("\nSucceeded! Received %d bytes of data\n",[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    // show all values
    for(id key in res) {
        
        id value = [res objectForKey:key];
        
        NSString *keyAsString = (NSString *)key;
        NSString *valueAsString = (NSString *)value;
        
        NSLog(@"\nkey: %@", keyAsString);
        NSLog(@"value: %@", valueAsString);
    }
    
    // extract specific value...
    NSArray *results = [res objectForKey:@"results"];
    
    for (NSDictionary *result in results) {
        NSString *icon = [result objectForKey:@"icon"];
        NSLog(@"icon: %@", icon);
    }
    
}

- (IBAction)runGeneralPicker:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    //사용할 소스 설정
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    picker.allowsEditing = NO; //편집여부
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)finishedPicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    _bookImage = nil;
    _bookImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [self finishedPicker];
    
    [_bookImageView setImage:_bookImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self finishedPicker];
}



//- (void)uploadToS3
//{
//    UIImage *img = _bookImageView.image;
//
//    NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:@"image.png"];
//    NSData *imageData = UIImagePNGRepresentation(img);
//    [imageData writeToFile:path atomically:YES];
//
//    NSURL *url = [[NSURL alloc] initFileURLWithPath:path];
//
//    _uploadRequest = [AWSS3TransferManagerUploadRequest new];
//    _uploadRequest.bucket = @"mjbs3";
//
//    _uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
//    _uploadRequest.key = @"mjusedbook/image.png";
//    _uploadRequest.contentType = @"image/png";
//    _uploadRequest.body = url;
//
//    __weak MJBSellBookViewController *weakSelf = self;
//
//    _uploadRequest.uploadProgress = ^(int64_t byteSent, int64_t totalBytesSent, int64_t totalBytesExpendedToSend){
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            weakSelf.amountUploaded = totalBytesSent;
//            weakSelf.filesize = totalBytesExpendedToSend;
//            [weakSelf update];
//        });
//    };
//
//    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
//    [[transferManager upload:_uploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task) {
//        if (task.error) {
//            NSLog(@"%@", task.error);
//        }else{
//            NSLog(@"https://s3.amazonaws.com/mjbs3/mjusedbook/image.png");
//        }
//        return nil;
//    }];
//}
//
//- (void)update
//{
//    float uploadingPercent = ((float)self.amountUploaded)/(float)self.filesize * 100;
//    _progressLabel.text = [NSString stringWithFormat:@"업로딩 중:%.0f%%", uploadingPercent];
//    __weak MJBSellBookViewController *weakSelf = self;
//    if (uploadingPercent == 100) {
//        [weakSelf alertWithTitle:@"책 등록" message:@"등록을 완료하였습니다"];
//        [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
//    }
//}
//
//- (void)createLoadingView
//{
//    _loadingBg = [[UIView alloc] initWithFrame:self.view.frame];
//    [_loadingBg setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.35]];
//    [self.view addSubview:_loadingBg];
//
//    _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
//    _progressView.center = self.view.center;
//    [_progressView setBackgroundColor:[UIColor whiteColor]];
//    [_loadingBg addSubview:_progressView];
//
//    _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
//    [_progressLabel setTextAlignment:NSTextAlignmentCenter];
//    [_progressView addSubview:_progressLabel];
//
//    _progressLabel.text = @"업로딩 중:";
//}

- (IBAction)higiQButtonClicked:(id)sender
{
    [_highQ setSelected:YES];
    
    [_highQ setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [_middleQ setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];
    [_lowQ setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];
    _bookState = @"상";
}

- (IBAction)middleQButtonClicked:(id)sender
{
    [_middleQ setSelected:YES];
    
    [_highQ setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];
    [_middleQ setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    [_lowQ setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];
    _bookState = @"중";
}

- (IBAction)lowQButtonClicked:(id)sender
{
    [_lowQ setSelected:YES];
    
    [_highQ setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];
    [_middleQ setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateSelected];
    [_lowQ setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateSelected];
    _bookState = @"하";
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
