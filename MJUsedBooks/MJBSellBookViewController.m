//
//  MJBSellBookViewController.m
//  MJUsedBooks
//
//  Created by mju on 2015. 5. 24..
//  Copyright (c) 2015년 Myeong Jung. All rights reserved.
//

#import "MJBSellBookViewController.h"

@interface MJBSellBookViewController ()
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *professorName;
@property (weak, nonatomic) IBOutlet UITextField *lectureName;
@property (weak, nonatomic) IBOutlet UIButton *imageButton;
@property UIScrollView *scroll;
#define kOFFSET_FOR_KEYBOARD 155.0
@end

@implementation MJBSellBookViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"판매하기";
        [self.tabBarItem setImage:[UIImage imageNamed:@"create_new-26.png"]];
    }
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.scroll.delegate=self;
//    [self.view addSubview:self.scroll];
    return self;
}
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {

        [self setViewMovedUp:NO];
    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    [self setViewMovedUp:NO];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
//    if ([sender isEqual:mailTf])
//    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
        {
            [self setViewMovedUp:YES];
            [self setViewMovedUp:YES];
        }
//    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.responseData = [NSMutableData data];
    _bookImage = [UIImage imageNamed:@"default.png"];
    [self.bookImage setAccessibilityIdentifier:@"default"];
    [_bookImageView setImage:_bookImage];
    _bookState = @"";
    // Do any additional setup after loading the view from its nib.
    self.professorName.delegate=self;
    self.bookTitle.delegate=self;
    self.lectureName.delegate=self;
    self.price.delegate=self;
    
    
    NSError *error = nil;
    if (![[NSFileManager defaultManager] createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"upload"]
                                   withIntermediateDirectories:YES
                                                    attributes:nil
                                                         error:&error]) {
        NSLog(@"reating 'upload' directory failed: [%@]", error);
    }
    [self connectForBookNum];
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}
- (void)styleNavBar {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    UINavigationBar *newNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 64.0)];
    [newNavBar setTintColor:[UIColor blackColor]];
    UINavigationItem *sellBookNavItem = [[UINavigationItem alloc] init];
    sellBookNavItem.title = @"책 판매하기";
    
//    UIImage *backButtonImage = [UIImage imageNamed:@"Arrows-Back-icon-3.png"];
//    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(backTapped:)];
//    
//    sellBookNavItem.leftBarButtonItem = backBarButtonItem;
    
    [newNavBar setItems:@[sellBookNavItem]];
    [newNavBar setBackgroundColor:[UIColor colorWithRed:90.0f/255.0f green:141.0f/255.0f blue:192.0f/255.0f alpha:1.0f]];
    [self.view addSubview:newNavBar];
}

//- (void)backTapped:(id)sender {
//    //    [self.navigationController popViewControllerAnimated:YES];
//    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
//}

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
    }else if([[self.bookImageView image].accessibilityIdentifier isEqualToString:@"default"]){
        [weakSelf alertWithTitle:@"책 등록" message:@"사진을 선택하여 주십시오"];
    }else {
        NSString *temp=[NSString stringWithFormat:@"https://s3.amazonaws.com/mjusedbooks/pic_%d.jpg",self.picNum];
        
        NSLog(@"%@",temp);
        [self connectForBookName:[_bookTitle text] professor:[_professorName text] courseName:[_lectureName text] user:self.user bookStatus:_bookState price:[_price text] pictureUrl:temp];
//        
//            [self.tabBarController setSelectedIndex:1];
        
        [self upload];
        
        self.professorName.text=@"";
        self.price.text=@"";
        self.lectureName.text=@"";
        self.bookTitle.text=@"";
        self.bookImage = [UIImage imageNamed:@"default.png"];
        [self.bookImage setAccessibilityIdentifier:@"default"];
        [_bookImageView setImage:_bookImage];
        _bookState = @"";
        
        self.highQ.imageView.image=[UIImage imageNamed:@"unchecked.png"];
        [self.highQ setSelected:NO];
        
        self.middleQ.imageView.image=[UIImage imageNamed:@"unchecked.png"];
        [self.middleQ setSelected:NO];
        
        self.lowQ.imageView.image=[UIImage imageNamed:@"unchecked.png"];
        [self.middleQ setSelected:NO];
        
        [weakSelf alertWithTitle:@"책 등록" message:@"등록을 완료하였습니다"];
        [self.tabBarController setSelectedIndex:0];
//        [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
    }
}
- (IBAction)cancelButtonClicked:(id)sender
{
//    [self dismissViewControllerAnimated:YES completion:^{NSLog(@"controller dismissed");}];
    self.professorName.text=@"";
    self.price.text=@"";
    self.lectureName.text=@"";
    self.bookTitle.text=@"";
    self.bookImage = [UIImage imageNamed:@"default.png"];
    [self.bookImage setAccessibilityIdentifier:@"default"];
    [_bookImageView setImage:_bookImage];
    _bookState = @"";
    
    self.highQ.imageView.image=[UIImage imageNamed:@"unchecked.png"];
    [self.highQ setSelected:NO];
    
    self.middleQ.imageView.image=[UIImage imageNamed:@"unchecked.png"];
    [self.middleQ setSelected:NO];
    
    self.lowQ.imageView.image=[UIImage imageNamed:@"unchecked.png"];
    [self.middleQ setSelected:NO];
    
    [self.tabBarController setSelectedIndex:0];
    
}
- (void)connectForBookName:(NSString *)bookName professor:(NSString *)professor courseName:(NSString *)courseName user:(NSString *)user bookStatus:(NSString *)bookStatus price:(NSString *)price pictureUrl:(NSString*)pictureUrl
{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/postBook"]];
    
    NSString *postString = [NSString stringWithFormat:@"{\"bookName\":\"%@\",\"professor\":\"%@\",\"courseName\":\"%@\",\"user\":\"%@\",\"bookStatus\":\"%@\",\"price\":\"%@\",\"pictureUrl\":\"%@\"}", bookName, professor, courseName, user, bookStatus, price,pictureUrl];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSURLConnection *connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if (connection) {
    }
    else {}
}
- (void)connectForBookNum{
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://52.68.178.195:8000/maxBook"]];
    

    [request setHTTPMethod:@"GET"];
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
    
    
    
    //    printf("\nSucceeded! Received %d bytes of data\n",[self.responseData length]);
    
    // convert to JSON
    
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    id numV=[res objectForKey:@"result"];
    self.picNum=[numV intValue]+1;
    // show all values
//    for(id key in res) {
//        
//        id value = [res objectForKey:key];
//        
//        NSString *keyAsString = (NSString *)key;
//        NSString *valueAsString = (NSString *)value;
//        
//        NSLog(@"\nkey: %@", keyAsString);
//        NSLog(@"value: %@", valueAsString);
//    }
    
    // extract specific value...
//    NSArray *results = [res objectForKey:@"results"];
//    
//    for (NSDictionary *result in results) {
//        NSString *icon = [result objectForKey:@"icon"];
//        NSLog(@"icon: %@", icon);
//    }
    
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
    
    [self.bookImage setAccessibilityIdentifier:[NSString stringWithFormat:@"pic_%d.jpg",self.picNum]];//change name of image
    
    [self finishedPicker];
    
    [_bookImageView setImage:_bookImage];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self finishedPicker];
}

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

