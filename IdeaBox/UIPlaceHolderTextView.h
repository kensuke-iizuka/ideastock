//
//  UIPlaceHolderTextView.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/11/08.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
@property (nonatomic, retain) NSString *placeholder;
@property (nonatomic, retain) UIColor *placeholderColor;
@property (nonatomic, retain) UILabel *placeHolderLabel;
-(void)textChanged:(NSNotification*)notification;
@end
