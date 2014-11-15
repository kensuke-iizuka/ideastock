//
//  OverlayView.h
//  draggable
//
//  Created by InoueYuta on 2014/11/04.
//  Copyright (c) 2014年 InoueYuta. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, OverlayMode) {
    OverlayModeLeft,
    OverlayModeRight
};
@interface OverlayView : UIView
@property(nonatomic)OverlayMode mode;
@property(nonatomic,strong)UIImageView* imageView;
@end
