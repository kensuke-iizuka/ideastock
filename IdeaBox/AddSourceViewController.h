//
//  AddSourceViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSourceViewController : UIViewController<NSURLConnectionDelegate,NSURLConnectionDataDelegate,UITableViewDataSource,UITableViewDelegate>{
    NSMutableData* _mData;
    CGPoint _touchBegan;
    IBOutlet UIImageView* bgImageView;
}

@property(nonatomic,strong)IBOutlet UITableView* wordTableView;
@property(nonatomic,strong)NSMutableArray* wordLists;
@property BOOL perFlag;
@property BOOL sceFlag;
@property BOOL purFlag;
@property BOOL postFlag;
@end
