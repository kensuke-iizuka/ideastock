//
//  WordViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/10/12.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordViewController : UIViewController<NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSMutableData* _mData;
    IBOutlet UILabel* wordLabel;
}
@end
