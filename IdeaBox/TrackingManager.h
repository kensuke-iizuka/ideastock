//
//  TrackingManager.h
//  IdeaStock
//
//  Created by InoueYuta on 2014/11/11.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TrackingManager : NSObject
// スクリーン名計測用メソッド
+ (void)sendScreenTracking:(NSString *)screenName;

// イベント計測用メソッド
+ (void)sendEventTracking:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value screen:(NSString *)screen ;
@end
