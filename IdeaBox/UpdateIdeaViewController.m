//
//  UpdateIdeaViewController.m
//  IdeaStock
//
//  Created by InoueYuta on 2014/11/11.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "UpdateIdeaViewController.h"
#import "JMImageCache.h"
#import "SVProgressHUD.h"
#import "HTTPFileUpload.h"
#import "constants.h"
#import "TrackingManager.h"
@interface UpdateIdeaViewController ()

@end

@implementation UpdateIdeaViewController
@synthesize idea;
- (void)viewDidLoad {
    [super viewDidLoad];
    [TrackingManager sendScreenTracking:@"アイディア更新画面"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successPost) name:@"successPostIdea" object:nil];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    descTextView.delegate = self;
    setImageFlag = NO;
    [self loadInterstitial];
}

-(void)viewDidLayoutSubviews{
    [scrollView setContentSize:CGSizeMake(320, 519)];
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
    if(showFlag){
        [self backView];
    }
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self setData];
    showFlag = NO;
}

-(IBAction)postUpdate:(id)sender{
    _mData = [[NSMutableData alloc]init];
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    [SVProgressHUD showWithStatus:@"タイムラインを取得中" maskType:SVProgressHUDMaskTypeBlack];
    HTTPFileUpload* httpFileUpload = [[HTTPFileUpload alloc]init];
    [httpFileUpload setPostString:user_id withPostName:@"user_id"];
    [httpFileUpload setPostString:pin withPostName:@"pin"];
    [httpFileUpload setPostString:[self.idea objectForKey:@"id"] withPostName:@"id"];
    [httpFileUpload setPostString:[[self.idea objectForKey:@"person"]objectForKey:@"id"] withPostName:@"person_id"];
    [httpFileUpload setPostString:[[self.idea objectForKey:@"scene"]objectForKey:@"id"] withPostName:@"scene_id"];
    [httpFileUpload setPostString:[[self.idea objectForKey:@"purpose"]objectForKey:@"id"] withPostName:@"purpose_id"];
    [httpFileUpload setPostString:descTextView.text withPostName:@"description"];
    if(setImageFlag){
        [httpFileUpload setPostImage:self.imageView.image withPostName:@"upload_image" fileName:@"image.png"];
    }
    [httpFileUpload postWithUri:[NSString stringWithFormat:@"%@/idea/update",baseURL]];
}

-(void)successPost{
    showFlag = YES;
    [self showInterstitial];
    [self performSelector:@selector(backView) withObject:nil afterDelay:1.0];
}
-(void)backView{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"removeIdea" object:nil userInfo:@{@"ideaID":[NSString stringWithFormat:@"%d",self.ideaID]}];
    [self performSegueWithIdentifier:@"successUpdate" sender:self];
}

-(void)setData{
    personLabel.text = [NSString stringWithFormat:@"%@",[[idea objectForKey:@"person"]objectForKey:@"title"]];
    sceneLabel.text = [NSString stringWithFormat:@"%@",[[idea objectForKey:@"scene"]objectForKey:@"title"]];
    purposeLabel.text = [NSString stringWithFormat:@"%@",[[idea objectForKey:@"purpose"]objectForKey:@"title"]];
    descTextView.text = [NSString stringWithFormat:@"%@",[idea objectForKey:@"description"]];
    [self loadImage:[NSString stringWithFormat:@"%@",[[idea objectForKey:@"image"] objectForKey:@"url"]] imageView:self.imageView];
}

// imageのロード
-(void)loadImage:(NSString*)imageUrl imageView:(UIImageView*)imageView{
    [[JMImageCache sharedCache]imageForURL:[NSURL URLWithString:imageUrl] completionBlock:^(UIImage *image) {
        [imageView setAlpha:0];
        [UIView animateWithDuration:0.5 animations:^{
            [imageView setImage:image];
            [imageView setAlpha:1];
        }];
    }];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    [removeKeyBoardBtn setEnabled:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完了" style:UIBarButtonItemStyleBordered target:self action:@selector(removeKeyboard:)];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [removeKeyBoardBtn setEnabled:NO];
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
        self.imageView.image = [info objectForKey:UIImagePickerControllerEditedImage];
        setImageFlag = YES;
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)removeKeyboard:(id)sender{
    [self.view endEditing:YES];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentSize:CGSizeMake(320, 710)];
    [scrollView setContentOffset:CGPointMake(0, 80)];
    [scrollView setScrollEnabled:NO];
    [UIView commitAnimations];
}

@end
