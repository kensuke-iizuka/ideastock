//
//  IdeaDetailViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/03.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaDetailViewController : UIViewController{
    IBOutlet UILabel* personLabel;
    IBOutlet UILabel* sceneLabel;
    IBOutlet UILabel* purposeLabel;
    IBOutlet UITextView* textView;
    IBOutlet UIImageView* imageView;
    IBOutlet UILabel* titleLabel;
}

@property(nonatomic,retain)NSMutableDictionary* idea;
@end
