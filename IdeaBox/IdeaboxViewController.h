//
//  IdeaboxViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaboxViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    IBOutlet UILabel* personLabel;
    IBOutlet UILabel* sceneLabel;
    IBOutlet UILabel* purposeLabel;
    NSMutableData* _mData;
    CGPoint _touchBegan;
}
@property(nonatomic,retain)NSMutableDictionary* idea;
@property(nonatomic,retain)NSMutableArray* ideaList;
@property NSInteger selectedSegment;
@property int i;
@end
