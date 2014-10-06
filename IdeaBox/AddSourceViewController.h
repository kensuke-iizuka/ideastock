//
//  AddSourceViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSourceViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UIGestureRecognizerDelegate>{
    NSMutableData* _mData;
    int scroll_flag;
    IBOutlet UIScrollView* scrollView;
    CGPoint _touchBegan;
}

@end
