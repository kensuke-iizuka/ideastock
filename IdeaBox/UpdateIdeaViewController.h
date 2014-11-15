//
//  UpdateIdeaViewController.h
//  IdeaStock
//
//  Created by InoueYuta on 2014/11/11.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
@interface UpdateIdeaViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate,UITextViewDelegate,GADInterstitialDelegate>{
    NSMutableData* _mData;
    IBOutlet UILabel* personLabel;
    IBOutlet UILabel* sceneLabel;
    IBOutlet UILabel* purposeLabel;
    IBOutlet UITextView* descTextView;
    IBOutlet UIButton* updateBtn;
    IBOutlet UIButton* removeKeyBoardBtn;
    IBOutlet UIButton* selectImageBtn;
    IBOutlet UIScrollView* scrollView;
    BOOL showFlag;
    BOOL setImageFlag;
}

@property(nonatomic,retain)NSMutableDictionary* idea;
@property(nonatomic,retain)IBOutlet UIImageView* imageView;
@property (strong, nonatomic) GADInterstitial *interstitial;
@property int ideaID;
@end
