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
@interface SaveIdeaViewController ()

@end

@implementation SaveIdeaViewController
@synthesize idea;
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
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
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
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/idea/save",baseURL]];
    NSString* reqBody = [NSString stringWithFormat:@"user_id=%@&pin=%@&person_id=%@&scene_id=%@&purpose_id=%@&description=%@",user_id,pin,[[self.idea objectForKey:@"person"]objectForKey:@"id"],[[self.idea objectForKey:@"scene"]objectForKey:@"id"],[[self.idea objectForKey:@"purpose"]objectForKey:@"id"],descriptionTextView.text];
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
        self.idea = [dic objectForKey:@"idea"];
        [SVProgressHUD showSuccessWithStatus:@"登録完了"];
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"登録失敗"];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
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

@end
