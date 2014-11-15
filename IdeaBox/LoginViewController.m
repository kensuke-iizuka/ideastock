//
//  LoginViewController.m
//  IdeaBox
//
//  Created by 井上裕太 on 2014/07/29.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "LoginViewController.h"
#import "SVProgressHUD.h"
#import "constants.h"
#import "TrackingManager.h"
@implementation LoginViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [TrackingManager sendScreenTracking:@"ログイン画面"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    scrollView.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"top_bg"]];
}

-(void)viewDidLayoutSubviews{
    scrollView.contentSize = CGSizeMake(320, 568);
}
-(IBAction)login:(id)sender{
    if([self checkMailTextfield]&&[self checkPasswordTextfield]){
        [self post];
    }
}

-(BOOL)checkMailTextfield{
    NSString* inputText = [mailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(inputText.length <= 0){
        [self makeAlert:@"メールアドレスの入力" :@"メールアドレスを入力してください"];
        return NO;
    } else {
        return YES;
    }
}

-(BOOL)checkPasswordTextfield{
    NSString* inputText = [passwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(inputText.length <= 0){
        [self makeAlert:@"パスワードの入力" :@"パスワードを入力してください"];
        return NO;
    } else {
        return YES;
    }
}


-(void)makeAlert:(NSString*)title :(NSString*)text{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)post{
    _mData = [[NSMutableData alloc]init];
    [SVProgressHUD showWithStatus:@"ログイン中..." maskType:SVProgressHUDMaskTypeBlack];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/user/login",baseURL]];
    NSString* reqBodyStr = [NSString stringWithFormat:@"mail=%@&password=%@",mailTextField.text,passwdTextField.text];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc]initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[reqBodyStr dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
    [SVProgressHUD showErrorWithStatus:@"エラー"];
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSError* error;
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:_mData options:0 error:&error];
    if([[dic objectForKey:@"result"] isEqualToString:@"success"]){
        NSString* userID = [dic objectForKey:@"user_id"];
        NSString* pin = [dic objectForKey:@"pin"];
        NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
        [pref setObject:userID forKey:@"UserID"];
        [pref setObject:pin forKey:@"pin_code"];
        [pref synchronize];
        [SVProgressHUD showSuccessWithStatus:@"ログイン成功"];
        [self performSelector:@selector(nextView) withObject:nil afterDelay:1.0];
    } else if([[dic objectForKey:@"message"] isEqualToString:@"mailnotexists"]){
        [SVProgressHUD showErrorWithStatus:@"このメールアドレスは登録されていません"];
    } else if([[dic objectForKey:@"message"] isEqualToString:@"authenticationfailed"]){
        [SVProgressHUD showErrorWithStatus:@"メールアドレスまたは、パスワードが間違っています"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"ログイン失敗"];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_mData appendData:data];
}

-(void)nextView{
    [self performSegueWithIdentifier:@"successLogin" sender:self];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    [removeKeyboardBtn setEnabled:YES];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完了" style:UIBarButtonItemStyleBordered target:self action:@selector(removeKeyboard:)];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [removeKeyboardBtn setEnabled:NO];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentSize:CGSizeMake(320, 569)];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [scrollView setScrollEnabled:NO];
    [UIView commitAnimations];
    self.navigationItem.rightBarButtonItem = nil;
}

-(IBAction)removeKeyboard:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)mailEdit:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentSize:CGSizeMake(320, 680)];
    [scrollView setContentOffset:CGPointMake(0, 70)];
    [scrollView setScrollEnabled:NO];
    [UIView commitAnimations];
}

- (IBAction)passwdEdit:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentOffset:CGPointMake(0, 90)];
    [scrollView setScrollEnabled:NO];
    [UIView commitAnimations];
}
@end
