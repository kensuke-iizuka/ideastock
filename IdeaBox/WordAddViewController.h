//
//  WordAddViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/10/12.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordAddViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    NSMutableData* _mData;
    IBOutlet UITextField* wordTextField;
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIButton* removeKeyboardBtn;
}

@end
