//
//  SettingViewController.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "SettingViewController.h"
#import "TrackingManager.h"
@interface SettingViewController ()

@end

@implementation SettingViewController

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
    [TrackingManager sendScreenTracking:@"設定画面"];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg"]];
    NSString* version = @"1.0.0";
    versionLabel.text = version;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)logout:(id)sender{
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    [pref setObject:nil forKey:@"UserID"];
    [pref setObject:nil forKey:@"pin_code"];
    [self performSegueWithIdentifier:@"logout" sender:self];
}

@end