- (void)upload{
    NSString *temp=[NSString stringWithFormat:@"pic_%d.jpg",self.picNum];
    UIImage *img=self.bookImageView.image;
    
    img=[self resizeImage:img];
    
    NSString *path=[NSTemporaryDirectory() stringByAppendingPathComponent:temp];

    NSData *imageData=UIImageJPEGRepresentation(img, 0.8);;
    [imageData writeToFile:path atomically:YES];
    
    NSURL *url=[[NSURL alloc]initFileURLWithPath:path];
    
    self.uploadRequest=[AWSS3TransferManagerUploadRequest new];
    self.uploadRequest.bucket=@"mjusedbooks";
    
    self.uploadRequest.ACL=AWSS3ObjectCannedACLPublicRead;
    self.uploadRequest.key=temp;
    self.uploadRequest.contentType=@"image/jpg";
    self.uploadRequest.body=url;
    
    
    __weak MJBSellBookViewController *weakSelf=self;
    
    self.uploadRequest.uploadProgress=^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend){
        dispatch_sync(dispatch_get_main_queue(), ^{
            weakSelf.amountUploaded=totalBytesSent;
            weakSelf.filesize=totalBytesExpectedToSend;
            [weakSelf update];
        });
    };
    
    AWSS3TransferManager *tranferManager=[AWSS3TransferManager defaultS3TransferManager];
    [[tranferManager upload:self.uploadRequest] continueWithExecutor:[BFExecutor mainThreadExecutor] withBlock:^id(BFTask *task){
        
        if (task.error) {
            NSLog(@"%@",task.error);
        }else{
            NSLog(@"http://s3.amazonaws.com/mjbs3/test/search.png");
            
        }
        
        return nil;
    }];
}
- (void) update{
    self.progressLabel.text=[NSString stringWithFormat:@"Uploading:%.0f%%",((float)self.amountUploaded/(float)self.filesize) * 100];
    
}

//resize the image for speeding up the time of downloading
-(UIImage *)resizeImage:(UIImage *)image
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float maxHeight = 300.0;
    float maxWidth = 400.0;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = maxWidth/maxHeight;
    float compressionQuality = 0.8;//80 percent compression
    
    if (actualHeight > maxHeight || actualWidth > maxWidth)
    {
        if(imgRatio < maxRatio)
        {
            //adjust width according to maxHeight
            imgRatio = maxHeight / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = maxHeight;
        }
        else if(imgRatio > maxRatio)
        {
            //adjust height according to maxWidth
            imgRatio = maxWidth / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = maxWidth;
        }
        else
        {
            actualHeight = maxHeight;
            actualWidth = maxWidth;
        }
    }
    
    CGRect rect = CGRectMake(0.0, 0.0, actualWidth, actualHeight);
    UIGraphicsBeginImageContext(rect.size);
    [image drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData = UIImageJPEGRepresentation(img, compressionQuality);
    UIGraphicsEndImageContext();
//    return img;
    return [UIImage imageWithData:imageData];
    
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
