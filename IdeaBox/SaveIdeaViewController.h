//
//  SaveIdeaViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveIdeaViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSMutableData* _mData;
    IBOutlet UILabel* personLabel;
    IBOutlet UILabel* sceneLabel;
    IBOutlet UILabel* purposeLabel;
    IBOutlet UITextView* descriptionTextView;
    IBOutlet UIButton* removeKeyboardBtn;
    IBOutlet UIScrollView* scrollView;
}

@property(nonatomic,retain)NSMutableDictionary* idea;

@end
