//
//  AppInitializeViewController.h
//  IdeaBox
//
//  Created by 井上裕太 on 2014/07/29.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GAITrackedViewController.h"
@interface AppInitializeViewController : GAITrackedViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSMutableData* _mData;
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIImageView* iconImageView;
    IBOutlet UILabel* titleLabel;
    IBOutlet UILabel* titleLabel2;
    IBOutlet UIButton* loginBtn;
    IBOutlet UIButton* registerBtn;
}

@end
