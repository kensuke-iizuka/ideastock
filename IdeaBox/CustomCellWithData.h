//
//  CustomCellWithData.h
//  IdeaBox
//
//  Created by InoueYuta on 2014/11/08.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellWithData : UITableViewCell
@property(weak,nonatomic)IBOutlet UILabel* personLabel;
@property(weak,nonatomic)IBOutlet UILabel* sceneLabel;
@property(weak,nonatomic)IBOutlet UILabel* purposeLabel;
@property(weak,nonatomic)IBOutlet UILabel* descLabel;
@end
