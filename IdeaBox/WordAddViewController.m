//
//  WordAddViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/10/12.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "WordAddViewController.h"
#import "constants.h"
@interface WordAddViewController ()

@end

@implementation WordAddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [removeKeyboardBtn setEnabled:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addWord:(id)sender{
    _mData = [[NSMutableData alloc]init];
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/word/add",baseURL]];
    NSString* reqBody = [NSString stringWithFormat:@"user_id=%@&pin=%@&word=%@",user_id,pin,wordTextField.text];
    NSMutableURLRequest* req = [[NSMutableURLRequest alloc]initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[reqBody dataUsingEncoding:NSUTF8StringEncoding]];
    [NSURLConnection connectionWithRequest:req delegate:self];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{
    NSLog(@"%@",error);
}

-(void)connectionDidFinishLoading:(NSURLConnection*)connection{
    NSError* error;
    NSString* response = [[NSString alloc] initWithData:_mData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",response);
    NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:_mData options:0 error:&error];
    if([[dic objectForKey:@"result"] isEqualToString:@"success"]){
        [self.navigationController popViewControllerAnimated:YES];
    } else {
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    [removeKeyboardBtn setEnabled:YES];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3];
    [scrollView setContentSize:CGSizeMake(320, 710)];
    [scrollView setContentOffset:CGPointMake(0, 70)];
    [scrollView setScrollEnabled:NO];
    [UIView commitAnimations];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
