//
//  SaveIdeaViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "SaveIdeaViewController.h"
#import "constants.h"
#import "SVProgressHUD.h"
#import "HTTPFileUpload.h"
#import "TrackingManager.h"
@interface SaveIdeaViewController ()

@end

@implementation SaveIdeaViewController
@synthesize idea;
@synthesize ideaID;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [TrackingManager sendScreenTracking:@"一時アイディア保存画面"];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successPost) name:@"successPostIdea" object:nil];
    self.view.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"bg"]];
    scrollView.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"bg"]];
    [self makeView];
    [self loadInterstitial];
}

-(void)makeView{
    self.descriptionTextView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(15, 190, 290, 140)];
    self.descriptionTextView.placeholder = [NSString stringWithFormat:@"説明文"];
    [scrollView addSubview:self.descriptionTextView];
}

-(void)viewDidLayoutSubviews{
    [scrollView setContentSize:CGSizeMake(320, 570)];
}
- (void)loadInterstitial {
    //Call this method as soon as you can - loadRequest will run in the background and your interstitial will be ready when you need to show it
    self.interstitial = [[GADInterstitial alloc] init];
    self.interstitial.delegate = self;
    self.interstitial.adUnitID = MY_INTERSTITIAL_UNIT_ID;
    GADRequest *request = [GADRequest request];
    request.testDevices = @[@"698c8df8524babaea9b65e6c5a42a5262ecf8e50"];
    [self.interstitial loadRequest:request];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad
{
    //An interstitial object can only be used once - so it's useful to automatically load a new one when the current one is dismissed
    [self loadInterstitial];
}

- (void)interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error
{
    //If an error occurs and the interstitial is not received you might want to retry automatically after a certain interval
    [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(loadInterstitial) userInfo:nil repeats:NO];
}

- (void)showInterstitial
{
    //Call this method when you want to show the interstitial - the method should double check that the interstitial has not been used before trying to present it
    [self.interstitial presentFromRootViewController:self];
    if(showFlag){
        [self backView];
    }
}


-(void)viewDidAppear:(BOOL)animated{
    showFlag = YES;
    [super viewDidAppear:animated];
    [self setIdea];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)postWithDescription:(id)sender{
    _mData = [[NSMutableData alloc]init];
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    [SVProgressHUD showWithStatus:@"タイムラインを取得中" maskType:SVProgressHUDMaskTypeBlack];
    HTTPFileUpload* httpFileUpload = [[HTTPFileUpload alloc]init];
    [httpFileUpload setPostString:user_id withPostName:@"user_id"];
    [httpFileUpload setPostString:pin withPostName:@"pin"];
    [httpFileUpload setPostString:[[self.idea objectForKey:@"person"]objectForKey:@"id"] withPostName:@"person_id"];
    [httpFileUpload setPostString:[[self.idea objectForKey:@"scene"]objectForKey:@"id"] withPostName:@"scene_id"];
    [httpFileUpload setPostString:[[self.idea objectForKey:@"purpose"]objectForKey:@"id"] withPostName:@"purpose_id"];
    [httpFileUpload setPostString:self.descriptionTextView.text withPostName:@"description"];
    [httpFileUpload setPostImage:imageView.image withPostName:@"upload_image" fileName:@"image.png"];
    [httpFileUpload postWithUri:[NSString stringWithFormat:@"%@/idea/save",baseURL]];
}

-(void)successPost{
    showFlag = YES;
    [self showInterstitial];
    [self performSelector:@selector(backView) withObject:nil afterDelay:1.0];
}

-(void)backView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeIdea" object:nil userInfo:@{@"ideaID":[NSString stringWithFormat:@"%d",self.ideaID]}];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setIdea{
    personLabel.text = [NSString stringWithFormat:@"%@",[[self.idea objectForKey:@"person"]objectForKey:@"title"]];
    sceneLabel.text = [NSString stringWithFormat:@"%@",[[self.idea objectForKey:@"scene"]objectForKey:@"title"]];
    purposeLabel.text = [NSString stringWithFormat:@"%@",[[self.idea objectForKey:@"purpose"]objectForKey:@"title"]];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    [removeKeyboardBtn setEnabled:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentOffset:CGPointMake(0, 70)];
    [scrollView setScrollEnabled:NO];
    [UIView commitAnimations];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完了" style:UIBarButtonItemStyleBordered target:self action:@selector(removeKeyboard:)];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [removeKeyboardBtn setEnabled:NO];
    self.navigationItem.rightBarButtonItem = nil;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentSize:CGSizeMake(320, 554)];
    [scrollView setContentOffset:CGPointMake(0, -64)];
    [scrollView setScrollEnabled:YES];
    [UIView commitAnimations];
}

-(IBAction)showActionSheet:(id)sender{
    UIActionSheet * sheet = [[UIActionSheet alloc]
                             initWithTitle:@"画像の追加"
                             delegate:self
                             cancelButtonTitle:@"キャンセル"
                             destructiveButtonTitle:nil
                             otherButtonTitles:@"カメラ",@"ギャラリー", nil];
    [sheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    [sheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [self selectPhotoFromCamera];
            break;
        case 1:
            [self selectPhotoFromPicker];
            break;
        default:
            break;
    }
}

-(void)selectPhotoFromPicker{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController* ipc = [[UIImagePickerController alloc]init];
        [ipc setDelegate:self];
        [ipc setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        [ipc setAllowsEditing:YES];
        
        [self.navigationController presentViewController:ipc animated:YES completion:nil];
    }
}

- (void)selectPhotoFromCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        UIImagePickerController* ipc = [[UIImagePickerController alloc]init];
        [ipc setDelegate:self];
        [ipc setSourceType:UIImagePickerControllerSourceTypeCamera];
        [ipc setCameraCaptureMode:UIImagePickerControllerCameraCaptureModePhoto];
        [ipc setAllowsEditing:YES];
        [self.navigationController presentViewController:ipc animated:NO completion:nil];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [self dismissViewControllerAnimated:YES completion:^{
        imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)removeKeyboard:(id)sender{
    [self.view endEditing:YES];
}

@end
