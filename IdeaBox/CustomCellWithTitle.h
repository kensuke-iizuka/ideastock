//
//  CustomCellWithTitle.h
//  IdeaStock
//
//  Created by InoueYuta on 2014/11/09.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCellWithTitle : UITableViewCell
@property(weak,nonatomic)IBOutlet UILabel* titleLabel;
@property(weak,nonatomic)IBOutlet UILabel* descLabel;
@end
