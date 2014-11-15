//
//  WordViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/10/12.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "WordViewController.h"
#import "constants.h"

@interface WordViewController ()

@end

@implementation WordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)loadWord:(id)sender{
    _mData = [[NSMutableData alloc]init];
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    NSString* user_id = [pref objectForKey:@"UserID"];
    NSString* pin = [pref objectForKey:@"pin_code"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/word/generate",baseURL]];
    NSString* reqBody = [NSString stringWithFormat:@"user_id=%@&pin=%@",user_id,pin];
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
        wordLabel.text = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"word"]objectForKey:@"word"]];
    } else {
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_mData appendData:data];
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
