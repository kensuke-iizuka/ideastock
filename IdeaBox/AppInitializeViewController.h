//
//  AppInitializeViewController.h
//  IdeaBox
//
//  Created by 井上裕太 on 2014/07/29.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppInitializeViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSMutableData* _mData;
}

@end
