//
//  IdeaListViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCell.h"
#import "CustomCellWithData.h"
#import "CustomCellWithTitle.h"
@interface IdeaListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSMutableData* _mData;
    CustomCell* _stubCell;
    CustomCellWithData* _stubCellWithData;
    CustomCellWithTitle* _stubCellWithTitle;
    BOOL addFlag;
    BOOL deleteFlag;
}

@property(nonatomic,retain)IBOutlet UITableView* myTableView;
@property(nonatomic,retain)NSMutableArray* ideaList;
@property int selectedCell;
@end
