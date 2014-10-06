//
//  IdeaListViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/02.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IdeaListViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDataDelegate,NSURLConnectionDelegate>{
    NSMutableData* _mData;
}

@property(nonatomic,retain)IBOutlet UITableView* myTableView;
@property(nonatomic,retain)NSMutableArray* ideaList;
@property int selectedCell;
@end
