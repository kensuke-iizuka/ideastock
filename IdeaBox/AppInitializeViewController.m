//
//  AppInitializeViewController.m
//  IdeaBox
//
//  Created by 井上裕太 on 2014/07/29.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "AppInitializeViewController.h"
#import "TrackingManager.h"
@implementation AppInitializeViewController
-(void)viewDidLoad{
    [super viewDidLoad];
    [TrackingManager sendScreenTracking:@"トップ画面"];
}

-(void)setupView{
    scrollView.backgroundColor = [[UIColor alloc]initWithPatternImage:[UIImage imageNamed:@"top_bg"]];
    self.navigationController.navigationBarHidden=YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [self setupView];
    [self startAnimation];
    self.screenName = @"AppInitializeViewController";
}


-(void)startAnimation{
    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionCurveEaseIn animations:^{
        titleLabel.alpha = 1.0f;
        titleLabel2.alpha = 1.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            iconImageView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [NSTimer
             // タイマーイベントを発生させる間隔。「1.5」は 1.5秒 型は float
             scheduledTimerWithTimeInterval:2.5
             // 呼び出すメソッドの呼び出し先(selector) self はこのファイル(.m)
             target:self
             // 呼び出すメソッド名。「:」で自分自身(タイマーインスタンス)を渡す。
             // インスタンスを渡さない場合は、「timerInfo」
             selector:@selector(loginCheck)
             // 呼び出すメソッド内で利用するデータが存在する場合は設定する。ない場合は「nil」
             userInfo:nil
             // 上記で設定した秒ごとにメソッドを呼び出す場合は、「YES」呼び出さない場合は「NO」
             repeats:NO
             ];
        }];
    }];
}

-(void)loginRegisterAnimation{
    [UIView animateWithDuration:1.0f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
        loginBtn.alpha = 1.0f;
        registerBtn.alpha = 1.0f;
    } completion:^(BOOL finished) {
    }];
}

-(void)loginCheck{
    NSUserDefaults* pref = [NSUserDefaults standardUserDefaults];
    if([pref objectForKey:@"UserID"] && ![[pref objectForKey:@"UserID"]isEqualToString:@""]){
        [self performSegueWithIdentifier:@"loggedin" sender:self];
    } else {
        [self loginRegisterAnimation];
    }
}

-(IBAction)login:(id)sender{
    self.navigationController.navigationBarHidden=NO;
    [self performSegueWithIdentifier:@"login" sender:self];
}

-(IBAction)regist:(id)sender{
    self.navigationController.navigationBarHidden=NO;
    [self performSegueWithIdentifier:@"register" sender:self];
}
@end