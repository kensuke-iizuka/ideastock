//
//  SaveIdeaViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GADInterstitial.h"
#import "UIPlaceHolderTextView.h"
@interface SaveIdeaViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate,GADInterstitialDelegate>{
    NSMutableData* _mData;
    IBOutlet UILabel* personLabel;
    IBOutlet UILabel* sceneLabel;
    IBOutlet UILabel* purposeLabel;
    IBOutlet UIButton* removeKeyboardBtn;
    IBOutlet UIScrollView* scrollView;
    IBOutlet UIImageView* imageView;
    IBOutlet UIButton* imageSelectBtn;
    BOOL showFlag;
}
@property(nonatomic,retain)UIPlaceHolderTextView* descriptionTextView;
@property(nonatomic,retain)NSMutableDictionary* idea;
@property (strong, nonatomic) GADInterstitial *interstitial;
@property int ideaID;
@end
