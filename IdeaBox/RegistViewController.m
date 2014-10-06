//
//  RegistViewController.m
//  IdeaBox
//
//  Created by 井上裕太 on 2014/07/29.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "RegistViewController.h"
#import "SVProgressHUD.h"
#import "constants.h"

@implementation RegistViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(IBAction)regist:(id)sender{
    if([self checkMailTextfield]&&[self checkPasswordTextfield]&&[self checkConfirmPasswordTextfield]){
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

-(BOOL)checkConfirmPasswordTextfield{
    NSString* passwdText = [passwdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* confirmPasswdText = [confirmPasswdTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if(confirmPasswdText.length <= 0){
        [self makeAlert:@"確認用パスワードの入力" :@"確認用パスワードを入力してください"];
        return NO;
    } else {
        if (![confirmPasswdText isEqualToString:passwdText]) {
            [self makeAlert:@"パスワード不一致" :@"入力されたパスワードが一致していません"];
            return NO;
        } else {
            return YES;
        }
    }
}

-(void)makeAlert:(NSString*)title :(NSString*)text{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:text delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

-(void)post{
    _mData = [[NSMutableData alloc]init];
    [SVProgressHUD showWithStatus:@"登録中..." maskType:SVProgressHUDMaskTypeBlack];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@user/regist",baseURL]];
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
        [SVProgressHUD showSuccessWithStatus:@"登録成功"];
        [self performSelector:@selector(nextView) withObject:nil afterDelay:1.0];
    } else if([[dic objectForKey:@"message"] isEqualToString:@"mailexists"]){
        [SVProgressHUD showErrorWithStatus:@"このメールアドレスは既に登録されています"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"登録失敗"];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_mData appendData:data];
}

-(void)nextView{
    [self performSegueWithIdentifier:@"successRegister" sender:self];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    [removeKeyboardBtn setEnabled:YES];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    [removeKeyboardBtn setEnabled:NO];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentSize:CGSizeMake(320, 569)];
    [scrollView setContentOffset:CGPointMake(0, 0)];
    [scrollView setScrollEnabled:NO];
    [UIView commitAnimations];
}

-(IBAction)removeKeyboard:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)mailEdit:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentSize:CGSizeMake(320, 710)];
    [scrollView setContentOffset:CGPointMake(0, 80)];
    [scrollView setScrollEnabled:NO];
    [UIView commitAnimations];
}

- (IBAction)passwdEdit:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentSize:CGSizeMake(320, 710)];
    [scrollView setContentOffset:CGPointMake(0, 80)];
    [scrollView setScrollEnabled:NO];
    [UIView commitAnimations];
}

- (IBAction)confPasswdEdit:(id)sender{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentSize:CGSizeMake(320, 710)];
    [scrollView setContentOffset:CGPointMake(0, 80)];
    [scrollView setScrollEnabled:NO];
    [UIView commitAnimations];
}
@end
