//
//  IdeaboxViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DraggableView.h"
@interface IdeaboxViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    IBOutlet UILabel* personLabel;
    IBOutlet UILabel* sceneLabel;
    IBOutlet UILabel* purposeLabel;
    IBOutlet UIButton* allWordBtn;
    IBOutlet UIButton* myWordBtn;
    IBOutlet UILabel* timeLabel;
    NSMutableData* _mData;
}
@property(nonatomic,retain)NSMutableDictionary* idea;
@property(nonatomic,retain)NSMutableDictionary* idea2;
@property(nonatomic,retain)NSMutableArray* ideaList;
@property NSInteger selectedSegment;
@property int i;
@property int j;
@property(nonatomic,strong)DraggableView* draggableView;
@end
