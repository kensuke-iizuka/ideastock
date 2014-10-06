//
//  HTTPFileUpload.h
//  FWeedApp
//
//  Created by 井上裕太 on 2014/07/08.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol HTTPFileUploadDelegate;
@interface HTTPFileUpload : NSObject
{
@private
    NSMutableArray *postStrings, *postImages;
    NSMutableData *resultData;
}
@property(nonatomic, assign) id <HTTPFileUploadDelegate> delegate;

- (void)setPostString:(NSString *)stringValue withPostName:(NSString *)postName;
- (void)setPostImage:(UIImage *)image withPostName:(NSString *)postName fileName:(NSString *)fileName;
- (void)postWithUri:(NSString *)uri;
@end