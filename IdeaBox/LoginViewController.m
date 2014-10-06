//
//  LoginViewController.m
//  IdeaBox
//
//  Created by 井上裕太 on 2014/07/29.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "LoginViewController.h"

@implementation LoginViewController
-(void)viewDidLoad{
    [self loginCheck];
}

-(void)loginCheck{
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    if([pref objectForKey:@"UserID"] && [pref objectForKey:@"pin_code"]){
        [self performSegueWithIdentifier:@"successToLogin" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"successToLogin"]){
        
    }
}
@end
