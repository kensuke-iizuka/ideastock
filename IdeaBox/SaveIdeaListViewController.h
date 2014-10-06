//
//  SaveIdeaListViewController.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/08/06.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SaveIdeaListViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>{
    
}

@property(nonatomic,retain)IBOutlet UITableView* myTableView;
@property(nonatomic,retain)NSMutableArray* ideaList;
@property int i;
@property int selectedCell;

@end
