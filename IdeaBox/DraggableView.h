//
//  DraggableView.h
//  draggable
//
//  Created by InoueYuta on 2014/11/04.
//  Copyright (c) 2014年 InoueYuta. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OverlayView.h"
@interface DraggableView : UIView
@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic) CGPoint originalPoint;
@property(nonatomic, strong) OverlayView *overlayView;
@property(nonatomic,strong) UILabel* personLabel;
@property(nonatomic,strong) UILabel* sceneLabel;
@property(nonatomic,strong) UILabel* purposeLabel;

- (void)refreshContent:(NSMutableDictionary*)dic;
@end
