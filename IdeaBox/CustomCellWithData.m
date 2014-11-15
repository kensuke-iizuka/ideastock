//
//  CustomCellWithData.m
//  IdeaBox
//
//  Created by InoueYuta on 2014/11/08.
//  Copyright (c) 2014年 YutaInoue. All rights reserved.
//

#import "CustomCellWithData.h"

@implementation CustomCellWithData
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
