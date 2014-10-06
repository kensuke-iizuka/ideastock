//
//  AppInitializeViewController.m
//  IdeaBox
//
//  Created by 井上裕太 on 2014/07/29.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "AppInitializeViewController.h"

@implementation AppInitializeViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [self animation];
    [self loginCheck];
}

-(void)animation{
    
}

-(void)loginCheck{
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    if([pref objectForKey:@"UserID"] && ![[pref objectForKey:@"UserID"]isEqualToString:@""]){
        [self performSegueWithIdentifier:@"loggedin" sender:self];
    } else {
        [self performSegueWithIdentifier:@"login" sender:self];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([[segue identifier]isEqualToString:@"login"]){
        
    } else if([[segue identifier]isEqualToString:@"loggedin"]){
        
    }
}
@end