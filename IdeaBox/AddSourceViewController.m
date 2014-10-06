//
//  AddSourceViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "AddSourceViewController.h"
#import "constants.h"
#import "SVProgressHUD.h"
@implementation AddSourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(personInsert:) name:@"personInsert" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sceneInsert:) name:@"sceneInsert" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(purposeInsert:) name:@"purposeInsert" object:nil];
}

-(void)viewDidLayoutSubviews{
    [scrollView setContentSize:CGSizeMake(960, 519)];
    [scrollView setContentOffset:CGPointMake(0, 0)];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)personInsert:(NSNotification*)center{
    NSString* person = [[center userInfo]objectForKey:@"person"];
    [self post:@"person" text:person];
}

-(void)sceneInsert:(NSNotification*)center{
    NSString* scene = [[center userInfo]objectForKey:@"scene"];
    [self post:@"scene" text:scene];
}

-(void)purposeInsert:(NSNotification*)center{
    NSString* purpose = [[center userInfo]objectForKey:@"purpose"];
    [self post:@"purpose" text:purpose];
}
-(void)post:(NSString*)type text:(NSString*)text{
    _mData = [[NSMutableData alloc]init];
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    [SVProgressHUD showWithStatus:@"ソースを追加中" maskType:SVProgressHUDMaskTypeBlack];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@source/insert",baseURL]];
    NSString* reqBody = [NSString stringWithFormat:@"user_id=%@&pin=%@&type=%@&text=%@",user_id,pin,type,text];
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
        [SVProgressHUD showSuccessWithStatus:@"追加完了"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"追加失敗"];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
}

-(IBAction)changeView:(UIButton*)sender{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [scrollView setContentOffset:CGPointMake(320*sender.tag, 0)];
    [UIView commitAnimations];
}

@end
