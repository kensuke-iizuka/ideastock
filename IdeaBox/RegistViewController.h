//
//  RegistViewController.h
//  IdeaBox
//
//  Created by 井上裕太 on 2014/07/29.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegistViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    NSMutableData* _mData;
    IBOutlet UITextField* mailTextField;
    IBOutlet UITextField* passwdTextField;
    IBOutlet UITextField* confirmPasswdTextField;
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIButton* removeKeyboardBtn;
}

@end
